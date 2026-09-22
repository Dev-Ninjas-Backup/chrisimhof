import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/settings/main/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeFormatBottomSheet extends StatelessWidget {
  final SettingsController controller;

  const TimeFormatBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? MediaQuery.of(context).viewInsets.bottom + 20
            : MediaQuery.of(context).padding.bottom + 36,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gray200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Time format'.tr,
                style: getTextStyle2(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, color: AppColors.textSoft),
                splashRadius: 20,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Choose how times and recommendations are displayed across the app.'.tr,
            style: getTextStyle(
              fontSize: 13,
              color: AppColors.textSoft,
            ),
          ),
          const SizedBox(height: 20),

          // Options
          Obx(() {
            final current = controller.timeFormat.value;

            return Column(
              children: [
                _buildOptionTile(
                  context,
                  title: '24-Hour'.tr,
                  example: '21:30',
                  isSelected: current == '24h',
                  onTap: () async {
                    Navigator.of(context).pop();
                    await controller.updateTimeFormat('24h');
                  },
                ),
                const SizedBox(height: 10),
                _buildOptionTile(
                  context,
                  title: '12-Hour (AM/PM)'.tr,
                  example: '9:30 PM',
                  isSelected: current == '12h',
                  onTap: () async {
                    Navigator.of(context).pop();
                    await controller.updateTimeFormat('12h');
                  },
                ),
              ],
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required String title,
    required String example,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mintSoft3 : AppColors.gray50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.secondaryButtonColor
                : AppColors.borderSoft,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getTextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Example: @example'.trParams({'example': example}),
                    style: getTextStyle(
                      fontSize: 12,
                      color: AppColors.textSoft,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.secondaryButtonColor,
                size: 22,
              )
            else
              const Icon(
                Icons.radio_button_unchecked_rounded,
                color: AppColors.gray300,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
