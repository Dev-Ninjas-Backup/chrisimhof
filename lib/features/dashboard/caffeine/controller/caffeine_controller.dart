import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/dashboard/caffeine/model/caffeine_entry.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
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

  Future<void> saveEntriesToPrefs() async {
    try {
      final listToSave = entriesList.map((entry) => {
        'id': entry.id,
        'title': entry.title,
        'timestamp': entry.timestamp.toIso8601String(),
        'amountMg': entry.amountMg,
      }).toList();
      await SharedPreferencesHelper.saveCaffeineLogs(jsonEncode(listToSave));
      
      try {
        final dashboardController = Get.find<DashboardController>();
        await dashboardController.fetchDashboardData();
      } catch (_) {}
    } catch (e) {
      debugPrint('Error saving caffeine entries: $e');
    }
  }

  void _initializeMockEntries() async {
    final now = DateTime.now();
    entriesList.assignAll([
      CaffeineEntry(
        id: '1',
        title: 'Espresso',
        timestamp: DateTime(now.year, now.month, now.day, 14, 20),
        amountMg: 75,
      ),
      CaffeineEntry(
        id: '2',
        title: 'Coffee',
        timestamp: DateTime(now.year, now.month, now.day, 11, 45),
        amountMg: 100,
      ),
      CaffeineEntry(
        id: '3',
        title: 'Energy drink',
        timestamp: DateTime(now.year, now.month, now.day, 8, 30),
        amountMg: 85,
      ),
    ]);
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
}
