import 'package:chrisimhof/features/dashboard/work/controller/work_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class RotationTemplate {
  final String title;
  final String description;
  final int weeks;
  final List<String> pattern;

  const RotationTemplate({
    required this.title,
    required this.description,
    required this.weeks,
    required this.pattern,
  });
}

class WorkScheduleSettingsController extends GetxController {
  final isEnabled = true.obs;
  final weeks = 1.obs;
  final startDate = DateTime.now().obs;
  final shiftTimes = <String, Map<String, String>>{
    'Day': {'start': '06:00', 'end': '14:00'},
    'Evening': {'start': '14:00', 'end': '22:00'},
    'Night': {'start': '22:00', 'end': '06:00'},
  }.obs;
  final pattern = <String>[].obs;
  final overrides = <String, String>{}.obs;

  // Selected template index for bottom sheet template picker
  final selectedTemplateIndex = 0.obs;

  // Currently expanding/editing day in Upcoming Schedule
  final editingDateStr = ''.obs;

  // List of available rotation templates
  final List<RotationTemplate> templates = [
    const RotationTemplate(
      title: '3-2-2 Night',
      description: '3 nights, 3 off, 2 evenings — repeats weekly',
      weeks: 1,
      pattern: ['N', 'N', 'N', 'Off', 'Off', 'E', 'E'],
    ),
    const RotationTemplate(
      title: '2-2-3 Panama',
      description: '2 on, 3 off, 3 on, alternating weekends',
      weeks: 2,
      pattern: [
        'D', 'D', 'Off', 'Off', 'D', 'D', 'D',
        'Off', 'Off', 'D', 'D', 'Off', 'Off', 'Off',
      ],
    ),
    const RotationTemplate(
      title: 'DuPont',
      description: '4-on/4-off, 7-day break every cycle',
      weeks: 4,
      pattern: [
        'N', 'N', 'N', 'N', 'Off', 'Off', 'Off',
        'D', 'D', 'D', 'Off', 'Off', 'Off', 'Off',
        'N', 'N', 'N', 'Off', 'Off', 'Off', 'Off',
        'D', 'D', 'D', 'D', 'Off', 'Off', 'Off',
      ],
    ),
    // const RotationTemplate(
    //   title: '4-On 4-Off',
    //   description: '4 working days followed by 4 days off',
    //   weeks: 2,
    //   pattern: [
    //     'D', 'D', 'D', 'D', 'Off', 'Off', 'Off', 'Off',
    //     'D', 'D', 'D', 'D', 'Off', 'Off',
    //   ],
    // ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize default pattern if empty
    if (pattern.isEmpty) {
      pattern.assignAll(List.generate(7 * weeks.value, (_) => 'Off'));
    }
  }

  void setWeeks(int newWeeks) {
    if (newWeeks < 1 || newWeeks > 8) return;
    final targetLength = 7 * newWeeks;
    final currentPattern = List<String>.from(pattern);

    if (currentPattern.length < targetLength) {
      currentPattern.addAll(
        List.generate(targetLength - currentPattern.length, (_) => 'Off'),
      );
    } else if (currentPattern.length > targetLength) {
      pattern.assignAll(currentPattern.sublist(0, targetLength));
      weeks.value = newWeeks;
      return;
    }
    pattern.assignAll(currentPattern);
    weeks.value = newWeeks;
  }

  void updateDayPattern(int dayIndex, String shiftCode) {
    if (dayIndex >= 0 && dayIndex < pattern.length) {
      pattern[dayIndex] = shiftCode;
    }
  }

  void applyTemplate(RotationTemplate tmpl) {
    weeks.value = tmpl.weeks;
    pattern.assignAll(tmpl.pattern);
  }

  int getPatternIndexForDate(DateTime date) {
    final startDateClean = DateTime(
      startDate.value.year,
      startDate.value.month,
      startDate.value.day,
    );
    final dateClean = DateTime(date.year, date.month, date.day);
    final diffDays = dateClean.difference(startDateClean).inDays;

    final cycleLength = 7 * weeks.value;
    if (cycleLength <= 0 || pattern.isEmpty) return -1;

    final patternIndex =
        ((diffDays % cycleLength) + cycleLength) % cycleLength;
    if (patternIndex >= 0 && patternIndex < pattern.length) {
      return patternIndex;
    }
    return -1;
  }

  Future<void> applyDayOverride(DateTime date, String shiftCode) async {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    overrides[dateStr] = shiftCode;

    // Auto-reflect in BUILD YOUR ROTATION
    final idx = getPatternIndexForDate(date);
    if (idx >= 0 && idx < pattern.length) {
      pattern[idx] = shiftCode;
    }

    editingDateStr.value = '';

    try {
      final workCtrl = Get.find<WorkController>();
      await loadCustomRotationSchedule(workCtrl);
    } catch (_) {}
  }

  Future<void> revertDayOverride(DateTime date) async {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    overrides.remove(dateStr);
    editingDateStr.value = '';

    try {
      final workCtrl = Get.find<WorkController>();
      await loadCustomRotationSchedule(workCtrl);
    } catch (_) {}
  }

  Future<void> saveSettings() async {
    try {
      EasyLoading.show(status: 'Saving work schedule...'.tr);

      // Save logic ready for future API integration (currently in-memory)

      // Refresh WorkController schedule logic
      try {
        final workCtrl = Get.find<WorkController>();
        await loadCustomRotationSchedule(workCtrl);
      } catch (_) {}

      EasyLoading.showSuccess('Work schedule saved!'.tr);
      Get.back();
    } catch (e) {
      debugPrint('Error saving settings: $e');
      EasyLoading.showError('Failed to save settings'.tr);
    }
  }

  Future<void> loadCustomRotationSchedule(WorkController workCtrl) async {
    if (!isEnabled.value) return;

    final startDateVal = startDate.value;
    final weeksVal = weeks.value;
    final patternList = pattern;
    final overridesMap = overrides;

    final now = DateTime.now();
    final monday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final computedPattern = <Map<String, String>>[];

    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      String shift = 'Off';
      if (overridesMap.containsKey(dateStr)) {
        shift = overridesMap[dateStr]!;
      } else {
        final startDateClean = DateTime(
          startDateVal.year,
          startDateVal.month,
          startDateVal.day,
        );
        final dateClean = DateTime(date.year, date.month, date.day);
        final diffDays = dateClean.difference(startDateClean).inDays;

        final cycleLength = 7 * weeksVal;
        if (cycleLength > 0 && patternList.isNotEmpty) {
          final patternIndex =
              ((diffDays % cycleLength) + cycleLength) % cycleLength;
          if (patternIndex < patternList.length) {
            shift = patternList[patternIndex];
          }
        }
      }
      computedPattern.add({'day': days[i], 'shift': shift});
    }

    workCtrl.weeklyPattern.assignAll(computedPattern);

    // Update selectedShiftType and times for today
    final todayIndex = now.weekday - 1;
    final todayShift = computedPattern[todayIndex]['shift']!;
    workCtrl.selectedShiftType.value = todayShift == 'D'
        ? 'Day'
        : todayShift == 'E'
        ? 'Evening'
        : todayShift == 'N'
        ? 'Night'
        : 'Off';

    final times = shiftTimes;
    final shiftName = workCtrl.selectedShiftType.value;
    if (times.containsKey(shiftName)) {
      final start = times[shiftName]!['start']!;
      final end = times[shiftName]!['end']!;
      final startParts = start.split(':');
      final endParts = end.split(':');
      if (startParts.length == 2) {
        workCtrl.startHour.value =
            int.tryParse(startParts[0]) ?? workCtrl.startHour.value;
        workCtrl.startMinute.value =
            int.tryParse(startParts[1]) ?? workCtrl.startMinute.value;
      }
      if (endParts.length == 2) {
        workCtrl.endHour.value =
            int.tryParse(endParts[0]) ?? workCtrl.endHour.value;
        workCtrl.endMinute.value =
            int.tryParse(endParts[1]) ?? workCtrl.endMinute.value;
      }
    }
  }

  // Get computed shift code for any given DateTime based on rotation pattern & overrides
  String getShiftForDate(DateTime date) {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    if (overrides.containsKey(dateStr)) {
      return overrides[dateStr]!;
    }

    final startDateClean = DateTime(
      startDate.value.year,
      startDate.value.month,
      startDate.value.day,
    );
    final dateClean = DateTime(date.year, date.month, date.day);
    final diffDays = dateClean.difference(startDateClean).inDays;

    final cycleLength = 7 * weeks.value;
    if (cycleLength <= 0 || pattern.isEmpty) return 'Off';

    final patternIndex =
        ((diffDays % cycleLength) + cycleLength) % cycleLength;
    if (patternIndex < pattern.length) {
      return pattern[patternIndex];
    }
    return 'Off';
  }
}
