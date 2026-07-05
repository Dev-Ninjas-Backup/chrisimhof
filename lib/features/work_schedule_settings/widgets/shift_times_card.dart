import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/work_schedule_settings/controller/work_schedule_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShiftTimesCard extends StatelessWidget {
  final WorkScheduleSettingsController controller;

  const ShiftTimesCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSoft),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Obx(() {
        final dayTimes =
            controller.shiftTimes['Day'] ?? {'start': '06:00', 'end': '14:00'};
        final eveningTimes =
            controller.shiftTimes['Evening'] ??
            {'start': '14:00', 'end': '22:00'};
        final nightTimes =
            controller.shiftTimes['Night'] ??
            {'start': '22:00', 'end': '06:00'};

        return Column(
          children: [
            _buildShiftTimeRow(
              context,
              title: 'Day'.tr,
              icon: Icons.wb_sunny_rounded,
              iconPath: null,
              color: AppColors.amber,
              start: dayTimes['start']!,
              end: dayTimes['end']!,
              onTapStart: () => _pickTime(context, 'Day', 'start'),
              onTapEnd: () => _pickTime(context, 'Day', 'end'),
              showDivider: true,
            ),
            _buildShiftTimeRow(
              context,
              title: 'Evening'.tr,
              icon: Icons.auto_awesome_rounded,
              iconPath: null,
              color: AppColors.violet,
              start: eveningTimes['start']!,
              end: eveningTimes['end']!,
              onTapStart: () => _pickTime(context, 'Evening', 'start'),
              onTapEnd: () => _pickTime(context, 'Evening', 'end'),
              showDivider: true,
            ),
            _buildShiftTimeRow(
              context,
              title: 'Night'.tr,
              icon: null,
              iconPath: IconPath.sleep,
              color: AppColors.indigo,
              start: nightTimes['start']!,
              end: nightTimes['end']!,
              onTapStart: () => _pickTime(context, 'Night', 'start'),
              onTapEnd: () => _pickTime(context, 'Night', 'end'),
              showDivider: false,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildShiftTimeRow(
    BuildContext context, {
    required String title,
    required IconData? icon,
    required String? iconPath,
    required Color color,
    required String start,
    required String end,
    required VoidCallback onTapStart,
    required VoidCallback onTapEnd,
    required bool showDivider,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.borderSoft))
            : null,
      ),
      child: Row(
        children: [
          if (iconPath != null)
            Image.asset(iconPath, color: color, width: 20, height: 20),
          if (iconPath == null && icon != null)
            Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: getTextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onTapStart,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderSoft),
              ),
              child: Text(
                start,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'to'.tr,
              style: getTextStyle(fontSize: 12, color: AppColors.textSoft),
            ),
          ),
          GestureDetector(
            onTap: onTapEnd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderSoft),
              ),
              child: Text(
                end,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    String shift,
    String type,
  ) async {
    final currentStr = controller.shiftTimes[shift]?[type] ?? '00:00';
    final parts = currentStr.split(':');
    final initialHour = parts.length == 2 ? (int.tryParse(parts[0]) ?? 0) : 0;
    final initialMinute = parts.length == 2 ? (int.tryParse(parts[1]) ?? 0) : 0;

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.secondaryButtonColor,
              onPrimary: AppColors.white,
              onSurface: AppColors.primaryTextColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final hourStr = picked.hour.toString().padLeft(2, '0');
      final minuteStr = picked.minute.toString().padLeft(2, '0');

      final updatedTimes = Map<String, Map<String, String>>.from(
        controller.shiftTimes,
      );
      updatedTimes[shift]![type] = '$hourStr:$minuteStr';
      controller.shiftTimes.assignAll(updatedTimes);
    }
  }
}
