import 'package:chrisimhof/core/service/helper/custom_rotation_prefs.dart';
import 'package:chrisimhof/features/dashboard/work/controller/work_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

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

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      final savedEnabled = await CustomRotationPrefs.isEnabled();
      isEnabled.value = savedEnabled;

      final savedWeeks = await CustomRotationPrefs.getWeeks();
      weeks.value = savedWeeks;

      final startStr = await CustomRotationPrefs.getStartDate();
      if (startStr.isNotEmpty) {
        startDate.value = DateTime.tryParse(startStr) ?? DateTime.now();
      }

      final times = await CustomRotationPrefs.getShiftTimes();
      shiftTimes.assignAll(times);

      final pat = await CustomRotationPrefs.getPattern(weeks.value);
      pattern.assignAll(pat);
    } catch (e) {
      debugPrint(
        'Error loading settings in WorkScheduleSettingsController: $e',
      );
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

  Future<void> saveSettings() async {
    try {
      EasyLoading.show(status: 'Saving work schedule...'.tr);
      await CustomRotationPrefs.setEnabled(isEnabled.value);
      await CustomRotationPrefs.setWeeks(weeks.value);

      final dateStr =
          '${startDate.value.year}-${startDate.value.month.toString().padLeft(2, '0')}-${startDate.value.day.toString().padLeft(2, '0')}';
      await CustomRotationPrefs.setStartDate(dateStr);
      await CustomRotationPrefs.setShiftTimes(shiftTimes);
      await CustomRotationPrefs.setPattern(pattern);

      // Refresh WorkController schedule logic
      try {
        final workCtrl = Get.find<WorkController>();
        await workCtrl.loadCustomRotationSchedule();
      } catch (_) {}

      EasyLoading.showSuccess('Work schedule saved!'.tr);
      Get.back();
    } catch (e) {
      debugPrint('Error saving settings: $e');
      EasyLoading.showError('Failed to save settings'.tr);
    }
  }

  Future<void> loadCustomRotationSchedule(WorkController workCtrl) async {
    final customEnabled = await CustomRotationPrefs.isEnabled();
    if (!customEnabled) return;

    final startStr = await CustomRotationPrefs.getStartDate();
    final startDate = DateTime.tryParse(startStr) ?? DateTime.now();
    final weeks = await CustomRotationPrefs.getWeeks();
    final pattern = await CustomRotationPrefs.getPattern(weeks);
    final overrides = await CustomRotationPrefs.getOverrides();

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
      if (overrides.containsKey(dateStr)) {
        shift = overrides[dateStr]!;
      } else {
        final startDateClean = DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
        );
        final dateClean = DateTime(date.year, date.month, date.day);
        final diffDays = dateClean.difference(startDateClean).inDays;

        final cycleLength = 7 * weeks;
        final patternIndex =
            ((diffDays % cycleLength) + cycleLength) % cycleLength;
        shift = pattern[patternIndex];
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

    final times = await CustomRotationPrefs.getShiftTimes();
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
}
