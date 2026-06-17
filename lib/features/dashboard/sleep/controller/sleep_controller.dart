import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/service/dashboard_service.dart';
import 'package:chrisimhof/features/dashboard/sleep/service/sleep_service.dart';
import 'package:chrisimhof/features/dashboard/sleep/model/sleep_log.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SleepController extends GetxController {
  final bedtimeHour = 23.obs;
  final bedtimeMinute = 8.obs;

  final wakeupHour = 5.obs;
  final wakeupMinute = 50.obs;

  final historyLogs = <SleepLog>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSleepHistory();
  }

  Future<void> loadSleepHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonStr = prefs.getString('sleepHistoryLogs');
      if (jsonStr != null) {
        final List decoded = jsonDecode(jsonStr);
        historyLogs.assignAll(decoded.map((item) => SleepLog(
          id: item['id'],
          date: DateTime.parse(item['date']),
          bedtime: TimeOfDay(hour: item['bedtimeHour'], minute: item['bedtimeMinute']),
          wakeupTime: TimeOfDay(hour: item['wakeupHour'], minute: item['wakeupMinute']),
          quality: item['quality'],
        )).toList());
      } else {
        _initializeMockHistory();
      }
    } catch (e) {
      debugPrint('Error loading sleep history: $e');
      _initializeMockHistory();
    }
  }

  Future<void> saveSleepHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final listToSave = historyLogs.map((log) => {
        'id': log.id,
        'date': log.date.toIso8601String(),
        'bedtimeHour': log.bedtime.hour,
        'bedtimeMinute': log.bedtime.minute,
        'wakeupHour': log.wakeupTime.hour,
        'wakeupMinute': log.wakeupTime.minute,
        'quality': log.quality,
      }).toList();
      await prefs.setString('sleepHistoryLogs', jsonEncode(listToSave));
    } catch (e) {
      debugPrint('Error saving sleep history: $e');
    }
  }

  void _initializeMockHistory() async {
    final today = DateTime.now();
    historyLogs.assignAll([
      SleepLog(
        id: '1',
        date: today.subtract(const Duration(days: 1)),
        bedtime: const TimeOfDay(hour: 23, minute: 8),
        wakeupTime: const TimeOfDay(hour: 5, minute: 50),
        quality: 82,
      ),
      SleepLog(
        id: '2',
        date: today.subtract(const Duration(days: 2)),
        bedtime: const TimeOfDay(hour: 0, minute: 14),
        wakeupTime: const TimeOfDay(hour: 7, minute: 30),
        quality: 88,
      ),
      SleepLog(
        id: '3',
        date: today.subtract(const Duration(days: 3)),
        bedtime: const TimeOfDay(hour: 22, minute: 45),
        wakeupTime: const TimeOfDay(hour: 6, minute: 8),
        quality: 91,
      ),
    ]);
    await saveSleepHistory();
  }

  // Bedtime adjusters
  void incrementBedtimeHour() {
    bedtimeHour.value = (bedtimeHour.value + 1) % 24;
  }

  void decrementBedtimeHour() {
    bedtimeHour.value = (bedtimeHour.value - 1 + 24) % 24;
  }

  void incrementBedtimeMinute() {
    bedtimeMinute.value = (bedtimeMinute.value + 1) % 60;
  }

  void decrementBedtimeMinute() {
    bedtimeMinute.value = (bedtimeMinute.value - 1 + 60) % 60;
  }

  // Wakeup adjusters
  void incrementWakeupHour() {
    wakeupHour.value = (wakeupHour.value + 1) % 24;
  }

  void decrementWakeupHour() {
    wakeupHour.value = (wakeupHour.value - 1 + 24) % 24;
  }

  void incrementWakeupMinute() {
    wakeupMinute.value = (wakeupMinute.value + 1) % 60;
  }

  void decrementWakeupMinute() {
    wakeupMinute.value = (wakeupMinute.value - 1 + 60) % 60;
  }

  String get currentSleepDuration {
    final bedMinutes = bedtimeHour.value * 60 + bedtimeMinute.value;
    final wakeupMinutes = wakeupHour.value * 60 + wakeupMinute.value;

    int diffMinutes = wakeupMinutes - bedMinutes;
    if (diffMinutes < 0) {
      diffMinutes += 1440;
    }

    final hours = diffMinutes ~/ 60;
    final minutes = diffMinutes % 60;

    return '${hours}h ${minutes}m';
  }

  void loadLogForEditing(SleepLog log) {
    bedtimeHour.value = log.bedtime.hour;
    bedtimeMinute.value = log.bedtime.minute;
    wakeupHour.value = log.wakeupTime.hour;
    wakeupMinute.value = log.wakeupTime.minute;
    EasyLoading.showToast('Loaded sleep log to edit');
  }

  void saveSleep() async {
    // Add to history logs
    final newLog = SleepLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      bedtime: TimeOfDay(hour: bedtimeHour.value, minute: bedtimeMinute.value),
      wakeupTime: TimeOfDay(hour: wakeupHour.value, minute: wakeupMinute.value),
      quality: 85,
    );

    final today = DateTime.now();
    final index = historyLogs.indexWhere(
      (log) => log.date.year == today.year && log.date.month == today.month && log.date.day == today.day
    );
    if (index != -1) {
      historyLogs[index] = newLog;
    } else {
      historyLogs.insert(0, newLog);
    }
    
    await saveSleepHistory();

    EasyLoading.show(status: 'Saving sleep...');
    try {
      final sessionId = await SharedPreferencesHelper.getSessionId();
      if (sessionId != null && sessionId.isNotEmpty) {
        final startHStr = bedtimeHour.value.toString().padLeft(2, '0');
        final startMStr = bedtimeMinute.value.toString().padLeft(2, '0');
        final endHStr = wakeupHour.value.toString().padLeft(2, '0');
        final endMStr = wakeupMinute.value.toString().padLeft(2, '0');

        await SleepService().saveSleep(
          sessionId: sessionId,
          sleepStartTime: '$startHStr:$startMStr',
          wakeTime: '$endHStr:$endMStr',
        );

        await DashboardService().calculateResult(sessionId: sessionId);

        try {
          final dashboardController = Get.find<DashboardController>();
          await dashboardController.fetchDashboardData();
        } catch (_) {}

        EasyLoading.showSuccess('Sleep logged successfully!');
        Get.back();
      } else {
        EasyLoading.showError('No active session found.');
      }
    } catch (e) {
      debugPrint('Error saving sleep: $e');
      EasyLoading.showError('Failed to save sleep log.');
    }
  }

  void addSleepLog({
    required DateTime date,
    required TimeOfDay bedtime,
    required TimeOfDay wakeupTime,
    required int quality,
  }) async {
    final newLog = SleepLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: date,
      bedtime: bedtime,
      wakeupTime: wakeupTime,
      quality: quality,
    );
    historyLogs.insert(0, newLog);
    historyLogs.sort((a, b) => b.date.compareTo(a.date));
    await saveSleepHistory();
    EasyLoading.showSuccess('Sleep log added!');
  }

  void updateSleepLog({
    required String id,
    required DateTime date,
    required TimeOfDay bedtime,
    required TimeOfDay wakeupTime,
    required int quality,
  }) async {
    final index = historyLogs.indexWhere((log) => log.id == id);
    if (index != -1) {
      historyLogs[index] = SleepLog(
        id: id,
        date: date,
        bedtime: bedtime,
        wakeupTime: wakeupTime,
        quality: quality,
      );
      historyLogs.sort((a, b) => b.date.compareTo(a.date));
      await saveSleepHistory();
      EasyLoading.showSuccess('Sleep log updated!');
    }
  }

  void deleteLog(String id) async {
    historyLogs.removeWhere((log) => log.id == id);
    await saveSleepHistory();
    EasyLoading.showSuccess('Sleep log deleted!');
  }

  void updateFromLiveScoresTab(Map<String, dynamic> tabData) {
    try {
      final List? historyList = tabData['history'] as List?;
      if (historyList != null) {
        final List<SleepLog> parsedLogs = [];
        for (var item in historyList) {
          try {
            final date = DateTime.tryParse(item['date'] ?? '') ?? DateTime.now();
            final bedTimeStr = item['sleepStartTime'] as String? ?? '23:00';
            final wakeTimeStr = item['wakeTime'] as String? ?? '07:00';

            final bedParts = bedTimeStr.split(':');
            final wakeParts = wakeTimeStr.split(':');

            final bedtime = TimeOfDay(
              hour: bedParts.length == 2 ? int.parse(bedParts[0]) : 23,
              minute: bedParts.length == 2 ? int.parse(bedParts[1]) : 0,
            );

            final wakeupTime = TimeOfDay(
              hour: wakeParts.length == 2 ? int.parse(wakeParts[0]) : 7,
              minute: wakeParts.length == 2 ? int.parse(wakeParts[1]) : 0,
            );

            parsedLogs.add(SleepLog(
              id: item['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
              date: date,
              bedtime: bedtime,
              wakeupTime: wakeupTime,
              quality: (item['quality'] as num?)?.toInt() ?? 85,
            ));
          } catch (e) {
            debugPrint('SleepController socket item parsing error: $e');
          }
        }
        if (parsedLogs.isNotEmpty) {
          historyLogs.assignAll(parsedLogs);
          saveSleepHistory();
        }
      }
    } catch (e) {
      debugPrint('SleepController socket update error: $e');
    }
  }
}
