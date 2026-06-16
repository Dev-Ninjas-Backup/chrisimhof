import 'dart:async';
import 'package:chrisimhof/features/dashboard/model/dashboard_model.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final Rx<DashboardModel> dashboardData = DashboardModel(
    date: DateTime(2026, 5, 19),
    userName: 'Christian',
    optimalBedtime: '21:00',
    timeUntilBedtime: 'in 2h 12m',
    rhythmScore: 82,
    waterLiters: 1.6,
    caffeineMg: 180,
    mealsLogged: 3,
    mealsTarget: 5,
    sportMinutes: 45,
    sleepProgress: 0.88,
    hydrationProgress: 0.72,
    caffeineProgress: 0.45,
    recoveryProgress: 0.90,
    workShift: 'Night · 22→06',
    workShiftCountdown: 'shift starts in 1h',
    workProgress: 0.35,
    lastSleepDuration: '6h 42m',
    sleepDebtText: 'debt 1h 18m / 7d',
    lastSleepWeekBars: [0.35, 0.55, 0.45, 0.50, 0.30, 0.70, 0.50],
    isSleepLogged: false,
    isSleepPrep: false,
  ).obs;

  Timer? _updateTimer;

  @override
  void onInit() {
    super.onInit();
    updateSleepPrepStatus();
    _updateTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => updateSleepPrepStatus(),
    );
  }

  @override
  void onClose() {
    _updateTimer?.cancel();
    super.onClose();
  }

  void updateSleepPrepStatus() {
    final current = dashboardData.value;
    try {
      final parts = current.optimalBedtime.split(':');
      if (parts.length == 2) {
        final bedHour = int.parse(parts[0]);
        final bedMin = int.parse(parts[1]);
        final targetMinutes = bedHour * 60 + bedMin;

        final now = DateTime.now();
        final currentMinutes = now.hour * 60 + now.minute;

        // Sleep prep starts 2 hours before bedtime, ends at 6:00 AM next morning
        final startPrepMinutes = (targetMinutes - 120 + 1440) % 1440;
        const endPrepMinutes = 6 * 60;

        bool isPrep = false;
        if (startPrepMinutes < endPrepMinutes) {
          isPrep =
              currentMinutes >= startPrepMinutes &&
              currentMinutes < endPrepMinutes;
        } else {
          isPrep =
              currentMinutes >= startPrepMinutes ||
              currentMinutes < endPrepMinutes;
        }

        int diff = targetMinutes - currentMinutes;
        if (diff < -120) {
          diff += 1440;
        } else if (diff > 1320) {
          diff -= 1440;
        }

        final bool isMissed = diff < 0 && !current.isSleepLogged;

        String timeUntil;
        if (diff > 0) {
          timeUntil = 'in ${diff ~/ 60}h ${diff % 60}m';
        } else if (diff == 0) {
          timeUntil = 'bedtime now';
        } else {
          timeUntil =
              '${-diff ~/ 60 > 0 ? "${-diff ~/ 60}h " : ""}${(-diff) % 60}m past bedtime';
        }

        dashboardData.value = current.copyWith(
          isSleepPrep: isPrep,
          timeUntilBedtime: timeUntil,
          minutesToBedtime: diff,
          isMissedBedtime: isMissed,
        );
      }
    } catch (_) {}
  }

  void toggleSleepPrep() {
    final current = dashboardData.value;
    dashboardData.value = current.copyWith(isSleepPrep: !current.isSleepPrep);
    EasyLoading.showToast(
      dashboardData.value.isSleepPrep
          ? 'Sleep Prep Mode Enabled'
          : 'Sleep Prep Mode Disabled',
    );
  }

  void logSleep() {
  }

  void addWater() {
    final current = dashboardData.value;
    final w = current.waterLiters + 0.25;
    dashboardData.value = current.copyWith(
      waterLiters: double.parse(w.toStringAsFixed(2)),
      hydrationProgress: (w / 2.0).clamp(0.0, 1.0),
    );
    EasyLoading.showToast('Water logged: +250ml');
  }

  void addCaffeine() {
    final current = dashboardData.value;
    final c = current.caffeineMg + 40;
    dashboardData.value = current.copyWith(
      caffeineMg: c,
      caffeineProgress: (c / 400.0).clamp(0.0, 1.0),
    );
    EasyLoading.showToast('Caffeine logged: +40mg');
  }

  void addMeal() {
    Get.toNamed(AppRoutes.nutritionScreen);
  }

  void addSport() {
    Get.toNamed(AppRoutes.sportsScreen);
  }

  void endMyDay() {
    EasyLoading.showSuccess('Day ended, saving stats...');
    final current = dashboardData.value;
    dashboardData.value = current.copyWith(
      waterLiters: 0.0,
      caffeineMg: 0,
      mealsLogged: 0,
      sportMinutes: 0,
      hydrationProgress: 0.0,
      caffeineProgress: 0.0,
      isSleepLogged: false,
    );
  }
}
