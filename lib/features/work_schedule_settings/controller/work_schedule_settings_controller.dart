import 'package:chrisimhof/features/dashboard/work/controller/work_controller.dart';
import 'package:chrisimhof/features/work_schedule_settings/model/work_rotation_calendar_model.dart';
import 'package:chrisimhof/features/work_schedule_settings/model/work_rotation_preset_model.dart';
import 'package:chrisimhof/features/work_schedule_settings/service/work_schedule_settings_service.dart';
import 'package:chrisimhof/features/work_schedule_settings/widgets/template_selection_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class WorkScheduleSettingsController extends GetxController {
  final isEnabled = false.obs;
  final weeks = 1.obs;
  final startDate = DateTime.now().obs;
  final shiftTimes = <String, Map<String, String>>{
    'Day': {'start': '06:00', 'end': '14:00'},
    'Evening': {'start': '14:00', 'end': '22:00'},
    'Night': {'start': '22:00', 'end': '06:00'},
  }.obs;
  final pattern = <String>[].obs;
  final overrides = <String, String>{}.obs;
  final hasRotationData = false.obs;
  final rotationName = ''.obs;
  final activeRotationKey = ''.obs;
  final activeRotationName = ''.obs;
  final isCreatingNewRotation = false.obs;
  final rotationNameController = TextEditingController();

  // Selected preset index for bottom sheet template picker
  final selectedTemplateIndex = 0.obs;
  final selectedTemplateKey = ''.obs;
  final isLoadingPresets = false.obs;
  final isRotationLoading = false.obs;
  final isLoadingCalendar = false.obs;
  final apiPresets = <WorkRotationPresetModel>[].obs;
  final upcomingScheduleDays = <WorkRotationCalendarDayModel>[].obs;

  // Calendar query parameters selected by user
  final calendarFromDate = DateTime.now().obs;
  final calendarDaysLimit = 7.obs;

  final WorkScheduleSettingsService _service = WorkScheduleSettingsService();

  // Currently expanding/editing day in Upcoming Schedule
  final editingDateStr = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (pattern.isEmpty) {
      pattern.assignAll(List.generate(7 * weeks.value, (_) => 'Off'));
    }
    fetchMyWorkRotation();
    loadPresetsFromApi();
  }

  @override
  void onClose() {
    rotationNameController.dispose();
    super.onClose();
  }

  Future<void> fetchMyWorkRotation() async {
    try {
      isRotationLoading.value = true;
      final rotation = await _service.fetchMyWorkRotation();

      if (rotation == null) {
        // data is null => toggle OFF
        isEnabled.value = false;
        selectedTemplateKey.value = '';
        hasRotationData.value = false;
        rotationName.value = '';
        rotationNameController.text = '';
      } else {
        // has data => toggle ON & populate rotation data
        isEnabled.value = true;
        hasRotationData.value = true;
        rotationName.value = rotation.name ?? '';
        rotationNameController.text = rotation.name ?? '';
        weeks.value = rotation.cycleWeeks;
        selectedTemplateKey.value = rotation.sourceTemplateKey;
        if (rotation.startDate.isNotEmpty) {
          startDate.value =
              DateTime.tryParse(rotation.startDate) ?? DateTime.now();
        }
        shiftTimes.assignAll(rotation.shiftTimes);
        pattern.assignAll(rotation.pattern);
        overrides.assignAll(rotation.overrides);
        await fetchUpcomingSchedule();
      }
    } catch (e) {
      debugPrint('Error fetching my work rotation: $e');
    } finally {
      isRotationLoading.value = false;
    }
  }

  Future<void> fetchUpcomingSchedule({String? fromDate, int? daysCount}) async {
    try {
      isLoadingCalendar.value = true;
      final targetFrom = fromDate ?? _formatDate(calendarFromDate.value);
      final targetDays = daysCount ?? calendarDaysLimit.value;

      final calendar = await _service.fetchWorkRotationCalendar(
        from: targetFrom,
        days: targetDays,
      );
      if (calendar != null) {
        upcomingScheduleDays.assignAll(calendar.days);
      }
    } catch (e) {
      debugPrint('Error fetching upcoming schedule calendar: $e');
    } finally {
      isLoadingCalendar.value = false;
    }
  }

  Future<void> updateCalendarRange(
    DateTime newFromDate,
    int newDaysLimit,
  ) async {
    calendarFromDate.value = newFromDate;
    calendarDaysLimit.value = newDaysLimit;
    await fetchUpcomingSchedule(
      fromDate: _formatDate(newFromDate),
      daysCount: newDaysLimit,
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  Future<void> loadPresetsFromApi() async {
    try {
      isLoadingPresets.value = true;
      final res = await _service.fetchRotationPresetsData();
      if (res != null) {
        apiPresets.assignAll(res.presets);
        activeRotationKey.value = res.activeRotationKey ?? '';
        activeRotationName.value = res.activeRotationName ?? '';
        if (rotationName.value.isEmpty && (res.activeRotationName?.isNotEmpty ?? false)) {
          rotationName.value = res.activeRotationName!;
          rotationNameController.text = res.activeRotationName!;
        }
      }
    } catch (e) {
      debugPrint('Error loading rotation presets: $e');
    } finally {
      isLoadingPresets.value = false;
    }
  }

  Future<void> activateRotation(WorkRotationPresetModel preset) async {
    try {
      EasyLoading.show(status: 'Activating rotation...'.tr);
      final formattedDate = _formatDate(startDate.value);
      final success = await _service.applyRotationPreset(
        key: preset.key,
        startDate: formattedDate,
        name: preset.label,
      );

      if (success) {
        activeRotationKey.value = preset.key;
        activeRotationName.value = preset.label;
        selectedTemplateKey.value = preset.key;
        rotationName.value = preset.label;
        rotationNameController.text = preset.label;
        isCreatingNewRotation.value = false;

        // Apply preset details to editor
        applyPreset(preset);

        await fetchUpcomingSchedule();
        try {
          final workCtrl = Get.find<WorkController>();
          workCtrl.defaultRotation.value = preset.label;
          await loadCustomRotationSchedule(workCtrl);
        } catch (_) {}

        // Reload presets to update active indicators
        await loadPresetsFromApi();

        EasyLoading.showSuccess('Rotation activated!'.tr);
      } else {
        EasyLoading.showError('Failed to activate rotation'.tr);
      }
    } catch (e) {
      debugPrint('activateRotation error: $e');
      EasyLoading.showError('Failed to activate rotation'.tr);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> deleteCustomTemplate(WorkRotationPresetModel preset) async {
    if (!preset.isCustom || preset.id == null || preset.id!.isEmpty) return;
    try {
      EasyLoading.show(status: 'Deleting template...'.tr);
      final success = await _service.deleteWorkRotationTemplate(preset.id!);
      if (success) {
        await loadPresetsFromApi();
        EasyLoading.showSuccess('Template deleted'.tr);
      } else {
        EasyLoading.showError('Failed to delete template'.tr);
      }
    } catch (e) {
      debugPrint('deleteCustomTemplate error: $e');
      EasyLoading.showError('Failed to delete template'.tr);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void startNewRotation() {
    isCreatingNewRotation.value = true;
    rotationName.value = '';
    rotationNameController.text = '';
    weeks.value = 1;
    pattern.assignAll(List.generate(7, (_) => 'Off'));
    startDate.value = DateTime.now();
    shiftTimes.assignAll({
      'Day': {'start': '06:00', 'end': '14:00'},
      'Evening': {'start': '14:00', 'end': '22:00'},
      'Night': {'start': '22:00', 'end': '06:00'},
    });
  }

  void cancelNewRotation() {
    isCreatingNewRotation.value = false;
  }

  Future<void> saveCustomRotationTemplate() async {
    final name = rotationName.value.trim();
    if (name.isEmpty) {
      EasyLoading.showInfo('Please enter a rotation name'.tr);
      return;
    }

    try {
      EasyLoading.show(status: 'Saving template...'.tr);

      final success = await _service.saveWorkRotationTemplate(
        name: name,
        cycleWeeks: weeks.value,
        shiftTimes: shiftTimes,
        pattern: pattern,
      );

      if (success) {
        isCreatingNewRotation.value = false;
        rotationName.value = '';
        rotationNameController.text = '';
        await loadPresetsFromApi();
        EasyLoading.showSuccess('Rotation template saved!'.tr);
      } else {
        EasyLoading.showError('Failed to save template'.tr);
      }
    } catch (e) {
      debugPrint('Error saving custom rotation template: $e');
      EasyLoading.showError('Failed to save template'.tr);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> onToggleChanged(bool value, BuildContext context) async {
    isEnabled.value = value;
    if (value) {
      if (apiPresets.isEmpty && !isLoadingPresets.value) {
        loadPresetsFromApi();
      }
      fetchUpcomingSchedule();
    } else {
      try {
        EasyLoading.show(status: 'Disabling work rotation...'.tr);
        final success = await _service.deleteWorkRotation();
        if (success) {
          try {
            final workCtrl = Get.find<WorkController>();
            workCtrl.weeklyPattern.clear();
          } catch (_) {}
          hasRotationData.value = false;
          activeRotationKey.value = '';
          activeRotationName.value = '';
          rotationName.value = '';
          rotationNameController.text = '';
          upcomingScheduleDays.clear();
          EasyLoading.showSuccess('Work rotation disabled'.tr);
        } else {
          isEnabled.value = true;
          EasyLoading.showError('Failed to disable work rotation'.tr);
        }
      } catch (e) {
        isEnabled.value = true;
        EasyLoading.showError('Failed to disable work rotation'.tr);
      } finally {
        EasyLoading.dismiss();
      }
    }
  }

  void openTemplateSheet(BuildContext context) {
    if (apiPresets.isEmpty && !isLoadingPresets.value) {
      loadPresetsFromApi();
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TemplateSelectionSheet(controller: this),
    );
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
      fetchUpcomingSchedule();
      return;
    }
    pattern.assignAll(currentPattern);
    weeks.value = newWeeks;
    fetchUpcomingSchedule();
  }

  void updateDayPattern(int dayIndex, String shiftCode) {
    if (dayIndex >= 0 && dayIndex < pattern.length) {
      pattern[dayIndex] = shiftCode;
      fetchUpcomingSchedule();
    }
  }

  void applyPreset(WorkRotationPresetModel preset) {
    selectedTemplateKey.value = preset.key;
    weeks.value = preset.cycleWeeks;
    pattern.assignAll(preset.pattern);
    shiftTimes.assignAll(preset.shiftTimes);
    fetchUpcomingSchedule();
  }

  String formatShiftName(String key) {
    if (key.isEmpty) return '';
    final lower = key.toLowerCase();
    if (lower == 'day') return 'Day'.tr;
    if (lower == 'evening') return 'Evening'.tr;
    if (lower == 'night') return 'Night'.tr;
    if (lower == 'off') return 'Off'.tr;

    return key
        .split('_')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  String getShiftAbbreviation(String key) {
    final lower = key.toLowerCase();
    if (lower == 'day' || lower == 'd') return 'D';
    if (lower == 'evening' || lower == 'e') return 'E';
    if (lower == 'night' || lower == 'n') return 'N';
    if (lower == 'off') return 'Off';

    if (key.length <= 3) return key.toUpperCase();

    final numberMatch = RegExp(r'\d+').firstMatch(key);
    final numberStr = numberMatch != null ? numberMatch.group(0) : '';

    final parts = key.split(RegExp(r'[-_ ]+'));
    if (parts.length > 1) {
      final firstChar = parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '';
      final secondChar = parts[1].isNotEmpty ? parts[1][0].toUpperCase() : '';

      if (numberStr != null && numberStr.isNotEmpty) {
        return '$firstChar$numberStr';
      }
      return '$firstChar$secondChar';
    }

    if (numberStr != null && numberStr.isNotEmpty) {
      return '${key[0].toUpperCase()}$numberStr';
    }
    return key.substring(0, 3).toUpperCase();
  }

  void addCustomShift(String key, String start, String end) {
    final updated = Map<String, Map<String, String>>.from(shiftTimes);
    updated[key] = {'start': start, 'end': end};
    shiftTimes.assignAll(updated);
  }

  void renameCustomShift(String oldKey, String newKey) {
    if (oldKey == newKey) return;
    final updated = Map<String, Map<String, String>>.from(shiftTimes);
    if (!updated.containsKey(oldKey)) return;
    final val = updated.remove(oldKey);
    if (val != null) {
      updated[newKey] = val;
    }
    shiftTimes.assignAll(updated);

    final updatedPattern = List<String>.from(pattern);
    for (int i = 0; i < updatedPattern.length; i++) {
      if (updatedPattern[i] == oldKey) {
        updatedPattern[i] = newKey;
      }
    }
    pattern.assignAll(updatedPattern);

    final updatedOverrides = Map<String, String>.from(overrides);
    updatedOverrides.forEach((date, shift) {
      if (shift == oldKey) {
        updatedOverrides[date] = newKey;
      }
    });
    overrides.assignAll(updatedOverrides);

    fetchUpcomingSchedule();
  }

  void deleteCustomShift(String key) {
    final updated = Map<String, Map<String, String>>.from(shiftTimes);
    updated.remove(key);
    shiftTimes.assignAll(updated);

    final updatedPattern = List<String>.from(pattern);
    for (int i = 0; i < updatedPattern.length; i++) {
      if (updatedPattern[i] == key) {
        updatedPattern[i] = 'Off';
      }
    }
    pattern.assignAll(updatedPattern);

    final updatedOverrides = Map<String, String>.from(overrides);
    updatedOverrides.removeWhere((date, shift) => shift == key);
    overrides.assignAll(updatedOverrides);

    fetchUpcomingSchedule();
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

    final patternIndex = ((diffDays % cycleLength) + cycleLength) % cycleLength;
    if (patternIndex >= 0 && patternIndex < pattern.length) {
      return patternIndex;
    }
    return -1;
  }

  Future<void> applyDayOverride(DateTime date, String shiftCode) async {
    final dateStr = _formatDate(date);

    String apiShiftType;
    String? shiftStartTime;
    String? shiftEndTime;

    final lowerCode = shiftCode.toLowerCase();
    if (lowerCode == 'off') {
      apiShiftType = 'off';
      shiftStartTime = null;
      shiftEndTime = null;
    } else {
      final matchKey = shiftTimes.keys.firstWhere((k) {
        final lK = k.toLowerCase();
        return lK == lowerCode ||
            (lK == 'day' && lowerCode == 'd') ||
            (lK == 'evening' && lowerCode == 'e') ||
            (lK == 'night' && lowerCode == 'n');
      }, orElse: () => shiftCode);

      apiShiftType = matchKey.toLowerCase() == 'day'
          ? 'day'
          : matchKey.toLowerCase() == 'evening'
          ? 'evening'
          : matchKey.toLowerCase() == 'night'
          ? 'night'
          : matchKey;

      final times = shiftTimes[matchKey];
      shiftStartTime = times?['start'] ?? '00:00';
      shiftEndTime = times?['end'] ?? '00:00';
    }

    try {
      EasyLoading.show(status: 'Saving override...'.tr);

      final success = await _service.saveWorkRotationOverride(
        date: dateStr,
        shiftType: apiShiftType,
        shiftStartTime: shiftStartTime,
        shiftEndTime: shiftEndTime,
      );

      if (success) {
        overrides[dateStr] = shiftCode;
        editingDateStr.value = '';

        await fetchUpcomingSchedule();

        try {
          final workCtrl = Get.find<WorkController>();
          await loadCustomRotationSchedule(workCtrl);
        } catch (_) {}

        EasyLoading.showSuccess('Day override saved'.tr);
      } else {
        EasyLoading.showError('Failed to save day override'.tr);
      }
    } catch (e) {
      debugPrint('Error applying day override: $e');
      EasyLoading.showError('Failed to save day override'.tr);
    }
  }

  Future<void> revertDayOverride(DateTime date) async {
    final dateStr = _formatDate(date);
    try {
      EasyLoading.show(status: 'Clearing day override...'.tr);

      final success = await _service.deleteWorkRotationOverride(dateStr);

      if (success) {
        overrides.remove(dateStr);
        editingDateStr.value = '';

        await fetchUpcomingSchedule();

        try {
          final workCtrl = Get.find<WorkController>();
          await loadCustomRotationSchedule(workCtrl);
        } catch (_) {}

        EasyLoading.showSuccess('Day override cleared'.tr);
      } else {
        EasyLoading.showError('Failed to clear day override'.tr);
      }
    } catch (e) {
      debugPrint('Error deleting day override: $e');
      EasyLoading.showError('Failed to clear day override'.tr);
    }
  }

  Future<void> applyBatchOverrides(
    DateTime start,
    DateTime end,
    String shiftCode, {
    String? startTime,
    String? endTime,
  }) async {
    final startStr = _formatDate(start);
    final endStr = _formatDate(end);

    String apiShiftType;
    String? shiftStartTime;
    String? shiftEndTime;

    final lowerCode = shiftCode.toLowerCase();
    if (lowerCode == 'off') {
      apiShiftType = 'off';
      shiftStartTime = null;
      shiftEndTime = null;
    } else {
      final matchKey = shiftTimes.keys.firstWhere((k) {
        final lK = k.toLowerCase();
        return lK == lowerCode ||
            (lK == 'day' && lowerCode == 'd') ||
            (lK == 'evening' && lowerCode == 'e') ||
            (lK == 'night' && lowerCode == 'n');
      }, orElse: () => shiftCode);

      apiShiftType = matchKey.toLowerCase() == 'day'
          ? 'day'
          : matchKey.toLowerCase() == 'evening'
          ? 'evening'
          : matchKey.toLowerCase() == 'night'
          ? 'night'
          : matchKey;

      final times = shiftTimes[matchKey];
      shiftStartTime = startTime ?? times?['start'] ?? '00:00';
      shiftEndTime = endTime ?? times?['end'] ?? '00:00';
    }

    try {
      EasyLoading.show(status: 'Saving batch overrides...'.tr);

      final success = await _service.saveBatchWorkRotationOverrides(
        startDate: startStr,
        endDate: endStr,
        shiftType: apiShiftType,
        shiftStartTime: shiftStartTime,
        shiftEndTime: shiftEndTime,
      );

      if (success) {
        DateTime curr = DateTime(start.year, start.month, start.day);
        final cleanEnd = DateTime(end.year, end.month, end.day);
        while (!curr.isAfter(cleanEnd)) {
          overrides[_formatDate(curr)] = shiftCode;
          curr = curr.add(const Duration(days: 1));
        }

        await fetchUpcomingSchedule();

        try {
          final workCtrl = Get.find<WorkController>();
          await loadCustomRotationSchedule(workCtrl);
        } catch (_) {}

        EasyLoading.showSuccess('Batch overrides saved'.tr);
      } else {
        EasyLoading.showError('Failed to save batch overrides'.tr);
      }
    } catch (e) {
      debugPrint('Error applying batch overrides: $e');
      EasyLoading.showError('Failed to save batch overrides'.tr);
    }
  }

  Future<void> clearBatchOverrides(DateTime start, DateTime end) async {
    final startStr = _formatDate(start);
    final endStr = _formatDate(end);

    try {
      EasyLoading.show(status: 'Clearing overrides in range...'.tr);

      final success = await _service.deleteBatchWorkRotationOverrides(
        startDate: startStr,
        endDate: endStr,
      );

      if (success) {
        DateTime curr = DateTime(start.year, start.month, start.day);
        final cleanEnd = DateTime(end.year, end.month, end.day);
        while (!curr.isAfter(cleanEnd)) {
          overrides.remove(_formatDate(curr));
          curr = curr.add(const Duration(days: 1));
        }

        await fetchUpcomingSchedule();

        try {
          final workCtrl = Get.find<WorkController>();
          await loadCustomRotationSchedule(workCtrl);
        } catch (_) {}

        EasyLoading.showSuccess('Range overrides cleared'.tr);
      } else {
        EasyLoading.showError('Failed to clear range overrides'.tr);
      }
    } catch (e) {
      debugPrint('Error clearing batch overrides: $e');
      EasyLoading.showError('Failed to clear range overrides'.tr);
    }
  }

  String getBaseShiftForDate(DateTime date) {
    final startDateClean = DateTime(
      startDate.value.year,
      startDate.value.month,
      startDate.value.day,
    );
    final dateClean = DateTime(date.year, date.month, date.day);
    final diffDays = dateClean.difference(startDateClean).inDays;

    final cycleLength = 7 * weeks.value;
    if (cycleLength <= 0 || pattern.isEmpty) return 'Off';

    final patternIndex = ((diffDays % cycleLength) + cycleLength) % cycleLength;
    if (patternIndex < pattern.length) {
      return pattern[patternIndex];
    }
    return 'Off';
  }

  Future<void> saveSettings() async {
    try {
      EasyLoading.show(status: 'Saving work schedule...'.tr);

      if (!isEnabled.value) {
        final success = await _service.deleteWorkRotation();
        if (success) {
          try {
            final workCtrl = Get.find<WorkController>();
            workCtrl.weeklyPattern.clear();
          } catch (_) {}
          hasRotationData.value = false;
          EasyLoading.showSuccess('Work rotation deleted'.tr);
          Get.back();
        } else {
          EasyLoading.showError('Failed to delete work rotation'.tr);
        }
        return;
      }

      final success = await _service.saveWorkRotation(
        cycleWeeks: weeks.value,
        startDate: _formatDate(startDate.value),
        shiftTimes: shiftTimes,
        pattern: pattern,
        sourceTemplateKey: selectedTemplateKey.value.isNotEmpty
            ? selectedTemplateKey.value
            : null,
        name: rotationName.value.trim().isNotEmpty
            ? rotationName.value.trim()
            : null,
      );

      if (success) {
        try {
          final workCtrl = Get.find<WorkController>();
          await loadCustomRotationSchedule(workCtrl);
        } catch (_) {}
        hasRotationData.value = true;
        await loadPresetsFromApi();
        EasyLoading.showSuccess('Work schedule saved!'.tr);
        Get.back();
      } else {
        EasyLoading.showError('Failed to save work schedule'.tr);
      }
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
      final dateStr = _formatDate(date);

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

    final todayIndex = now.weekday - 1;
    final todayShift = computedPattern[todayIndex]['shift']!;
    final lowerToday = todayShift.toLowerCase();

    if (lowerToday == 'd' || lowerToday == 'day') {
      workCtrl.selectedShiftType.value = 'Day';
    } else if (lowerToday == 'e' || lowerToday == 'evening') {
      workCtrl.selectedShiftType.value = 'Evening';
    } else if (lowerToday == 'n' || lowerToday == 'night') {
      workCtrl.selectedShiftType.value = 'Night';
    } else if (lowerToday == 'off') {
      workCtrl.selectedShiftType.value = 'Off';
    } else {
      final matchKey = shiftTimes.keys.firstWhere(
        (k) => k.toLowerCase() == lowerToday,
        orElse: () => todayShift,
      );
      workCtrl.selectedShiftType.value = matchKey;
    }

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

    if (activeRotationName.value.isNotEmpty) {
      workCtrl.defaultRotation.value = activeRotationName.value;
    } else if (rotationName.value.isNotEmpty) {
      workCtrl.defaultRotation.value = rotationName.value;
    }
  }

  String getShiftForDate(DateTime date) {
    final dateStr = _formatDate(date);
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

    final patternIndex = ((diffDays % cycleLength) + cycleLength) % cycleLength;
    if (patternIndex < pattern.length) {
      return pattern[patternIndex];
    }
    return 'Off';
  }
}
