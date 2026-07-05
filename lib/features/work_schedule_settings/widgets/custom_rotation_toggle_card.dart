import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/settings/legal_and_data/consent_settings/widgets/custom_switch.dart';
import 'package:chrisimhof/features/work_schedule_settings/controller/work_schedule_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomRotationToggleCard extends StatelessWidget {
  final WorkScheduleSettingsController controller;

  const CustomRotationToggleCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.mintSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.sync_alt_rounded,
              color: AppColors.secondaryButtonColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Custom rotation'.tr,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                Text(
                  'Auto-fill shifts based on your pattern'.tr,
                  style: getTextStyle(fontSize: 12, color: AppColors.textSoft),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Obx(
            () => CustomSwitch(
              value: controller.isEnabled.value,
              onChanged: (val) => controller.isEnabled.value = val,
            ),
          ),
        ],
      ),
    );
  }
}
