import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/features/dashboard/work/controller/work_controller.dart';
import 'package:chrisimhof/features/work_schedule_settings/controller/work_schedule_settings_controller.dart';
import 'package:chrisimhof/features/work_schedule_settings/model/user_work_rotation_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.reset();
  });

  group('Home Screen Work Schedule Display Tests', () {
    test('Personalized shift names appear accurately on Home Screen', () {
      final dashboardCtrl = Get.put(DashboardController());
      Get.put(WorkController());
      final settingsCtrl = Get.put(WorkScheduleSettingsController());

      // 1. Enable custom rotation with user-defined shift labels
      settingsCtrl.isEnabled.value = true;
      settingsCtrl.hasRotationData.value = true;
      settingsCtrl.rotationName.value = 'Continental 4-Shift';
      settingsCtrl.weeks.value = 1;
      settingsCtrl.startDate.value = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

      settingsCtrl.shiftTimes.assignAll({
        'Morning': {'start': '06:00', 'end': '14:00'},
        'Evening': {'start': '14:00', 'end': '22:00'},
        'Sunday Morning': {'start': '08:00', 'end': '16:00'},
        'Night': {'start': '22:00', 'end': '06:00'},
      });

      // Today's day index in pattern: set to 'Sunday Morning'
      final todayIndex = (DateTime.now().weekday - 1) % 7;
      final pattern = List.generate(7, (_) => 'Morning');
      pattern[todayIndex] = 'Sunday Morning';
      settingsCtrl.pattern.assignAll(pattern);

      // Trigger dashboard update from live scores payload
      final payload = {
        'success': true,
        'data': {
          'globalRhythmScore': 85,
          'workInfo': {
            'shiftType': 'day',
            'shiftStartTime': '08:00',
            'shiftEndTime': '16:00',
          },
        },
      };

      dashboardCtrl.updateFromLiveScores(payload, useLocalCaches: false);

      final data = dashboardCtrl.dashboardData.value;
      // Exact personalized name must appear on the home screen!
      expect(data.workShift, 'Sunday Morning');
      expect(data.workShiftCountdown, '08:00 — 16:00');
      expect(data.workRotationName, 'Continental 4-Shift');
    });

    test('Vacation and Rest Day display cleanly without generic shift suffix', () {
      final dashboardCtrl = Get.put(DashboardController());
      Get.put(WorkController());
      final settingsCtrl = Get.put(WorkScheduleSettingsController());

      settingsCtrl.isEnabled.value = true;
      settingsCtrl.hasRotationData.value = true;
      settingsCtrl.weeks.value = 1;
      settingsCtrl.startDate.value = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

      final todayIndex = (DateTime.now().weekday - 1) % 7;
      final pattern = List.generate(7, (_) => 'Morning');
      pattern[todayIndex] = 'Vacation';
      settingsCtrl.pattern.assignAll(pattern);

      dashboardCtrl.updateFromLiveScores({
        'data': {
          'workInfo': {'shiftType': 'off'},
        },
      }, useLocalCaches: false);

      expect(dashboardCtrl.dashboardData.value.workShift, 'Vacation');
      expect(dashboardCtrl.dashboardData.value.workShiftCountdown, 'No shifts scheduled');
      expect(dashboardCtrl.dashboardData.value.workProgress, 0.0);

      // Rest Day
      pattern[todayIndex] = 'Rest Day';
      settingsCtrl.pattern.assignAll(pattern);

      dashboardCtrl.updateFromLiveScores({
        'data': {
          'workInfo': {'shiftType': 'off'},
        },
      }, useLocalCaches: false);

      expect(dashboardCtrl.dashboardData.value.workShift, 'Rest Day');
      expect(dashboardCtrl.dashboardData.value.workShiftCountdown, 'No shifts scheduled');
    });

    test('Date override displays exact personalized label on Home Screen', () {
      final dashboardCtrl = Get.put(DashboardController());
      Get.put(WorkController());
      final settingsCtrl = Get.put(WorkScheduleSettingsController());

      settingsCtrl.isEnabled.value = true;
      settingsCtrl.hasRotationData.value = true;
      settingsCtrl.weeks.value = 1;
      settingsCtrl.startDate.value = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
      settingsCtrl.shiftTimes.assignAll({
        'Morning': {'start': '06:00', 'end': '14:00'},
        'Sunday Morning': {'start': '08:00', 'end': '16:00'},
      });

      final pattern = List.generate(7, (_) => 'Morning');
      settingsCtrl.pattern.assignAll(pattern);

      final now = DateTime.now();
      final dateStr =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      settingsCtrl.overrides[dateStr] = 'Sunday Morning';

      dashboardCtrl.updateFromLiveScores({
        'data': {
          'workInfo': {'shiftType': 'day', 'shiftStartTime': '06:00', 'shiftEndTime': '14:00'},
        },
      }, useLocalCaches: false);

      expect(dashboardCtrl.dashboardData.value.workShift, 'Sunday Morning');
      expect(dashboardCtrl.dashboardData.value.workShiftCountdown, '08:00 — 16:00');
    });

    test('Standard shifts display clean names without appending shift', () {
      final dashboardCtrl = Get.put(DashboardController());

      dashboardCtrl.updateFromLiveScores({
        'data': {
          'workInfo': {
            'shiftType': 'day',
            'shiftStartTime': '06:00',
            'shiftEndTime': '14:00',
          },
        },
      }, useLocalCaches: false);

      // Must be "Day", NOT "Day shift" or "Day Shift"
      expect(dashboardCtrl.dashboardData.value.workShift, 'Day');
      expect(dashboardCtrl.dashboardData.value.workShiftCountdown, '06:00 — 14:00');

      dashboardCtrl.updateFromLiveScores({
        'data': {
          'workInfo': {
            'shiftType': 'evening',
            'shiftStartTime': '14:00',
            'shiftEndTime': '22:00',
          },
        },
      }, useLocalCaches: false);

      expect(dashboardCtrl.dashboardData.value.workShift, 'Evening');
      expect(dashboardCtrl.dashboardData.value.workShiftCountdown, '14:00 — 22:00');
    });

    test('UserWorkRotationModel parses custom shift names from API correctly', () {
      final json = {
        'id': 'rot-123',
        'name': 'Custom Rota',
        'cycleWeeks': 1,
        'startDate': '2026-10-19',
        'timezone': 'Europe/Zurich',
        'sourceTemplateKey': '',
        'shiftTimesJson': {
          'morning': {'startTime': '06:00', 'endTime': '14:00'},
          'sunday_morning': {'startTime': '08:00', 'endTime': '16:00'},
          'vacation': {'startTime': '00:00', 'endTime': '00:00'},
          'rest_day': {'startTime': '00:00', 'endTime': '00:00'},
        },
        'patternJson': [
          {'weekIndex': 0, 'dayIndex': 0, 'shiftCode': 'morning'},
          {'weekIndex': 0, 'dayIndex': 1, 'shiftCode': 'morning'},
          {'weekIndex': 0, 'dayIndex': 2, 'shiftCode': 'sunday_morning'},
          {'weekIndex': 0, 'dayIndex': 3, 'shiftCode': 'vacation'},
          {'weekIndex': 0, 'dayIndex': 4, 'shiftCode': 'rest_day'},
          {'weekIndex': 0, 'dayIndex': 5, 'shiftCode': 'off'},
          {'weekIndex': 0, 'dayIndex': 6, 'shiftCode': 'off'},
        ],
        'overridesJson': {
          '2026-10-19': {'shiftCode': 'sunday_morning'},
          '2026-10-20': 'vacation',
        },
      };

      final model = UserWorkRotationModel.fromJson(json);

      expect(model.shiftTimes.containsKey('Morning'), isTrue);
      expect(model.shiftTimes.containsKey('Sunday Morning'), isTrue);
      expect(model.shiftTimes.containsKey('Vacation'), isTrue);
      expect(model.shiftTimes.containsKey('Rest Day'), isTrue);

      expect(model.pattern[0], 'Morning');
      expect(model.pattern[2], 'Sunday Morning');
      expect(model.pattern[3], 'Vacation');
      expect(model.pattern[4], 'Rest Day');
      expect(model.pattern[5], 'Off');

      expect(model.overrides['2026-10-19'], 'Sunday Morning');
      expect(model.overrides['2026-10-20'], 'Vacation');
    });
  });
}
