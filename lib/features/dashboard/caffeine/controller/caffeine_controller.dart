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
  final RxDouble activeCaffeineAtBedtime = 0.0.obs;
  final RxInt bedtimeBufferMinutes = 0.obs;

  final forYouCaffeineBody = RxnString();
  final forYouCaffeineCutoff = RxnString();
  final isLogging = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 1. Initial load from local prefs for instant UI rendering
    loadEntries().then((_) {
      _syncFromDashboardAndServer();
    });
    // 2. Immediate sync if controllers are already initialized
    _syncFromDashboardAndServer();
  }

  void _syncFromDashboardAndServer() {
    if (Get.isRegistered<DashboardController>()) {
      final db = Get.find<DashboardController>();
      activeCaffeineAtBedtime.value =
          db.dashboardData.value.activeCaffeineAtBedtimeMg;
      bedtimeBufferMinutes.value =
          db.dashboardData.value.bedtimeBufferMinutes;
      final cachedTab = db.caffeineTabData.value;
      if (cachedTab != null) {
        updateFromLiveScoresTab(cachedTab);
      }
      final cachedCard = db.caffeineCardData.value;
      if (cachedCard != null) {
        updateFromCaffeineCard(cachedCard);
      }
      final preview = db.forYouPreviewData.value;
      if (preview != null && preview.isNotEmpty) {
        updateFromForYouPreview(preview);
      }
    }
    if (Get.isRegistered<RecommendationController>()) {
      final recs = Get.find<RecommendationController>().recommendationResponse.value?.data?.recommendations;
      if (recs != null && recs.isNotEmpty) {
        updateFromRecommendations(recs);
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
      // Backend accepts 'espresso', 'coffee', 'energy', 'tea', 'other'
      return 'other';
    }
  }

  Future<bool> addCaffeineEntry(
    String title,
    int amountMg,
    DateTime timestamp,
  ) async {
    if (isLogging.value) return false;
    isLogging.value = true;

    final formattedTime =
        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';

    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final drinkType = resolveCaffeineDrinkType(title);

    EasyLoading.show(status: 'Logging caffeine...'.tr);
    bool apiSuccess = false;
    Map<String, dynamic>? patchResponseData;

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
        patchResponseData = res['data'] as Map<String, dynamic>?;

        if (patchResponseData != null) {
          // 1. If backend returned updated caffeine entries directly, sync them with server UUIDs
          final serverEntries = patchResponseData['entries']?['caffeine'];
          if (serverEntries is List && serverEntries.isNotEmpty) {
            updateFromCaffeineEntries(serverEntries);
          }

          RealtimeSocketService().handleLiveScores(
            patchResponseData,
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
      isLogging.value = false;
      if (apiSuccess) {
        EasyLoading.dismiss();
      }
    }

    if (!apiSuccess) {
      return false;
    }

    // Only add a temporary local entry if server entries were not returned and not already present
    final serverEntries = patchResponseData?['entries']?['caffeine'];
    if (serverEntries == null) {
      final alreadyExists = entriesList.any(
        (e) =>
            e.amountMg == amountMg &&
            e.timestamp.difference(timestamp).inSeconds.abs() < 10,
      );
      if (!alreadyExists) {
        final newEntry = CaffeineEntry(
          id: tempId,
          title: title,
          timestamp: timestamp,
          amountMg: amountMg,
        );
        entriesList.add(newEntry);
        entriesList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        recalculateCaffeine();
        await saveEntriesToPrefs(syncWithServer: false);
      }
    }
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
    await saveEntriesToPrefs(syncWithServer: false);

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
          final serverEntries = data['entries'];
          if (serverEntries is List) {
            updateFromCaffeineEntries(serverEntries);
          }
          RealtimeSocketService().handleLiveScores(data, useLocalCaches: false);
        } else {
          try {
            final db = Get.find<DashboardController>();
            await db.fetchDashboardData();
          } catch (_) {}
        }
        EasyLoading.showSuccess('Deleted caffeine entry'.tr);
      } else {
        // If entry was not found on backend (404/500), keep local removal clean
        await saveEntriesToPrefs(syncWithServer: false);
      }
    } catch (e) {
      debugPrint('deleteCaffeineEntry API error: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Direct sync of caffeine logs from server entries list (e.g. quickAdd or delete response)
  void updateFromCaffeineEntries(List<dynamic> entries) {
    try {
      final now = DateTime.now();
      final mappedLogs = entries.map((item) {
        final timeStr = item['timestamp'] as String? ?? '00:00';
        final amount = (item['caffeineMg'] as num?)?.toInt() ?? 0;
        final typeStr = item['drinkType'] as String? ?? '';
        final titleStr = item['drinkLabel'] as String? ??
            (typeStr.isNotEmpty
                ? (typeStr == 'other' || typeStr == 'custom'
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
        if (item['occurredAt'] != null &&
            (item['occurredAt'] as String).isNotEmpty) {
          try {
            logTime = TimezoneHelper.parseSessionUtcToLocal(
              item['occurredAt'] as String,
            );
          } catch (_) {}
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
      recalculateCaffeine();
      saveEntriesToPrefs(syncWithServer: false);
    } catch (e) {
      debugPrint('CaffeineController: Error updating from entries: $e');
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
                  ? (typeStr == 'other' || typeStr == 'custom'
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
          if (item['occurredAt'] != null && (item['occurredAt'] as String).isNotEmpty) {
            try {
              logTime = TimezoneHelper.parseSessionUtcToLocal(item['occurredAt'] as String);
            } catch (_) {}
          } else if (timeStr.contains('T') || timeStr.contains('-')) {
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

        final tabCutoff = (caffeineTab['cutoffTime'] ?? caffeineTab['cutoff']) as String?;
        if (tabCutoff != null && tabCutoff.isNotEmpty) {
          forYouCaffeineCutoff.value = tabCutoff;
          if (forYouCaffeineBody.value == null || forYouCaffeineBody.value!.isEmpty) {
            forYouCaffeineBody.value = '${'Cut-off'.tr} $tabCutoff — ${'protect tonight\'s sleep window.'.tr}';
          }
        }

        if (caffeineTab['activeCaffeineAtBedtimeMg'] != null) {
          activeCaffeineAtBedtime.value =
              (caffeineTab['activeCaffeineAtBedtimeMg'] as num).toDouble();
        } else if (caffeineTab['activeAtBedtimeMg'] != null) {
          activeCaffeineAtBedtime.value =
              (caffeineTab['activeAtBedtimeMg'] as num).toDouble();
        } else if (Get.isRegistered<DashboardController>()) {
          activeCaffeineAtBedtime.value =
              Get.find<DashboardController>().dashboardData.value.activeCaffeineAtBedtimeMg;
        }

        if (caffeineTab['bedtimeBufferMinutes'] != null) {
          bedtimeBufferMinutes.value =
              (caffeineTab['bedtimeBufferMinutes'] as num).toInt();
        } else if (Get.isRegistered<DashboardController>()) {
          bedtimeBufferMinutes.value =
              Get.find<DashboardController>().dashboardData.value.bedtimeBufferMinutes;
        }

        _syncWithDashboard();
        saveEntriesToPrefs(syncWithServer: false);
      }
    } catch (e) {
      debugPrint('CaffeineController: Error updating from live scores tab: $e');
    }
  }

  /// Sync cut-off time and message from recommendations
  void updateFromRecommendations(List<dynamic> recommendations) {
    try {
      final caffeineRec = recommendations.firstWhereOrNull((r) {
        if (r is RecommendationItem) {
          return r.category?.toLowerCase() == 'caffeine';
        } else if (r is Map) {
          return r['category']?.toString().toLowerCase() == 'caffeine';
        }
        return false;
      });

      if (caffeineRec != null) {
        String? body;
        String? cutoff;
        if (caffeineRec is RecommendationItem) {
          body = caffeineRec.body;
          cutoff = caffeineRec.bodyParams?['cutoffTime'] as String? ??
              caffeineRec.bodyParams?['cutoff'] as String?;
        } else if (caffeineRec is Map) {
          body = caffeineRec['body'] as String?;
          final params = (caffeineRec['bodyParams'] ?? caffeineRec['params']) as Map<String, dynamic>?;
          cutoff = (params?['cutoffTime'] ?? params?['cutoff'] ?? params?['time']) as String?;
        }

        if (body != null && body.isNotEmpty) {
          forYouCaffeineBody.value = body;
        }
        if (cutoff != null && cutoff.isNotEmpty) {
          forYouCaffeineCutoff.value = cutoff;
        }
      }
    } catch (e) {
      debugPrint('CaffeineController updateFromRecommendations error: $e');
    }
  }

  /// Called with the top-level liveScores forYouPreview list to extract caffeine entry.
  void updateFromForYouPreview(List<dynamic> forYouPreview) {
    try {
      final caffeineEntry = forYouPreview.firstWhereOrNull((item) {
        if (item is Map) {
          return item['category']?.toString().toLowerCase() == 'caffeine';
        } else if (item is RecommendationItem) {
          return item.category?.toLowerCase() == 'caffeine';
        }
        return false;
      });

      if (caffeineEntry != null) {
        String? body;
        String? cutoff;
        if (caffeineEntry is Map) {
          body = caffeineEntry['body'] as String?;
          final bodyParams = (caffeineEntry['bodyParams'] ?? caffeineEntry['params']) as Map<String, dynamic>?;
          cutoff = (bodyParams?['cutoffTime'] ?? bodyParams?['cutoff'] ?? bodyParams?['time']) as String?;
        } else if (caffeineEntry is RecommendationItem) {
          body = caffeineEntry.body;
          cutoff = caffeineEntry.bodyParams?['cutoffTime'] as String? ??
              caffeineEntry.bodyParams?['cutoff'] as String?;
        }

        if (body != null && body.isNotEmpty) {
          forYouCaffeineBody.value = body;
        }
        if (cutoff != null && cutoff.isNotEmpty) {
          forYouCaffeineCutoff.value = cutoff;
        }
      }
      // Note: Never reset forYouCaffeineCutoff / forYouCaffeineBody to null here
      // so that partial socket updates do not wipe out existing cut-off data!
    } catch (e) {
      debugPrint('CaffeineController forYouPreview parse error: $e');
    }
  }

  void updateFromCaffeineCard(Map<String, dynamic> caffeineCard) {
    try {
      if (caffeineCard['activeMg'] != null) {
        activeCaffeine.value = (caffeineCard['activeMg'] as num).toDouble();
      }
      final cutoff = (caffeineCard['cutoffTime'] ?? caffeineCard['cutoff']) as String?;
      if (cutoff != null && cutoff.isNotEmpty) {
        forYouCaffeineCutoff.value = cutoff;
        if (forYouCaffeineBody.value == null || forYouCaffeineBody.value!.isEmpty) {
          forYouCaffeineBody.value = '${'Cut-off'.tr} $cutoff — ${'protect tonight\'s sleep window.'.tr}';
        }
      }
      _syncWithDashboard();
    } catch (e) {
      debugPrint('CaffeineController: Error updating from caffeine card: $e');
    }
  }
}
