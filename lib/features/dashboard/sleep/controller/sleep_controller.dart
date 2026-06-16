import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    _initializeMockHistory();
  }

  void _initializeMockHistory() {
    // Initial mock history entries based on the design mockup
    historyLogs.assignAll([
      SleepLog(
        id: '1',
        date: DateTime(2026, 5, 17),
        bedtime: const TimeOfDay(hour: 23, minute: 8),
        wakeupTime: const TimeOfDay(hour: 5, minute: 50),
        quality: 82,
      ),
      SleepLog(
        id: '2',
        date: DateTime(2026, 5, 16),
        bedtime: const TimeOfDay(hour: 0, minute: 14),
        wakeupTime: const TimeOfDay(hour: 7, minute: 30),
        quality: 88,
      ),
      SleepLog(
        id: '3',
        date: DateTime(2026, 5, 15),
        bedtime: const TimeOfDay(hour: 22, minute: 45),
        wakeupTime: const TimeOfDay(hour: 6, minute: 8),
        quality: 91,
      ),
    ]);
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

  void saveSleep() {
    final duration = currentSleepDuration;
    
    // Add to history logs
    final newLog = SleepLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      bedtime: TimeOfDay(hour: bedtimeHour.value, minute: bedtimeMinute.value),
      wakeupTime: TimeOfDay(hour: wakeupHour.value, minute: wakeupMinute.value),
      quality: 85, // Default quality score
    );

    // If we already have a log for today, replace it, otherwise insert at top
    final today = DateTime.now();
    final index = historyLogs.indexWhere(
      (log) => log.date.year == today.year && log.date.month == today.month && log.date.day == today.day
    );
    if (index != -1) {
      historyLogs[index] = newLog;
    } else {
      historyLogs.insert(0, newLog);
    }

    // Sync with DashboardController
    try {
      final dashboardController = Get.find<DashboardController>();
      final currentData = dashboardController.dashboardData.value;
      
      // Calculate minutes
      final bedMinutes = bedtimeHour.value * 60 + bedtimeMinute.value;
      final wakeupMinutes = wakeupHour.value * 60 + wakeupMinute.value;
      int diffMinutes = wakeupMinutes - bedMinutes;
      if (diffMinutes < 0) {
        diffMinutes += 1440;
      }
      
      // Assume target is 7.5 hours = 450 minutes
      final progress = (diffMinutes / 450.0).clamp(0.0, 1.0);

      dashboardController.dashboardData.value = currentData.copyWith(
        isSleepLogged: true,
        lastSleepDuration: duration,
        sleepProgress: progress,
      );
    } catch (_) {}

    EasyLoading.showSuccess('Sleep logged successfully!');
    Get.back();
  }

  void addSleepLog({
    required DateTime date,
    required TimeOfDay bedtime,
    required TimeOfDay wakeupTime,
    required int quality,
  }) {
    final newLog = SleepLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: date,
      bedtime: bedtime,
      wakeupTime: wakeupTime,
      quality: quality,
    );
    historyLogs.insert(0, newLog);
    historyLogs.sort((a, b) => b.date.compareTo(a.date));
    EasyLoading.showSuccess('Sleep log added!');
  }

  void updateSleepLog({
    required String id,
    required DateTime date,
    required TimeOfDay bedtime,
    required TimeOfDay wakeupTime,
    required int quality,
  }) {
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
      EasyLoading.showSuccess('Sleep log updated!');
    }
  }

  void deleteLog(String id) {
    historyLogs.removeWhere((log) => log.id == id);
    EasyLoading.showSuccess('Sleep log deleted!');
  }
}
