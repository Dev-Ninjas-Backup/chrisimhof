import 'package:get/get.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class WorkController extends GetxController {
  final startHour = 22.obs;
  final startMinute = 0.obs;
  final endHour = 6.obs;
  final endMinute = 0.obs;
  final selectedShiftType = 'Night'.obs;

  final weeklyPattern = <Map<String, String>>[
    {'day': 'M', 'shift': 'N'},
    {'day': 'T', 'shift': 'N'},
    {'day': 'W', 'shift': 'N'},
    {'day': 'T', 'shift': 'Off'},
    {'day': 'F', 'shift': 'Off'},
    {'day': 'S', 'shift': 'D'},
    {'day': 'S', 'shift': 'D'},
  ].obs;

  final defaultRotation = '3-2-2 night'.obs;
  final shiftReminders = 'On · 30 min before'.obs;
  final timeZone = 'CET · Geneva'.obs;

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

  void saveShift() {
    try {
      final dashboardController = Get.find<DashboardController>();
      final currentData = dashboardController.dashboardData.value;
      String workShiftStr = '';
      String countdownStr = '';
      double progress = 0.35;

      if (selectedShiftType.value == 'Off') {
        workShiftStr = 'Off Today';
        countdownStr = 'No shifts scheduled';
        progress = 0.0;
      } else {
        final startHStr = startHour.value.toString().padLeft(2, '0');
        final startMStr = startMinute.value.toString().padLeft(2, '0');
        final endHStr = endHour.value.toString().padLeft(2, '0');
        final endMStr = endMinute.value.toString().padLeft(2, '0');
        workShiftStr = '${selectedShiftType.value} · $startHStr:$startMStr→$endHStr:$endMStr';

        final now = DateTime.now();
        final currentMin = now.hour * 60 + now.minute;
        final startMin = startHour.value * 60 + startMinute.value;
        final endMin = endHour.value * 60 + endMinute.value;

        int diffMin = (startMin - currentMin + 1440) % 1440;
        final hoursUntil = diffMin ~/ 60;
        countdownStr = hoursUntil > 0 ? 'shift starts in ${hoursUntil}h' : 'shift starts in ${diffMin}m';

        bool inProgress = false;
        if (startMin < endMin) {
          inProgress = currentMin >= startMin && currentMin < endMin;
          if (inProgress) progress = (currentMin - startMin) / (endMin - startMin);
        } else {
          inProgress = currentMin >= startMin || currentMin < endMin;
          if (inProgress) {
            int total = endMin - startMin + 1440;
            int elapsed = currentMin >= startMin ? (currentMin - startMin) : (currentMin + 1440 - startMin);
            progress = elapsed / total;
          }
        }
        if (inProgress) countdownStr = 'shift in progress';
        progress = progress.clamp(0.0, 1.0);
      }

      dashboardController.dashboardData.value = currentData.copyWith(
        workShift: workShiftStr,
        workShiftCountdown: countdownStr,
        workProgress: progress == 0.0 ? 0.35 : progress,
      );
    } catch (_) {}

    EasyLoading.showSuccess('Shift saved successfully!');
    Get.back();
  }
}
