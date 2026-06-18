import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/dashboard/caffeine/model/caffeine_entry.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/service/dashboard_service.dart';
import 'package:get/get.dart';

class CaffeineController extends GetxController {
  final RxList<CaffeineEntry> entriesList = <CaffeineEntry>[].obs;
  final RxDouble activeCaffeine = 0.0.obs;
  final RxInt todayTotalCaffeine = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadEntries();
  }

  Future<void> loadEntries() async {
    try {
      final jsonStr = await SharedPreferencesHelper.getCaffeineLogs();
      if (jsonStr != null) {
        final decoded = jsonDecode(jsonStr) as List;
        entriesList.assignAll(decoded.map((item) => CaffeineEntry(
          id: item['id'],
          title: item['title'],
          timestamp: DateTime.parse(item['timestamp']),
          amountMg: item['amountMg'],
        )).toList());
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
      final listToSave = entriesList.map((entry) => {
        'id': entry.id,
        'title': entry.title,
        'timestamp': entry.timestamp.toIso8601String(),
        'amountMg': entry.amountMg,
      }).toList();
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

    activeCaffeine.value = _calculateDecayedCaffeine();

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
      dashboardController.dashboardData.value = currentData.copyWith(
        caffeineMg: activeCaffeine.value.round(),
        caffeineProgress: (todayTotalCaffeine.value / 400.0).clamp(0.0, 1.0),
      );
    } catch (e) {
      // Safe fallback if dashboard is not loaded or during unit tests
    }
  }

  void addCaffeineEntry(String title, int amountMg, DateTime timestamp) async {
    EasyLoading.show(status: 'Logging caffeine...');
    try {
      final formattedTime = '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
      
      try {
        final sessionId = await SharedPreferencesHelper.getSessionId() ?? '';
        if (sessionId.isNotEmpty) {
          String drinkType = 'coffee';
          final t = title.toLowerCase();
          if (t.contains('tea')) {
            drinkType = 'tea';
          } else if (t.contains('energy') || t.contains('soda') || t.contains('coke')) {
            drinkType = 'energy_drink';
          } else if (t.contains('espresso')) {
            drinkType = 'espresso';
          }
          await DashboardService().patchQuickAddLog(
            sessionId: sessionId,
            newCaffeineLogs: [
              {
                'timestamp': formattedTime,
                'caffeineMg': amountMg,
                'drinkType': drinkType,
              }
            ],
          );
        }
      } catch (e) {
        debugPrint('Caffeine API quickAdd error: $e');
      }

      final newEntry = CaffeineEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        timestamp: timestamp,
        amountMg: amountMg,
      );
      entriesList.add(newEntry);
      entriesList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      recalculateCaffeine();
      await saveEntriesToPrefs();
    } finally {
      EasyLoading.dismiss();
    }
  }

  void quickAdd(String title, int amountMg) {
    addCaffeineEntry(title, amountMg, DateTime.now());
  }

  void editCaffeineEntry(
    String id,
    String title,
    int amountMg,
    DateTime timestamp,
  ) async {
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
  }

  void deleteCaffeineEntry(String id) async {
    entriesList.removeWhere((e) => e.id == id);
    recalculateCaffeine();
    await saveEntriesToPrefs();
  }

  void updateFromLiveScoresTab(Map<String, dynamic> caffeineTab) {
    try {
      if (caffeineTab['logs'] is List) {
        final logsList = caffeineTab['logs'] as List;
        final now = DateTime.now();
        final mappedLogs = logsList.map((item) {
          final timeStr = item['timestamp'] as String? ?? '00:00';
          final amount = (item['caffeineMg'] as num?)?.toInt() ?? 0;
          final titleStr = item['drinkLabel'] as String? ?? 'Espresso';
          
          DateTime logTime = now;
          final parts = timeStr.split(':');
          if (parts.length == 2) {
            final h = int.tryParse(parts[0]) ?? now.hour;
            final m = int.tryParse(parts[1]) ?? now.minute;
            logTime = DateTime(now.year, now.month, now.day, h, m);
          }

          return CaffeineEntry(
            id: '${timeStr}_$amount',
            title: titleStr,
            timestamp: logTime,
            amountMg: amount,
          );
        }).toList();

        entriesList.assignAll(mappedLogs);
        entriesList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        
        todayTotalCaffeine.value = entriesList.fold(0, (sum, entry) => sum + entry.amountMg);
        
        final decayed = entriesList.fold<double>(0, (sum, entry) {
          if (now.isAfter(entry.timestamp)) {
            final hoursPassed = now.difference(entry.timestamp).inMinutes / 60.0;
            return sum + entry.amountMg * math.pow(0.5, hoursPassed / 5.0);
          } else {
            return sum + entry.amountMg;
          }
        });
        activeCaffeine.value = decayed;
        
        _syncWithDashboard();
        saveEntriesToPrefs(syncWithServer: false);
      }
    } catch (e) {
      debugPrint('CaffeineController: Error updating from live scores tab: $e');
    }
  }
}
