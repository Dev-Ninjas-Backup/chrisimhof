import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/realtime/realtime_socket_service.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/core/service/helper/timezone_helper.dart';
import 'package:chrisimhof/features/dashboard/caffeine/model/caffeine_entry.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/service/dashboard_service.dart';
import 'package:get/get.dart';

class CaffeineController extends GetxController {
  final RxList<CaffeineEntry> entriesList = <CaffeineEntry>[].obs;
  final RxDouble activeCaffeine = 0.0.obs;
  final RxInt todayTotalCaffeine = 0.obs;

  final forYouCaffeineBody = RxnString();

  final forYouCaffeineCutoff = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadEntries().then((_) {
      if (Get.isRegistered<DashboardController>()) {
        final db = Get.find<DashboardController>();
        final cachedCard = db.caffeineCardData.value;
        if (cachedCard != null) updateFromCaffeineCard(cachedCard);
      }
    });
    if (Get.isRegistered<DashboardController>()) {
      final preview = Get.find<DashboardController>().forYouPreviewData.value;
      if (preview != null) updateFromForYouPreview(preview);
    }
  }

  Future<void> loadEntries() async {
    try {
      final jsonStr = await SharedPreferencesHelper.getCaffeineLogs();
      if (jsonStr != null) {
        final decoded = jsonDecode(jsonStr) as List;
        entriesList.assignAll(
          decoded
              .map(
                (item) => CaffeineEntry(
                  id: item['id'],
                  title: item['title'],
                  timestamp: DateTime.parse(item['timestamp']),
                  amountMg: item['amountMg'],
                ),
              )
              .toList(),
        );
        recalculateCaffeine();
      } else {
        _initializeMockEntries();
      }
    } catch (e) {
      debugPrint('Error loading caffeine entries: $e');
      _initializeMockEntries();
    }
  }

  Future<void> saveEntriesToPrefs({bool syncWithServer = true}) async {
    try {
      final listToSave = entriesList
          .map(
            (entry) => {
              'id': entry.id,
              'title': entry.title,
              'timestamp': entry.timestamp.toIso8601String(),
              'amountMg': entry.amountMg,
            },
          )
          .toList();
      await SharedPreferencesHelper.saveCaffeineLogs(jsonEncode(listToSave));

      if (syncWithServer) {
        try {
          final dashboardController = Get.find<DashboardController>();
          await dashboardController.fetchDashboardData();
        } catch (_) {}
      }
    } catch (e) {
      debugPrint('Error saving caffeine entries: $e');
    }
  }

  void _initializeMockEntries() async {
    // No mock data — start with an empty entries list
    entriesList.clear();
    recalculateCaffeine();
    await saveEntriesToPrefs();
  }

  void recalculateCaffeine() {
    todayTotalCaffeine.value = entriesList.fold(
      0,
      (sum, entry) => sum + entry.amountMg,
    );

    if (Get.isRegistered<DashboardController>()) {
      final cachedCard = Get.find<DashboardController>().caffeineCardData.value;
      if (cachedCard != null && cachedCard['activeMg'] != null) {
        activeCaffeine.value = (cachedCard['activeMg'] as num).toDouble();
      } else {
        activeCaffeine.value = _calculateDecayedCaffeine();
      }
    } else {
      activeCaffeine.value = _calculateDecayedCaffeine();
    }

    _syncWithDashboard();
  }

  double _calculateDecayedCaffeine() {
    final now = DateTime.now();
    double totalActive = 0.0;

    for (var entry in entriesList) {
      if (now.isAfter(entry.timestamp)) {
        final hoursPassed = now.difference(entry.timestamp).inMinutes / 60.0;
        totalActive += entry.amountMg * math.pow(0.5, hoursPassed / 5.0);
      } else {
        totalActive += entry.amountMg;
      }
    }
    return totalActive;
  }

  void _syncWithDashboard() {
    try {
      final dashboardController = Get.find<DashboardController>();
      final currentData = dashboardController.dashboardData.value;

      double progress = currentData.caffeineProgress;
      final cachedCard = dashboardController.caffeineCardData.value;
      if (cachedCard != null && cachedCard['score'] != null) {
        progress = ((cachedCard['score'] as num).toDouble() / 100.0).clamp(0.0, 1.0);
      } else if (progress == 0.0 && todayTotalCaffeine.value > 0) {
        progress = (todayTotalCaffeine.value / 400.0).clamp(0.0, 1.0);
      }

      dashboardController.dashboardData.value = currentData.copyWith(
        caffeineMg: activeCaffeine.value.round(),
        caffeineProgress: progress,
      );
    } catch (e) {
      // Safe fallback if dashboard is not loaded or during unit tests
    }
  }

  static String resolveCaffeineDrinkType(String title) {
    final t = title.toLowerCase().trim();
    if (t == 'espresso' || t.contains('espresso')) {
      return 'espresso';
    } else if (t == 'coffee' ||
        t.contains('coffee') ||
        t == 'café' ||
        t.contains('café') ||
        t == 'cafe') {
      return 'coffee';
    } else if (t == 'energy' ||
        t.contains('energy') ||
        t == 'énergie' ||
        t.contains('énergie') ||
        t == 'energie') {
      return 'energy';
    } else if (t == 'tea' ||
        t.contains('tea') ||
        t == 'thé' ||
        t.contains('thé') ||
        t == 'the') {
      return 'tea';
    } else if (t == 'custom' ||
        t.contains('custom') ||
        t == 'personnalisé' ||
        t.contains('personnalisé') ||
        t == 'personnalise') {
      return 'custom';
    } else {
      // Do not hardcode coffee. Send user input directly so backend can validate
      // and return the enum error if it does not match.
      return t;
    }
  }

  Future<bool> addCaffeineEntry(
    String title,
    int amountMg,
    DateTime timestamp,
  ) async {
    final formattedTime =
        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';

    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final drinkType = resolveCaffeineDrinkType(title);

    EasyLoading.show(status: 'Logging caffeine...'.tr);
    bool apiSuccess = false;
    try {
      final sessionId = await SharedPreferencesHelper.getSessionId() ?? '';
      if (sessionId.isNotEmpty) {
        await DashboardService().patchQuickAddLog(
          sessionId: sessionId,
          newCaffeineLogs: [
            {
              'timestamp': formattedTime,
              'caffeineMg': amountMg,
              'drinkType': drinkType,
            },
          ],
        );
        apiSuccess = true;
      }
    } catch (e) {
      debugPrint('Caffeine API quickAdd error: $e');
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('drinktype') ||
          errStr.contains('must be one of the following values')) {
        EasyLoading.showError(
          'Drink type must be one of the following values: espresso, coffee, energy, tea, custom'.tr,
          duration: const Duration(seconds: 4),
        );
      } else {
        EasyLoading.showError('Failed to log caffeine'.tr);
      }
    } finally {
      if (apiSuccess) {
        EasyLoading.dismiss();
      }
    }

    if (!apiSuccess) {
      return false;
    }

    final newEntry = CaffeineEntry(
      id: tempId,
      title: title,
      timestamp: timestamp,
      amountMg: amountMg,
    );
    entriesList.add(newEntry);
    entriesList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    recalculateCaffeine();
    await saveEntriesToPrefs();
    return true;
  }

  void quickAdd(String title, int amountMg) {
    addCaffeineEntry(title, amountMg, DateTime.now());
  }

  Future<bool> editCaffeineEntry(
    String id,
    String title,
    int amountMg,
    DateTime timestamp,
  ) async {
    final sessionId = await SharedPreferencesHelper.getSessionId() ?? '';
    final token = await SharedPreferencesHelper.getAccessToken() ?? '';
    if (sessionId.isEmpty || token.isEmpty || id.isEmpty || id.length < 10) {
      return false;
    }

    final drinkType = resolveCaffeineDrinkType(title);

    EasyLoading.show(status: 'Updating caffeine...'.tr);
    bool apiSuccess = false;
    try {
      final url = Urls.updateCaffeine(sessionId, id);
      final isoString = await TimezoneHelper.formatToSessionUtcIso(timestamp);
      final bodyJson = jsonEncode({
        'occurredAt': isoString,
        'caffeineMg': amountMg,
        'drinkType': drinkType,
      });

      debugPrint('=== EDIT CAFFEINE REQUEST ===');
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

      debugPrint('=== EDIT CAFFEINE RESPONSE ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        apiSuccess = true;
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
        EasyLoading.showSuccess('Updated caffeine entry'.tr);
      } else {
        String msg = '';
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map && decoded['message'] != null) {
            if (decoded['message'] is List &&
                (decoded['message'] as List).isNotEmpty) {
              msg = (decoded['message'] as List).join(', ');
            } else {
              msg = decoded['message'].toString();
            }
          }
        } catch (_) {}
        if (msg.toLowerCase().contains('drinktype') ||
            msg.toLowerCase().contains('must be one of the following values')) {
          EasyLoading.showError(
            'Drink type must be one of the following values: espresso, coffee, energy, tea, custom'.tr,
            duration: const Duration(seconds: 4),
          );
        } else {
          EasyLoading.showError(
            msg.isNotEmpty ? msg : 'Failed to update caffeine entry'.tr,
          );
        }
      }
    } catch (e) {
      debugPrint('editCaffeineEntry API error: $e');
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('drinktype') ||
          errStr.contains('must be one of the following values')) {
        EasyLoading.showError(
          'Drink type must be one of the following values: espresso, coffee, energy, tea, custom'.tr,
          duration: const Duration(seconds: 4),
        );
      } else {
        EasyLoading.showError('Failed to update caffeine entry'.tr);
      }
    }

    if (apiSuccess) {
      final index = entriesList.indexWhere((e) => e.id == id);
      if (index != -1) {
        entriesList[index] = CaffeineEntry(
          id: id,
          title: title,
          timestamp: timestamp,
          amountMg: amountMg,
        );
        entriesList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        recalculateCaffeine();
        await saveEntriesToPrefs();
      }
      return true;
    }
    return false;
  }

  void deleteCaffeineEntry(String id) async {
    entriesList.removeWhere((e) => e.id == id);
    recalculateCaffeine();
    await saveEntriesToPrefs();

    final sessionId = await SharedPreferencesHelper.getSessionId() ?? '';
    final token = await SharedPreferencesHelper.getAccessToken() ?? '';
    if (sessionId.isEmpty || token.isEmpty || id.isEmpty || id.length < 10) return;

    EasyLoading.show(status: 'Deleting caffeine...'.tr);
    try {
      final url = Urls.updateCaffeine(sessionId, id);
      debugPrint('=== DELETE CAFFEINE REQUEST ===');
      debugPrint('URL: $url');
      debugPrint('Headers: Authorization: Bearer $token');

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('=== DELETE CAFFEINE RESPONSE ===');
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
        EasyLoading.showSuccess('Deleted caffeine entry'.tr);
      }
    } catch (e) {
      debugPrint('deleteCaffeineEntry API error: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void updateFromLiveScoresTab(Map<String, dynamic> caffeineTab) {
    try {
      if (caffeineTab['logs'] is List) {
        final logsList = caffeineTab['logs'] as List;
        final now = DateTime.now();
        final mappedLogs = logsList.map((item) {
          final timeStr = item['timestamp'] as String? ?? '00:00';
          final amount = (item['caffeineMg'] as num?)?.toInt() ?? 0;
          final typeStr = item['drinkType'] as String? ?? '';
          final titleStr = item['drinkLabel'] as String? ??
              (typeStr.isNotEmpty
                  ? (typeStr == 'custom'
                      ? 'Custom'
                      : typeStr == 'tea'
                          ? 'Tea'
                          : typeStr == 'energy'
                              ? 'Energy'
                              : typeStr == 'espresso'
                                  ? 'Espresso'
                                  : 'Coffee')
                  : 'Coffee');
          final serverId = item['id'] as String? ?? '${timeStr}_$amount';

          DateTime logTime = now;
          if (timeStr.contains('T') || timeStr.contains('-')) {
            final parsed = DateTime.tryParse(timeStr);
            if (parsed != null) {
              logTime = parsed.toLocal();
            }
          } else {
            final parts = timeStr.split(':');
            if (parts.length >= 2) {
              final h = int.tryParse(parts[0]) ?? now.hour;
              final m = int.tryParse(parts[1]) ?? now.minute;
              var localTime = DateTime(now.year, now.month, now.day, h, m);
              if (localTime.isAfter(now)) {
                localTime = localTime.subtract(const Duration(days: 1));
              }
              logTime = localTime;
            }
          }

          return CaffeineEntry(
            id: serverId,
            title: titleStr,
            timestamp: logTime,
            amountMg: amount,
          );
        }).toList();

        entriesList.assignAll(mappedLogs);
        entriesList.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        todayTotalCaffeine.value = entriesList.fold(
          0,
          (sum, entry) => sum + entry.amountMg,
        );

        final decayed = entriesList.fold<double>(0, (sum, entry) {
          if (now.isAfter(entry.timestamp)) {
            final hoursPassed =
                now.difference(entry.timestamp).inMinutes / 60.0;
            return sum + entry.amountMg * math.pow(0.5, hoursPassed / 5.0);
          } else {
            return sum + entry.amountMg;
          }
        });
        
        // Prioritize the server-calculated active caffeine value from the cached dashboard card data.
        if (Get.isRegistered<DashboardController>()) {
          final cachedCard = Get.find<DashboardController>().caffeineCardData.value;
          if (cachedCard != null && cachedCard['activeMg'] != null) {
            activeCaffeine.value = (cachedCard['activeMg'] as num).toDouble();
          } else {
            activeCaffeine.value = decayed;
          }
        } else {
          activeCaffeine.value = decayed;
        }

        _syncWithDashboard();
        saveEntriesToPrefs(syncWithServer: false);
      }
    } catch (e) {
      debugPrint('CaffeineController: Error updating from live scores tab: $e');
    }
  }

  /// Called with the top-level liveScores forYouPreview list to extract caffeine entry.
  void updateFromForYouPreview(List<dynamic> forYouPreview) {
    try {
      final caffeineEntry =
          forYouPreview.firstWhereOrNull(
                (item) =>
                    (item as Map<String, dynamic>)['category'] == 'caffeine',
              )
              as Map<String, dynamic>?;

      if (caffeineEntry != null) {
        forYouCaffeineBody.value = caffeineEntry['body'] as String?;
        final bodyParams = (caffeineEntry['bodyParams'] ?? caffeineEntry['params']) as Map<String, dynamic>?;
        forYouCaffeineCutoff.value = (bodyParams?['cutoffTime'] ?? bodyParams?['cutoff'] ?? bodyParams?['time']) as String?;
      } else {
        forYouCaffeineBody.value = null;
        forYouCaffeineCutoff.value = null;
      }
    } catch (e) {
      debugPrint('CaffeineController forYouPreview parse error: $e');
    }
  }

  void updateFromCaffeineCard(Map<String, dynamic> caffeineCard) {
    try {
      if (caffeineCard['activeMg'] != null) {
        activeCaffeine.value = (caffeineCard['activeMg'] as num).toDouble();
      }
      _syncWithDashboard();
    } catch (e) {
      debugPrint('CaffeineController: Error updating from caffeine card: $e');
    }
  }
}
