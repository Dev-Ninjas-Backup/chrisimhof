import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/service/helper/timezone_helper.dart';
import 'package:chrisimhof/features/sports/controller/sports_controller.dart';
import 'package:chrisimhof/features/sports/widgets/zone_selection_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSportSessionBottomsheet extends StatelessWidget {
  final SportsController controller;
  final SportSession? sessionToEdit;

  const AddSportSessionBottomsheet({
    super.key,
    required this.controller,
    this.sessionToEdit,
  });

  static Future<void> show(
    BuildContext context, {
    required SportsController controller,
    SportSession? sessionToEdit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddSportSessionBottomsheet(
        controller: controller,
        sessionToEdit: sessionToEdit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initial values
    int initialDuration = 45;
    String initialZone = 'Z3';
    String initialType = 'cardio';
    String initialIntensity = 'medium';
    DateTime initialDate = DateTime.now();
    TimeOfDay initialStartTime = TimeOfDay.now();
    TimeOfDay initialEndTime = TimeOfDay(
      hour: (initialStartTime.hour + (initialStartTime.minute + 45) ~/ 60) % 24,
      minute: (initialStartTime.minute + 45) % 60,
    );

    if (sessionToEdit != null) {
      final s = sessionToEdit!;
      final titleLower = s.title.toLowerCase();
      if (titleLower.contains('strength') ||
          titleLower.contains('force') ||
          titleLower.contains('renforcement') ||
          titleLower.contains('musculation')) {
        initialType = 'strength';
      } else if (titleLower.contains('mobility') ||
          titleLower.contains('mobilité') ||
          titleLower.contains('yoga') ||
          titleLower.contains('stretch') ||
          titleLower.contains('walk')) {
        initialType = 'mobility';
      } else if (titleLower.contains('mixed') || titleLower.contains('mixte')) {
        initialType = 'mixed';
      } else if (!titleLower.contains('cardio') &&
          !titleLower.contains('run') &&
          !titleLower.contains('course') &&
          !titleLower.contains('cycl') &&
          !titleLower.contains('vélo') &&
          !titleLower.contains('swim') &&
          !titleLower.contains('natation')) {
        initialType = 'other';
      }

      final subUpper = s.subtitle.toUpperCase();
      if (subUpper.contains('Z1')) initialZone = 'Z1';
      else if (subUpper.contains('Z2')) initialZone = 'Z2';
      else if (subUpper.contains('Z3')) initialZone = 'Z3';
      else if (subUpper.contains('Z4')) initialZone = 'Z4';
      else if (subUpper.contains('Z5')) initialZone = 'Z5';

      final match = RegExp(r'(\d+)\s*m').firstMatch(s.subtitle);
      if (match != null) {
        initialDuration = int.tryParse(match.group(1) ?? '45') ?? 45;
      }

      if (s.occurredAt != null && s.occurredAt!.isNotEmpty) {
        try {
          initialDate = TimezoneHelper.parseSessionUtcToLocal(s.occurredAt!);
          initialStartTime = TimeOfDay(hour: initialDate.hour, minute: initialDate.minute);
          final totalMins = initialStartTime.hour * 60 + initialStartTime.minute + initialDuration;
          initialEndTime = TimeOfDay(hour: (totalMins ~/ 60) % 24, minute: totalMins % 60);
        } catch (_) {}
      }
    }

    final duration = initialDuration.obs;
    final zone = initialZone.obs;
    final selectedType = initialType.obs;
    final selectedIntensity = initialIntensity.obs;
    final selectedDate = initialDate.obs;
    final startTime = initialStartTime.obs;
    final endTime = initialEndTime.obs;

    void updateEndTimeFromDuration() {
      final totalMins = startTime.value.hour * 60 + startTime.value.minute + duration.value;
      endTime.value = TimeOfDay(hour: (totalMins ~/ 60) % 24, minute: totalMins % 60);
    }

    void updateDurationFromTimes() {
      int startMins = startTime.value.hour * 60 + startTime.value.minute;
      int endMins = endTime.value.hour * 60 + endTime.value.minute;
      int diff = endMins - startMins;
      if (diff <= 0) diff += 24 * 60;
      duration.value = diff;
    }

    final isEditMode = sessionToEdit != null;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? MediaQuery.of(context).viewInsets.bottom + 20
            : MediaQuery.of(context).padding.bottom + 36,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Drag Handle
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header: Dumbbell Icon + Tag + Title + Close Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.fitness_center_rounded,
                      size: 22,
                      color: Color(0xFF6D28D9),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'SPORT',
                        style: getTextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSoft,
                        ).copyWith(letterSpacing: 0.8),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isEditMode ? 'Edit session'.tr : 'New session'.tr,
                        style: getTextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.gray100Alt2,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Section 1: DURÉE / DURATION
            Text(
              'DURATION'.tr,
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textSoft,
              ).copyWith(letterSpacing: 0.6),
            ),
            const SizedBox(height: 10),

            // Large Duration display + Zone chip
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDFBFF),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderColor, width: 1.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Duration number (tap to edit)
                    GestureDetector(
                      onTap: () => _showDurationInputDialog(context, duration, updateEndTimeFromDuration),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${duration.value}',
                            style: getTextStyle2(
                              fontSize: 38,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'min',
                            style: getTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSoft,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Zone Chip (e.g. Z3)
                    GestureDetector(
                      onTap: () => Get.bottomSheet(ZoneSelectionBottomsheet(zone: zone)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFDDD6FE)),
                        ),
                        child: Text(
                          zone.value,
                          style: getTextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF6D28D9),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),

            // Section 2: Type d'activité (Keep all 5: cardio, strength, mobility, mixed, other)
            Text(
              'Activity type'.tr,
              style: getTextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),

            Obx(() {
              final currentType = selectedType.value;
              final activityTypes = [
                {'key': 'cardio', 'label': 'Cardio'.tr, 'icon': Icons.monitor_heart_outlined},
                {'key': 'strength', 'label': 'Strength'.tr, 'icon': Icons.fitness_center_rounded},
                {'key': 'mobility', 'label': 'Mobility'.tr, 'icon': Icons.self_improvement_rounded},
                {'key': 'mixed', 'label': 'Mixed'.tr, 'icon': Icons.shuffle_rounded},
                {'key': 'other', 'label': 'Other'.tr, 'icon': Icons.more_horiz_rounded},
              ];

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: activityTypes.map((act) {
                    final key = act['key'] as String;
                    final label = act['label'] as String;
                    final icon = act['icon'] as IconData;
                    final isSelected = currentType == key;

                    return GestureDetector(
                      onTap: () => selectedType.value = key,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFAF5FF) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF6D28D9) : AppColors.borderColor,
                            width: isSelected ? 1.6 : 1.2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icon,
                              size: 18,
                              color: isSelected ? const Color(0xFF6D28D9) : AppColors.primaryTextColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              label,
                              style: getTextStyle(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? const Color(0xFF6D28D9) : AppColors.primaryTextColor,
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 8),
                              Container(
                                width: 18,
                                height: 18,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF6D28D9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
            const SizedBox(height: 22),

            // Section 3: Intensité / Intensity (Faible / Moyenne / Élevée)
            Text(
              'Intensity'.tr,
              style: getTextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),

            Obx(() {
              final currentIntensity = selectedIntensity.value;
              final intensities = [
                {'key': 'low', 'label': 'Low'.tr},
                {'key': 'medium', 'label': 'Medium'.tr},
                {'key': 'high', 'label': 'High'.tr},
              ];

              return Row(
                children: intensities.map((item) {
                  final key = item['key']!;
                  final label = item['label']!;
                  final isSelected = currentIntensity == key;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => selectedIntensity.value = key,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF5B21B6) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF5B21B6) : AppColors.borderColor,
                            width: 1.2,
                          ),
                        ),
                        child: Text(
                          label,
                          style: getTextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected ? Colors.white : AppColors.primaryTextColor,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 22),

            // Section 4: Jour / Day (Hier / Aujourd'hui / Demain / 📅)
            Text(
              'Day'.tr,
              style: getTextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),

            Obx(() {
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final yesterday = today.subtract(const Duration(days: 1));
              final tomorrow = today.add(const Duration(days: 1));

              bool isSameDay(DateTime a, DateTime b) =>
                  a.year == b.year && a.month == b.month && a.day == b.day;

              final current = selectedDate.value;
              final isYesterday = isSameDay(current, yesterday);
              final isToday = isSameDay(current, today);
              final isTomorrow = isSameDay(current, tomorrow);
              final isCustom = !isYesterday && !isToday && !isTomorrow;

              return Row(
                children: [
                  _buildDayPill(
                    label: 'Yesterday'.tr,
                    isSelected: isYesterday,
                    onTap: () => selectedDate.value = yesterday,
                  ),
                  const SizedBox(width: 8),
                  _buildDayPill(
                    label: 'Today'.tr,
                    isSelected: isToday,
                    onTap: () => selectedDate.value = today,
                  ),
                  const SizedBox(width: 8),
                  _buildDayPill(
                    label: 'Tomorrow'.tr,
                    isSelected: isTomorrow,
                    onTap: () => selectedDate.value = tomorrow,
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate.value,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF5B21B6),
                                onPrimary: Colors.white,
                                onSurface: AppColors.primaryTextColor,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) selectedDate.value = picked;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: isCustom ? const Color(0xFF5B21B6) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isCustom ? const Color(0xFF5B21B6) : AppColors.borderColor,
                          width: 1.2,
                        ),
                      ),
                      child: Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: isCustom ? Colors.white : AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 22),

            // Section 5: Début -> Fin Time Pickers
            Obx(
              () => Row(
                children: [
                  // Début
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: startTime.value,
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF5B21B6),
                                  onPrimary: Colors.white,
                                  onSurface: AppColors.primaryTextColor,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          startTime.value = picked;
                          updateEndTimeFromDuration();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderColor, width: 1.2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start'.tr,
                              style: getTextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSoft,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.access_time_rounded, size: 16, color: AppColors.textSoft),
                                const SizedBox(width: 8),
                                Text(
                                  '${startTime.value.hour.toString().padLeft(2, '0')}:${startTime.value.minute.toString().padLeft(2, '0')}',
                                  style: getTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Center arrow
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                      color: Color(0xFF6D28D9),
                    ),
                  ),

                  // Fin
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: endTime.value,
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF5B21B6),
                                  onPrimary: Colors.white,
                                  onSurface: AppColors.primaryTextColor,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          endTime.value = picked;
                          updateDurationFromTimes();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderColor, width: 1.2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End'.tr,
                              style: getTextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSoft,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.access_time_rounded, size: 16, color: AppColors.textSoft),
                                const SizedBox(width: 8),
                                Text(
                                  '${endTime.value.hour.toString().padLeft(2, '0')}:${endTime.value.minute.toString().padLeft(2, '0')}',
                                  style: getTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Action Buttons: [ Annuler ]  [ Enregistrer ]
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderColor, width: 1.2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Cancel'.tr,
                        style: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      final d = selectedDate.value;
                      final st = startTime.value;
                      final et = endTime.value;
                      final startFormatted =
                          '${st.hour.toString().padLeft(2, '0')}:${st.minute.toString().padLeft(2, '0')}';
                      final endFormatted =
                          '${et.hour.toString().padLeft(2, '0')}:${et.minute.toString().padLeft(2, '0')}';
                      final fullDateTime = DateTime(d.year, d.month, d.day, st.hour, st.minute);

                      Navigator.of(context).pop();

                      String displayTitle;
                      final t = selectedType.value;
                      if (t == 'cardio') {
                        displayTitle = 'Cardio';
                      } else if (t == 'strength') {
                        displayTitle = 'Strength';
                      } else if (t == 'mobility') {
                        displayTitle = 'Mobility';
                      } else if (t == 'mixed') {
                        displayTitle = 'Mixed';
                      } else {
                        displayTitle = 'Other';
                      }

                      if (isEditMode) {
                        controller.editWorkoutLog(
                          sessionToEdit!.id,
                          durationMinutes: duration.value,
                          intensity: selectedIntensity.value,
                          sportType: t,
                          heartRateZone: zone.value,
                          occurredAt: fullDateTime,
                        );
                      } else {
                        controller.addSession(
                          activity: displayTitle,
                          duration: duration.value,
                          zone: zone.value,
                          startTime: startFormatted,
                          endTime: endFormatted,
                          effort: selectedIntensity.value[0].toUpperCase() + selectedIntensity.value.substring(1),
                          type: t,
                          selectedDate: d,
                        );
                      }
                    },
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5B21B6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Save'.tr,
                        style: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Delete action when editing
            if (isEditMode && sessionToEdit!.id.isNotEmpty) ...[
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.deleteWorkoutLog(sessionToEdit!.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.delete_outline_rounded,
                          color: Color(0xFFDC2626),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Delete workout session'.tr,
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ] else ...[
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDayPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF5B21B6) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? const Color(0xFF5B21B6) : AppColors.borderColor,
              width: 1.2,
            ),
          ),
          child: Text(
            label,
            style: getTextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.primaryTextColor,
            ),
          ),
        ),
      ),
    );
  }

  void _showDurationInputDialog(
    BuildContext context,
    RxInt duration,
    VoidCallback onUpdated,
  ) {
    final textCtrl = TextEditingController(text: '${duration.value}');
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'DURÉE'.tr,
          style: getTextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
          ),
        ),
        content: TextField(
          controller: textCtrl,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            suffixText: 'min',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'.tr),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B21B6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              final val = int.tryParse(textCtrl.text.trim());
              if (val != null && val > 0) {
                duration.value = val;
                onUpdated();
              }
              Get.back();
            },
            child: Text('Save'.tr, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

