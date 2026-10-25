import 'package:chrisimhof/core/common/widgets/app_translations.dart';
import 'package:chrisimhof/core/service/helper/time_format_helper.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/model/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    Get.clearTranslations();
    Get.addTranslations(AppTranslations().keys);
  });

  group('Bedtime ASAP / MTN Localization Tests', () {
    test('TimeFormatHelper formats ASAP as MTN in French', () {
      Get.locale = const Locale('fr', 'FR');

      expect(TimeFormatHelper.formatBedtime('ASAP'), 'MTN');
      expect(TimeFormatHelper.formatBedtime('asap'), 'MTN');
      expect(TimeFormatHelper.formatBedtime('Asap'), 'MTN');
      expect(TimeFormatHelper.formatBedtime('MTN'), 'MTN');
      expect(TimeFormatHelper.formatBedtime('mtn'), 'MTN');
      expect(TimeFormatHelper.formatBedtime('MTNT'), 'MTN');
    });

    test('TimeFormatHelper formats ASAP as ASAP in English', () {
      Get.locale = const Locale('en', 'US');

      expect(TimeFormatHelper.formatBedtime('ASAP'), 'ASAP');
      expect(TimeFormatHelper.formatBedtime('asap'), 'ASAP');
      expect(TimeFormatHelper.formatBedtime('Asap'), 'ASAP');
      expect(TimeFormatHelper.formatBedtime('MTN'), 'ASAP');
      expect(TimeFormatHelper.formatBedtime('MTNT'), 'ASAP');
    });

    test('TimeFormatHelper preserves standard time formats in both languages', () {
      Get.locale = const Locale('fr', 'FR');
      expect(TimeFormatHelper.formatBedtime('22:30'), '22:30');
      expect(TimeFormatHelper.formatBedtime('06:00'), '06:00');
      expect(TimeFormatHelper.formatBedtime('--:--'), '--:--');

      Get.locale = const Locale('en', 'US');
      expect(TimeFormatHelper.formatBedtime('22:30'), '22:30');
      expect(TimeFormatHelper.formatBedtime('06:00'), '06:00');
      expect(TimeFormatHelper.formatBedtime('--:--'), '--:--');
    });

    test('DashboardModel.displayOptimalBedtime adapts dynamically to locale', () {
      final model = DashboardModel(
        date: DateTime.now(),
        userName: 'User',
        optimalBedtime: 'ASAP',
        timeUntilBedtime: 'Sleep ASAP',
        rhythmScore: 80,
        waterLiters: 1.5,
        caffeineMg: 50,
        mealsLogged: 2,
        mealsTarget: 3,
        sportMinutes: 45,
        waterDisplay: '1.5L',
        caffeineDisplay: '50mg',
        mealsDisplay: '2/3',
        sportDisplay: '45m',
        sleepProgress: 0.8,
        hydrationProgress: 0.6,
        caffeineProgress: 0.5,
        recoveryProgress: 0.7,
        workShift: 'Day',
        workShiftCountdown: '06:00 — 14:00',
        workProgress: 0.5,
        workRotationName: 'Test',
        lastSleepDuration: '7h',
        sleepDebtText: '0m',
        lastSleepWeekBars: [0.5, 0.6],
        isSleepLogged: false,
        isSleepPrep: true,
        isMissedBedtime: true,
        minutesToBedtime: 0,
        hoursUntilBed: 0.0,
        bedtimeBufferMinutes: 0,
        activeCaffeineAtBedtimeMg: 0.0,
      );

      Get.locale = const Locale('fr', 'FR');
      expect(model.displayOptimalBedtime, 'MTN');

      Get.locale = const Locale('en', 'US');
      expect(model.displayOptimalBedtime, 'ASAP');
    });

    test('AppTranslations dictionary verifies ASAP and French mappings', () {
      Get.locale = const Locale('fr', 'FR');
      expect('ASAP'.tr, 'MTN');
      expect('Sleep ASAP'.tr, 'Dormir MTN');

      Get.locale = const Locale('en', 'US');
      expect('ASAP'.tr, 'ASAP');
      expect('Sleep ASAP'.tr, 'Sleep ASAP');
    });
  });
}
