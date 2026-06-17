import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/work/controller/work_controller.dart';
import 'package:chrisimhof/features/dashboard/work/widgets/work_settings_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsTilesCard extends StatelessWidget {
  final WorkController controller;

  const SettingsTilesCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderSoft),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          WorkSettingsRow(
            icon: Icons.sync_alt_rounded,
            iconBg: AppColors.subtle,
            label: 'Default rotation',
            value: controller.defaultRotation,
            onTap: () => _showOptionsDialog(
              title: 'Default rotation',
              options: ['3-2-2 night', '2-2-3 schedule', '4-4 split', 'None (Fixed)'],
              selectedVal: controller.defaultRotation,
            ),
            showDivider: true,
          ),
          WorkSettingsRow(
            icon: Icons.alarm_rounded,
            iconBg: AppColors.subtle,
            label: 'Shift reminders',
            value: controller.shiftReminders,
            onTap: () => _showOptionsDialog(
              title: 'Shift reminders',
              options: ['On · 30 min before', 'On · 1 hour before', 'On · 2 hours before', 'Off'],
              selectedVal: controller.shiftReminders,
            ),
            showDivider: true,
          ),
          WorkSettingsRow(
            icon: Icons.public_rounded,
            iconBg: AppColors.subtle,
            label: 'Time zone',
            value: controller.timeZone,
            onTap: () => _showOptionsDialog(
              title: 'Time zone',
              options: ['CET · Geneva', 'EST · New York', 'GMT · London', 'AEST · Sydney'],
              selectedVal: controller.timeZone,
            ),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  // Small helper to show interactive selection dialogs for mock settings
  void _showOptionsDialog({
    required String title,
    required List<String> options,
    required RxString selectedVal,
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: getTextStyle2(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            ...options.map((option) => ListTile(
                  title: Text(
                    option,
                    style: getTextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  trailing: Obx(() => selectedVal.value == option
                      ? const Icon(Icons.check_circle, color: AppColors.secondaryButtonColor)
                      : const SizedBox.shrink()),
                  onTap: () {
                    if (title == 'Default rotation') {
                      controller.applyRotationPattern(option);
                    } else {
                      selectedVal.value = option;
                    }
                    Get.back();
                  },
                )),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
