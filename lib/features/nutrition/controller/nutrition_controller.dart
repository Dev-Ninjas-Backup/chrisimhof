import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/realtime/realtime_socket_service.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/service/dashboard_service.dart';

class MealItem {
  final String id;
  final String name;
  final String time;
  final String type; // 'Light', 'Medium', 'Heavy'
  final bool isLogged;
  final bool isPlanned;
  final String? occurredAt;

  MealItem({
    this.id = '',
    required this.name,
    required this.time,
    required this.type,
    required this.isLogged,
    required this.isPlanned,
    this.occurredAt,
  });

  MealItem copyWith({
    String? id,
    String? name,
    String? time,
    String? type,
    bool? isLogged,
    bool? isPlanned,
    String? occurredAt,
  }) {
    return MealItem(
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      type: type ?? this.type,
      isLogged: isLogged ?? this.isLogged,
      isPlanned: isPlanned ?? this.isPlanned,
      occurredAt: occurredAt ?? this.occurredAt,
    );
  }
}

class NutritionController extends GetxController {
  final RxInt dailyTarget = 5.obs;
  final RxString selectedMealType = 'Light'.obs;

  final RxList<MealItem> mealsList = <MealItem>[].obs;

  final RxList<String> notesList = <String>[].obs;
  final RxnString sleepImpactNote = RxnString();

  int get loggedMealsCount => mealsList.where((m) => m.isLogged).length;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    await loadNutritionData();
    await fetchNotes();
    try {
      final dbController = Get.find<DashboardController>();
      if (dbController.nutritionTabData.value != null) {
        updateFromLiveScoresTab(dbController.nutritionTabData.value!);
      }
    } catch (_) {}
  }

  Future<void> deleteMealLog(String entryId) async {
    if (entryId.isEmpty) return;
    final sessionId = await SharedPreferencesHelper.getSessionId() ?? '';
    final token = await SharedPreferencesHelper.getAccessToken() ?? '';
    if (sessionId.isEmpty || token.isEmpty || entryId.length < 10) {
      mealsList.removeWhere((m) => m.id == entryId);
      await saveNutritionData();
      return;
    }

    EasyLoading.show(status: 'Deleting meal...');
    try {
      final url = Urls.updateMeal(sessionId, entryId);
      debugPrint('=== DELETE MEAL REQUEST ===');
      debugPrint('URL: $url');
      debugPrint('Headers: Authorization: Bearer $token');

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('=== DELETE MEAL RESPONSE ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final data = decoded['data'] as Map<String, dynamic>?;
        if (data != null) {
          RealtimeSocketService().handleLiveScores(data, useLocalCaches: false);
        } else {
          try {
            final db = Get.find<DashboardController>();
            await db.fetchDashboardData();
          } catch (_) {}
        }
        EasyLoading.showSuccess('Deleted meal entry');
      } else {
        EasyLoading.showError('Failed to delete meal');
      }
    } catch (e) {
      debugPrint('deleteMealLog API error: $e');
      EasyLoading.showError('Failed to delete meal');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> editMealLog(String entryId, String heaviness, {DateTime? occurredAt}) async {
    if (entryId.isEmpty) return;
    final sessionId = await SharedPreferencesHelper.getSessionId() ?? '';
    final token = await SharedPreferencesHelper.getAccessToken() ?? '';
    if (sessionId.isEmpty || token.isEmpty || entryId.length < 10) return;

    final dt = occurredAt ?? DateTime.now();

    final index = mealsList.indexWhere((m) => m.id == entryId);
    if (index != -1) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final target = DateTime(dt.year, dt.month, dt.day);
      final diffDays = target.difference(today).inDays;
      final timeOnly = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

      String newTimeStr = timeOnly;
      if (diffDays == -1) {
        newTimeStr = 'Yesterday $timeOnly';
      } else if (diffDays != 0) {
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        newTimeStr = '${dt.day} ${months[dt.month - 1]} · $timeOnly';
      }

      final currentName = mealsList[index].name;
      final cleanName = (currentName.isEmpty || currentName.toLowerCase().contains('undefined')) ? 'Meal' : currentName;

      mealsList[index] = mealsList[index].copyWith(
        name: cleanName,
        type: heaviness[0].toUpperCase() + heaviness.substring(1),
        time: newTimeStr,
        occurredAt: dt.toIso8601String(),
      );
    }

    EasyLoading.show(status: 'Updating meal...');
    try {
      final url = Urls.updateMeal(sessionId, entryId);
      final bodyJson = jsonEncode({
        'occurredAt': dt.toUtc().toIso8601String(),
        'heaviness': heaviness.toLowerCase(),
      });

      debugPrint('=== EDIT MEAL REQUEST ===');
      debugPrint('URL: $url');
      debugPrint('Headers: Authorization: Bearer $token');
      debugPrint('Request Body: $bodyJson');

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: bodyJson,
      );

      debugPrint('=== EDIT MEAL RESPONSE ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final data = decoded['data'] as Map<String, dynamic>?;
        if (data != null) {
          RealtimeSocketService().handleLiveScores(data, useLocalCaches: false);
        } else {
          try {
            final db = Get.find<DashboardController>();
            await db.fetchDashboardData();
          } catch (_) {}
        }
        EasyLoading.showSuccess('Updated meal entry');
      } else {
        EasyLoading.showError('Failed to update meal');
      }
    } catch (e) {
      debugPrint('editMealLog API error: $e');
      EasyLoading.showError('Failed to update meal');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> fetchNotes() async {
    try {
      final sessionId = await SharedPreferencesHelper.getSessionId() ?? '';
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      if (sessionId.isEmpty || token.isEmpty) return;

      final response = await http.get(
        Uri.parse(Urls.addDailyNotes(sessionId)),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        if (decoded['success'] == true && decoded['data'] is List) {
          final list = decoded['data'] as List;
          notesList.assignAll(
            list.map((n) => (n['text'] as String? ?? '')).where((t) => t.isNotEmpty).toList(),
          );
        }
      }
    } catch (e) {
      debugPrint('fetchNotes error: $e');
    }
  }

  Future<void> loadNutritionData() async {
    try {
      final jsonStr = await SharedPreferencesHelper.getMeals();
      if (jsonStr != null) {
        final Map<String, dynamic> data = jsonDecode(jsonStr);
        dailyTarget.value = data['dailyTarget'] ?? 5;
        final List mealsJson = data['meals'] ?? [];
        mealsList.assignAll(
          mealsJson
              .map(
                (m) {
                  final rawName = (m['name'] ?? '').toString();
                  final cleanName = (rawName.isEmpty || rawName.toLowerCase().contains('undefined')) ? 'Meal' : rawName;
                  return MealItem(
                    id: m['id'] ?? '',
                    name: cleanName,
                    time: m['time'] ?? '',
                    type: m['type'] ?? 'Light',
                    isLogged: m['isLogged'] ?? false,
                    isPlanned: m['isPlanned'] ?? false,
                    occurredAt: m['occurredAt'],
                  );
                },
              )
              .toList(),
        );
      } else {
        // No saved data — start empty and persist empty state
        await saveNutritionData();
      }
    } catch (e) {
      debugPrint('Error loading nutrition data: $e');
    }
  }

  Future<void> saveNutritionData({bool syncWithServer = true}) async {
    try {
      final Map<String, dynamic> data = {
        'dailyTarget': dailyTarget.value,
        'meals': mealsList
            .map(
              (m) => {
                'id': m.id,
                'name': m.name,
                'time': m.time,
                'type': m.type,
                'isLogged': m.isLogged,
                'isPlanned': m.isPlanned,
                'occurredAt': m.occurredAt,
              },
            )
            .toList(),
      };
      await SharedPreferencesHelper.saveMeals(jsonEncode(data));

      if (syncWithServer) {
        try {
          final dashboardController = Get.find<DashboardController>();
          await dashboardController.fetchDashboardData();
        } catch (_) {}
      }
    } catch (e) {
      debugPrint('Error saving nutrition data: $e');
    }
  }

  void selectMealType(String type) {
    selectedMealType.value = type;
  }

  void incrementTarget() async {
    EasyLoading.show(status: 'Updating target...');
    try {
      dailyTarget.value++;

      try {
        final sessionId = await SharedPreferencesHelper.getSessionId() ?? '';
        if (sessionId.isNotEmpty) {
          await DashboardService().patchQuickAddLog(
            sessionId: sessionId,
            dailyMealTarget: dailyTarget.value,
          );
        }
      } catch (e) {
        debugPrint('Nutrition API increment target error: $e');
      }

      final newIndex = mealsList.length + 1;
      String nextTime = '22:00';
      if (mealsList.isNotEmpty) {
        final lastTimeStr = mealsList.last.time.split(' ')[0];
        final timeParts = lastTimeStr.split(':');
        if (timeParts.length == 2) {
          int hour = int.tryParse(timeParts[0]) ?? 22;
          int minute = int.tryParse(timeParts[1]) ?? 0;
          hour = (hour + 3) % 24;
          nextTime =
              '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
        }
      }
      mealsList.add(
        MealItem(
          name: 'Meal $newIndex',
          time: nextTime,
          type: 'Light',
          isLogged: false,
          isPlanned: true,
        ),
      );
      await saveNutritionData();
    } finally {
      EasyLoading.dismiss();
    }
  }

  void decrementTarget() async {
    if (dailyTarget.value > 1) {
      EasyLoading.show(status: 'Updating target...');
      try {
        dailyTarget.value--;

        try {
          final sessionId = await SharedPreferencesHelper.getSessionId() ?? '';
          if (sessionId.isNotEmpty) {
            await DashboardService().patchQuickAddLog(
              sessionId: sessionId,
              dailyMealTarget: dailyTarget.value,
            );
          }
        } catch (e) {
          debugPrint('Nutrition API decrement target error: $e');
        }

        int lastUnloggedIdx = mealsList.lastIndexWhere((m) => !m.isLogged);
        if (lastUnloggedIdx != -1) {
          mealsList.removeAt(lastUnloggedIdx);
        } else {
          mealsList.removeLast();
        }
        await saveNutritionData();
      } finally {
        EasyLoading.dismiss();
      }
    }
  }

  void saveMeal() async {
    int firstUnloggedIdx = mealsList.indexWhere((m) => !m.isLogged);
    final now = DateTime.now();
    final formattedTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final oldMeal = firstUnloggedIdx != -1 ? mealsList[firstUnloggedIdx] : null;
    final newIndex = mealsList.length + 1;
    final tempMeal = oldMeal != null
        ? oldMeal.copyWith(
            type: selectedMealType.value,
            isLogged: true,
            isPlanned: false,
            time: formattedTime,
          )
        : MealItem(
            name: 'Meal $newIndex',
            time: formattedTime,
            type: selectedMealType.value,
            isLogged: true,
            isPlanned: false,
          );

    // Optimistic update
    if (firstUnloggedIdx != -1) {
      mealsList[firstUnloggedIdx] = tempMeal;
    } else {
      mealsList.add(tempMeal);
    }

    EasyLoading.show(status: 'Saving meal...');
    bool apiSuccess = false;
    try {
      final sessionId = await SharedPreferencesHelper.getSessionId() ?? '';
      if (sessionId.isNotEmpty) {
        final heaviness = selectedMealType.value.toLowerCase();
        final order = firstUnloggedIdx != -1
            ? firstUnloggedIdx + 1
            : mealsList.length + 1;
        await DashboardService().patchQuickAddLog(
          sessionId: sessionId,
          newMealLogs: [
            {
              'order': order,
              'timestamp': formattedTime,
              'plannedTime': formattedTime,
              'heaviness': heaviness,
            },
          ],
        );
        apiSuccess = true;
      }
    } catch (e) {
      debugPrint('Nutrition API quickAdd error: $e');
    } finally {
      EasyLoading.dismiss();
    }

    if (!apiSuccess) {
      // Revert if API failed
      if (firstUnloggedIdx != -1 && oldMeal != null) {
        mealsList[firstUnloggedIdx] = oldMeal;
      } else {
        mealsList.removeLast();
      }
    } else {
      await saveNutritionData();
    }
  }

  void addNote(String note) async {
    if (note.trim().isNotEmpty) {
      try {
        final sessionId = await SharedPreferencesHelper.getSessionId() ?? '';
        final token = await SharedPreferencesHelper.getAccessToken() ?? '';
        if (sessionId.isEmpty || token.isEmpty) return;

        final response = await http.post(
          Uri.parse(Urls.addDailyNotes(sessionId)),
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'text': note.trim()}),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final decoded = jsonDecode(response.body) as Map<String, dynamic>;
          if (decoded['success'] == true && decoded['data'] is List) {
            final list = decoded['data'] as List;
            notesList.assignAll(
              list.map((n) => (n['text'] as String? ?? '')).where((t) => t.isNotEmpty).toList(),
            );
          }
        } else {
          debugPrint('addNote POST failed: ${response.statusCode} ${response.body}');
        }
      } catch (e) {
        debugPrint('addNote error: $e');
      }
    }
  }

  void updateFromLiveScoresTab(Map<String, dynamic> nutritionTab) {
    try {
      if (nutritionTab['meals'] is List) {
        final mealsJson = nutritionTab['meals'] as List;
        final mappedMeals = mealsJson.map((m) {
          final typeStr =
              m['heavinessLabel'] as String? ??
              m['heaviness'] as String? ??
              'Light';
          final capType = typeStr.isNotEmpty
              ? typeStr[0].toUpperCase() + typeStr.substring(1)
              : 'Light';

          final rawName = (m['label'] ?? m['name'] ?? m['displayName'] ?? '').toString();
          String mealName = rawName;
          if (mealName.isEmpty || mealName == 'null' || mealName.toLowerCase().contains('undefined')) {
            mealName = 'Meal';
          }

          final occurredAtStr = (m['occurredAt'] ?? m['createdAt'] ?? m['updatedAt']) as String?;
          String displayTime = m['timestamp'] ?? m['displayTime'] ?? m['plannedTime'] ?? '';

          if (occurredAtStr != null && occurredAtStr.isNotEmpty) {
            try {
              final parsed = DateTime.parse(occurredAtStr).toLocal();
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final target = DateTime(parsed.year, parsed.month, parsed.day);
              final diffDays = target.difference(today).inDays;

              final timeOnly = '${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}';
              if (diffDays == 0) {
                displayTime = timeOnly;
              } else if (diffDays == -1) {
                displayTime = 'Yesterday $timeOnly';
              } else {
                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                final monthStr = months[parsed.month - 1];
                displayTime = '${parsed.day} $monthStr · $timeOnly';
              }
            } catch (_) {}
          }

          return MealItem(
            id: m['id'] as String? ?? '',
            name: mealName,
            time: displayTime,
            type: capType,
            isLogged: m['status'] == 'logged' || m['isLogged'] == true,
            isPlanned: m['status'] == 'planned' || m['isPlanned'] == true,
            occurredAt: occurredAtStr,
          );
        }).toList();

        mealsList.assignAll(mappedMeals);
      }
      if (nutritionTab['dailyMealTarget'] != null) {
        dailyTarget.value = (nutritionTab['dailyMealTarget'] as num).toInt();
      }
      sleepImpactNote.value = nutritionTab['sleepImpactNote'] ?? "--";

      saveNutritionData(syncWithServer: false);
      // Refresh notes from API after live-scores update
      fetchNotes();
    } catch (e) {
      debugPrint(
        'NutritionController: Error updating from live scores tab: $e',
      );
    }
  }
}
