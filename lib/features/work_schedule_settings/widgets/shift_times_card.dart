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
            color: AppColors.black.withValues(alpha: 0.03),
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
              bgColor: AppColors.amberSoft3.withValues(alpha: 0.4),
              start: dayTimes['start']!,
              end: dayTimes['end']!,
              shiftName: 'Day',
              showDivider: true,
            ),
            _buildShiftTimeRow(
              context,
              title: 'Evening'.tr,
              icon: Icons.auto_awesome_rounded,
              iconPath: null,
              color: AppColors.violet,
              bgColor: AppColors.lavenderSoft,
              start: eveningTimes['start']!,
              end: eveningTimes['end']!,
              shiftName: 'Evening',
              showDivider: true,
            ),
            _buildShiftTimeRow(
              context,
              title: 'Night'.tr,
              icon: null,
              iconPath: IconPath.sleep,
              color: AppColors.indigo,
              bgColor: AppColors.indigoSoft,
              start: nightTimes['start']!,
              end: nightTimes['end']!,
              shiftName: 'Night',
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
    required Color bgColor,
    required String start,
    required String end,
    required String shiftName,
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: iconPath != null
                ? Image.asset(iconPath, color: color, width: 18, height: 18)
                : Icon(icon, color: color, size: 18),
          ),
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
          // Time badge matching Image 2 design
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _pickTime(context, shiftName, 'start'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderSoft),
                  ),
                  child: Text(
                    start,
                    style: getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Text(
                  '–',
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSoft,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _pickTime(context, shiftName, 'end'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderSoft),
                  ),
                  child: Text(
                    end,
                    style: getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ),
              ),
            ],
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
