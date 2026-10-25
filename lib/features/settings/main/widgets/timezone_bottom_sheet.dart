import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/settings/main/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';

class TimezoneBottomSheet extends StatelessWidget {
  final SettingsController controller;

  const TimezoneBottomSheet({super.key, required this.controller});

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
                'Time zone'.tr,
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
          const SizedBox(height: 8),

          Text(
            'Your circadian rhythm, sleep and work schedules adapt automatically to this time zone.'
                .tr,
            style: getTextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textSoft,
            ),
          ),
          const SizedBox(height: 20),

          // Current timezone display card
          Obx(() {
            final tz = controller.userTimezone.value.isNotEmpty
                ? controller.userTimezone.value
                : 'UTC';

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.subtle,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryButtonColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryButtonColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.public_rounded,
                      color: AppColors.primaryButtonColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Configured time zone'.tr,
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSoft,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tz,
                          style: getTextStyle2(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primaryButtonColor,
                    size: 22,
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 20),

          // Action button to re-sync with device time zone
          CustomButton(
            text: 'Sync with device time zone',
            plusIcon: true,
            showIcon: Icons.sync_rounded,
            icon: null,
            backgroundColor: AppColors.primaryTextColor,
            textColor: AppColors.white,
            iconColor: AppColors.white,
            onTap: () async {
              try {
                final tzInfo = await FlutterTimezone.getLocalTimezone();
                final localTz = tzInfo.identifier;
                await controller.updateTimezone(localTz);
                Get.back();
                Get.snackbar(
                  'Time zone'.tr,
                  '${'Time zone updated to'.tr} $localTz',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.white,
                  colorText: AppColors.primaryTextColor,
                  margin: const EdgeInsets.all(16),
                );
              } catch (e) {
                Get.back();
              }
            },
          ),
        ],
      ),
    );
  }
}
