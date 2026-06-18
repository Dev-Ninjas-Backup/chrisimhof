import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/service/dashboard_service.dart';
import 'package:chrisimhof/features/dashboard/work/service/work_service.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class WorkController extends GetxController {
  final startHour = 22.obs;
  final startMinute = 0.obs;
  final endHour = 6.obs;
  final endMinute = 0.obs;
  final selectedShiftType = 'Off'.obs;

  // Weekly pattern — defaults to "Off" for all days until API data arrives
  final weeklyPattern = <Map<String, String>>[
    {'day': 'M', 'shift': 'Off'},
    {'day': 'T', 'shift': 'Off'},
    {'day': 'W', 'shift': 'Off'},
    {'day': 'T', 'shift': 'Off'},
    {'day': 'F', 'shift': 'Off'},
    {'day': 'S', 'shift': 'Off'},
    {'day': 'S', 'shift': 'Off'},
  ].obs;

  final defaultRotation = ''.obs;
  final shiftReminders = 'On · 30 min before'.obs;
  final timeZone = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFromDashboard();
  }

  void _initializeFromDashboard() {
    try {
      final dashboardController = Get.find<DashboardController>();
      final data = dashboardController.dashboardData.value;
      
      final shift = data.workShift.toLowerCase();
      if (shift.contains('day') || shift.contains('jour')) {
        selectedShiftType.value = 'Day';
      } else if (shift.contains('evening') || shift.contains('après-midi') || shift.contains('apres-midi')) {
        selectedShiftType.value = 'Evening';
      } else if (shift.contains('night') || shift.contains('nuit') || shift.contains('soir')) {
        selectedShiftType.value = 'Night';
      } else {
        selectedShiftType.value = 'Off';
      }

      // Extract start & end times
      final times = data.workShiftCountdown.split(RegExp(r'[\s—\-\+]+'));
      if (times.length >= 2) {
        final startParts = times[0].split(':');
        if (startParts.length == 2) {
          startHour.value = int.tryParse(startParts[0]) ?? startHour.value;
          startMinute.value = int.tryParse(startParts[1]) ?? startMinute.value;
        }
        final endParts = times[1].split(':');
        if (endParts.length == 2) {
          endHour.value = int.tryParse(endParts[0]) ?? endHour.value;
          endMinute.value = int.tryParse(endParts[1]) ?? endMinute.value;
        }
      }
    } catch (e) {
      debugPrint('WorkController: Error initializing from dashboard data: $e');
    }
  }

  void incrementStartHour() => startHour.value = (startHour.value + 1) % 24;
  void decrementStartHour() => startHour.value = (startHour.value - 1 + 24) % 24;
  void incrementStartMinute() => startMinute.value = (startMinute.value + 5) % 60;
  void decrementStartMinute() => startMinute.value = (startMinute.value - 5 + 60) % 60;

  void incrementEndHour() => endHour.value = (endHour.value + 1) % 24;
  void decrementEndHour() => endHour.value = (endHour.value - 1 + 24) % 24;
  void incrementEndMinute() => endMinute.value = (endMinute.value + 5) % 60;
  void decrementEndMinute() => endMinute.value = (endMinute.value - 5 + 60) % 60;

  String get shiftDurationText {
    final startMin = startHour.value * 60 + startMinute.value;
    final endMin = endHour.value * 60 + endMinute.value;
    int diffMin = (endMin - startMin + 1440) % 1440;
    final hours = diffMin / 60.0;
    return hours == hours.toInt() ? '${hours.toInt()}h' : '${hours.toStringAsFixed(1)}h';
  }

  void selectShift(String shift) {
    selectedShiftType.value = shift;
    if (shift == 'Day') {
      startHour.value = 9; startMinute.value = 0; endHour.value = 17; endMinute.value = 0;
    } else if (shift == 'Evening') {
      startHour.value = 14; startMinute.value = 0; endHour.value = 22; endMinute.value = 0;
    } else if (shift == 'Night') {
      startHour.value = 22; startMinute.value = 0; endHour.value = 6; endMinute.value = 0;
    } else if (shift == 'Off') {
      startHour.value = 0; startMinute.value = 0; endHour.value = 0; endMinute.value = 0;
    }
  }

  void toggleDayShift(int index) {
    final currentShift = weeklyPattern[index]['shift'];
    String nextShift = 'Off';
    if (currentShift == 'N') {
      nextShift = 'Off';
    } else if (currentShift == 'Off') {
      nextShift = 'D';
    } else if (currentShift == 'D') {
      nextShift = 'E';
    } else if (currentShift == 'E') {
      nextShift = 'N';
    }
    weeklyPattern[index] = {'day': weeklyPattern[index]['day']!, 'shift': nextShift};
  }

  void applyRotationPattern(String pattern) {
    defaultRotation.value = pattern;
    final Map<String, List<String>> patterns = {
      '3-2-2 night': ['N', 'N', 'N', 'Off', 'Off', 'D', 'D'],
      '2-2-3 schedule': ['D', 'D', 'N', 'N', 'Off', 'Off', 'Off'],
      '4-4 split': ['D', 'D', 'D', 'D', 'Off', 'Off', 'Off'],
      'None (Fixed)': ['D', 'D', 'D', 'D', 'D', 'Off', 'Off'],
    };
    final list = patterns[pattern];
    if (list != null) {
      final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
      weeklyPattern.assignAll(List.generate(7, (i) => {'day': days[i], 'shift': list[i]}));
    }
  }

  void saveShift() async {
    EasyLoading.show(status: 'Saving work shift...');
    try {
      final sessionId = await SharedPreferencesHelper.getSessionId();
      if (sessionId != null && sessionId.isNotEmpty) {
        final shiftType = selectedShiftType.value.toLowerCase();
        
        final startHStr = startHour.value.toString().padLeft(2, '0');
        final startMStr = startMinute.value.toString().padLeft(2, '0');
        final endHStr = endHour.value.toString().padLeft(2, '0');
        final endMStr = endMinute.value.toString().padLeft(2, '0');

        final shiftStartTime = shiftType == 'off' ? null : '$startHStr:$startMStr';
        final shiftEndTime = shiftType == 'off' ? null : '$endHStr:$endMStr';

        // 1. Post to Work Service
        await WorkService().saveWork(
          sessionId: sessionId,
          shiftType: shiftType,
          shiftStartTime: shiftStartTime,
          shiftEndTime: shiftEndTime,
        );

        // 2. Central session calculations
        await DashboardService().calculateResult(sessionId: sessionId);

        // 3. Sync and refresh dashboard controller
        try {
          final dashboardController = Get.find<DashboardController>();
          await dashboardController.fetchDashboardData();
        } catch (_) {}

        EasyLoading.showSuccess('Shift saved successfully!');
        Get.back();
      } else {
        EasyLoading.showError('No active session found.');
      }
    } catch (e) {
      debugPrint('Error saving work shift: $e');
      EasyLoading.showError('Failed to save shift.');
    }
  }

  void updateFromLiveScoresTab(Map<String, dynamic> tabData) {
    try {
      if (tabData['shiftType'] != null) {
        final sType = tabData['shiftType'] as String;
        if (sType.isNotEmpty) {
          selectedShiftType.value = sType[0].toUpperCase() + sType.substring(1);
        }
      }
      if (tabData['shiftStartTime'] != null) {
        final parts = (tabData['shiftStartTime'] as String).split(':');
        if (parts.length == 2) {
          startHour.value = int.tryParse(parts[0]) ?? 22;
          startMinute.value = int.tryParse(parts[1]) ?? 0;
        }
      }
      if (tabData['shiftEndTime'] != null) {
        final parts = (tabData['shiftEndTime'] as String).split(':');
        if (parts.length == 2) {
          endHour.value = int.tryParse(parts[0]) ?? 6;
          endMinute.value = int.tryParse(parts[1]) ?? 0;
        }
      }

      final List? patternList = tabData['weeklyPatternDisplay'] as List?;
      if (patternList != null) {
        weeklyPattern.assignAll(patternList.map((item) {
          return {
            'day': item['day'] as String? ?? '',
            'shift': item['shiftCode'] as String? ?? 'Off',
          };
        }).toList());
      }

      final settings = tabData['settings'] as Map<String, dynamic>?;
      if (settings != null) {
        if (settings['defaultRotation'] != null) {
          defaultRotation.value = settings['defaultRotation'] as String;
        }
        if (settings['shiftReminderDisplay'] != null) {
          shiftReminders.value = settings['shiftReminderDisplay'] as String;
        }
        if (settings['timezoneDisplay'] != null) {
          timeZone.value = settings['timezoneDisplay'] as String;
        }
      }
    } catch (e) {
      debugPrint('WorkController socket update error: $e');
    }
  }
}
