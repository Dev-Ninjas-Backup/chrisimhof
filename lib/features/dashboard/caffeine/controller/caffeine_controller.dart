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
import 'package:chrisimhof/features/recomendations/controller/recomendations_controller.dart';
import 'package:chrisimhof/features/recomendations/model/recomendation_api_model.dart';
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
    _restoreCutoffFromPrefs();
    loadEntries().then((_) {
      _syncCutoffFromAllSources();
    });
    _syncCutoffFromAllSources();
  }

  Future<void> _restoreCutoffFromPrefs() async {
    final cachedCutoff = await SharedPreferencesHelper.getCaffeineCutoff();
    final cachedBody = await SharedPreferencesHelper.getCaffeineCutoffBody();
    if (cachedCutoff != null && cachedCutoff.isNotEmpty) {
      if (forYouCaffeineCutoff.value == null || forYouCaffeineCutoff.value!.isEmpty) {
        forYouCaffeineCutoff.value = cachedCutoff;
      }
    }
    if (cachedBody != null && cachedBody.isNotEmpty) {
      if (forYouCaffeineBody.value == null || forYouCaffeineBody.value!.isEmpty) {
        forYouCaffeineBody.value = cachedBody;
      }
    }
  }

  void _syncCutoffFromAllSources() {
    // 1. Check DashboardController cached caffeineCardData & forYouPreviewData
    if (Get.isRegistered<DashboardController>()) {
      final db = Get.find<DashboardController>();
      final cachedCard = db.caffeineCardData.value;
      if (cachedCard != null) {
        updateFromCaffeineCard(cachedCard);
      }
      final preview = db.forYouPreviewData.value;
      if (preview != null && preview.isNotEmpty) {
        updateFromForYouPreview(preview);
      }
    }

    // 2. Check RecommendationController
    if (Get.isRegistered<RecommendationController>()) {
      final recCtrl = Get.find<RecommendationController>();
      if (recCtrl.forYouPreview.isNotEmpty) {
        for (final item in recCtrl.forYouPreview) {
          if (item.category?.toLowerCase() == 'caffeine') {
            updateFromRecommendationItem(item);
            break;
          }
        }
      }
      final recs = recCtrl.recommendationResponse.value?.data?.recommendations;
      if (recs != null && recs.isNotEmpty) {
        for (final item in recs) {
          if (item.category?.toLowerCase() == 'caffeine') {
            updateFromRecommendationItem(item);
            break;
          }
        }
      }
    }
  }

  void updateFromRecommendationItem(RecommendationItem item) {
    final cutoff = (item.bodyParams?['cutoffTime'] ??
            item.bodyParams?['cutoff'] ??
            item.bodyParams?['time'])
        ?.toString();
    updateCutoffTime(cutoff ?? '', body: item.body);
  }

  void updateCutoffTime(String cutoff, {String? body}) {
    if (cutoff.isNotEmpty && cutoff != '--:--') {
      forYouCaffeineCutoff.value = cutoff;
      SharedPreferencesHelper.saveCaffeineCutoff(cutoff);
    }
    if (body != null && body.isNotEmpty) {
      forYouCaffeineBody.value = body;
      SharedPreferencesHelper.saveCaffeineCutoffBody(body);
    } else if (cutoff.isNotEmpty && cutoff != '--:--') {
      if (forYouCaffeineBody.value == null || forYouCaffeineBody.value!.isEmpty) {
        final fallback = 'Cut-off $cutoff — protect tonight\'s sleep window.';
        forYouCaffeineBody.value = fallback;
        SharedPreferencesHelper.saveCaffeineCutoffBody(fallback);
      }
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
    } else {
      // Backend enum must be one of: espresso, coffee, energy, tea, other
      return 'other';
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

    // Normalize preset title
    String normalizedTitle = title;
    if (drinkType == 'energy') {
      normalizedTitle = 'Energy';
    } else if (drinkType == 'espresso') {
      normalizedTitle = 'Espresso';
    } else if (drinkType == 'coffee') {
      normalizedTitle = 'Coffee';
    } else if (drinkType == 'tea') {
      normalizedTitle = 'Tea';
    } else if (drinkType == 'other' &&
        (title.trim().isEmpty ||
            title.trim().toLowerCase() == 'other' ||
            title.trim().toLowerCase() == 'custom' ||
            title.trim().toLowerCase() == 'personnalisé' ||
            title.trim().toLowerCase() == 'autre')) {
      normalizedTitle = 'Other';
    }

    // Optimistic entry: add immediately so user sees it right away
    final newEntry = CaffeineEntry(
      id: tempId,
      title: normalizedTitle,
      timestamp: timestamp,
      amountMg: amountMg,
    );
    entriesList.insert(0, newEntry);
    entriesList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    recalculateCaffeine();

    EasyLoading.show(status: 'Logging caffeine...'.tr);
    bool apiSuccess = false;
    try {
      final sessionId = await SharedPreferencesHelper.getSessionId() ?? '';
      if (sessionId.isNotEmpty) {
        final isoString = await TimezoneHelper.formatToSessionUtcIso(timestamp);
        final res = await DashboardService().patchQuickAddLog(
          sessionId: sessionId,
          newCaffeineLogs: [
            {
              'timestamp': formattedTime,
              'caffeineMg': amountMg,
              'drinkType': drinkType,
              'occurredAt': isoString,
            },
          ],
        );
        apiSuccess = true;
        if (res['data'] != null) {
          RealtimeSocketService().handleLiveScores(
            res['data'],
            useLocalCaches: false,
          );
        } else {
          try {
            final db = Get.find<DashboardController>();
            await db.fetchDashboardData();
          } catch (_) {}
        }
      }
    } catch (e) {
      debugPrint('Caffeine API quickAdd error: $e');
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('drinktype') ||
          errStr.contains('must be one of the following values')) {
        EasyLoading.showError(
          'Drink type must be one of the following values: espresso, coffee, energy, tea, other'.tr,
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
      entriesList.removeWhere((e) => e.id == tempId);
      recalculateCaffeine();
      return false;
    }

    await saveEntriesToPrefs(syncWithServer: false);
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
            'Drink type must be one of the following values: espresso, coffee, energy, tea, other'.tr,
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
          'Drink type must be one of the following values: espresso, coffee, energy, tea, other'.tr,
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
          final typeStr =
              (item['drinkType'] as String? ?? '').toLowerCase().trim();
          final rawLabel = (item['drinkLabel'] as String? ?? '').trim();

          String titleStr;
          if (typeStr == 'energy' ||
              rawLabel.toLowerCase().contains('energy') ||
              rawLabel.toLowerCase().contains('énergie') ||
              rawLabel.toLowerCase().contains('energie')) {
            titleStr = 'Energy';
          } else if (typeStr == 'espresso' ||
              rawLabel.toLowerCase() == 'espresso') {
            titleStr = 'Espresso';
          } else if (typeStr == 'coffee' ||
              rawLabel.toLowerCase() == 'coffee' ||
              rawLabel.toLowerCase() == 'café' ||
              rawLabel.toLowerCase() == 'cafe') {
            titleStr = 'Coffee';
          } else if (typeStr == 'tea' ||
              rawLabel.toLowerCase() == 'tea' ||
              rawLabel.toLowerCase() == 'thé' ||
              rawLabel.toLowerCase() == 'the') {
            titleStr = 'Tea';
          } else if (typeStr == 'other' || typeStr == 'custom') {
            if (rawLabel.isNotEmpty &&
                rawLabel.toLowerCase() != 'other' &&
                rawLabel.toLowerCase() != 'custom' &&
                rawLabel.toLowerCase() != 'personnalisé' &&
                rawLabel.toLowerCase() != 'autre') {
              titleStr = rawLabel;
            } else {
              titleStr = 'Other';
            }
          } else if (rawLabel.isNotEmpty) {
            titleStr = rawLabel;
          } else {
            titleStr = 'Coffee';
          }
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

        // 1-to-1 reconcile any pending optimistic entries
        final unmatchedServerLogs = List<CaffeineEntry>.from(mappedLogs);
        final pendingOptimistic = <CaffeineEntry>[];
        for (final entry in entriesList) {
          final isTempId = int.tryParse(entry.id) != null;
          if (!isTempId) continue;
          final age = now.difference(entry.timestamp).abs();
          if (age.inSeconds > 30) continue;

          final matchIndex = unmatchedServerLogs.indexWhere((s) =>
              s.amountMg == entry.amountMg &&
              s.timestamp.difference(entry.timestamp).inMinutes.abs() <= 2 &&
              resolveCaffeineDrinkType(s.title) ==
                  resolveCaffeineDrinkType(entry.title));

          if (matchIndex != -1) {
            unmatchedServerLogs.removeAt(matchIndex);
          } else {
            pendingOptimistic.add(entry);
          }
        }

        mappedLogs.addAll(pendingOptimistic);
        mappedLogs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        entriesList.assignAll(mappedLogs);

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
    if (forYouPreview.isEmpty) return;
    try {
      Map<String, dynamic>? caffeineEntry;
      for (final item in forYouPreview) {
        if (item is Map) {
          final map = Map<String, dynamic>.from(item);
          if (map['category']?.toString().toLowerCase() == 'caffeine') {
            caffeineEntry = map;
            break;
          }
        }
      }

      if (caffeineEntry != null) {
        final body = caffeineEntry['body']?.toString();
        final bodyParams = caffeineEntry['bodyParams'] ?? caffeineEntry['params'];
        String? cutoff;
        if (bodyParams is Map) {
          cutoff = (bodyParams['cutoffTime'] ?? bodyParams['cutoff'] ?? bodyParams['time'])?.toString();
        }
        if ((cutoff == null || cutoff.isEmpty) && body != null) {
          final regex = RegExp(r'(\d{1,2}:\d{2})');
          final match = regex.firstMatch(body);
          if (match != null) {
            cutoff = match.group(1);
          }
        }
        updateCutoffTime(cutoff ?? '', body: body);
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
      final cutoff = caffeineCard['cutoffTime']?.toString();
      if (cutoff != null && cutoff.isNotEmpty && cutoff != '--:--') {
        updateCutoffTime(cutoff);
      }
      _syncWithDashboard();
    } catch (e) {
      debugPrint('CaffeineController: Error updating from caffeine card: $e');
    }
  }
}
