import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/work/controller/work_controller.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class EditPatternBottomSheet extends StatelessWidget {
  final WorkController controller;

  const EditPatternBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Obx(() {
        final rotations = controller.availableRotations;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select shift rotation pattern'.tr,
              style: getTextStyle2(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a preset pattern to update this week\'s schedule, or tap individual day bubbles directly on the screen to customize.'
                  .tr,
              style: getTextStyle(
                fontSize: 13,
                color: AppColors.textSoft,
              ),
            ),
            const SizedBox(height: 16),
            if (rotations.isNotEmpty) ...[
              ...rotations.map((item) {
                final label = item['label'] as String? ?? item['name'] as String? ?? '';
                final isCustom = item['isCustom'] == true;
                final isSelected = controller.defaultRotation.value == label ||
                    controller.rotationName.value == label;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Flexible(
                        child: Text(
                          label.tr,
                          style: getTextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCustom) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryButtonColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Custom'.tr,
                            style: getTextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondaryButtonColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.secondaryButtonColor)
                      : const SizedBox.shrink(),
                  onTap: () {
                    controller.selectAvailableRotation(item);
                    Get.back();
                    EasyLoading.showSuccess('${'Applied'.tr} $label ${'rotation!'.tr}');
                  },
                );
              }),
            ] else ...[
              ...['3-2-2 night', '2-2-3 schedule', '4-4 split', 'None (Fixed)'].map((option) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      option.tr,
                      style: getTextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    trailing: controller.defaultRotation.value == option
                        ? const Icon(Icons.check_circle, color: AppColors.secondaryButtonColor)
                        : const SizedBox.shrink(),
                    onTap: () {
                      controller.applyRotationPattern(option);
                      Get.back();
                      EasyLoading.showSuccess('${'Applied'.tr} ${option.tr} ${'rotation!'.tr}');
                    },
                  )),
            ],
            const Divider(height: 24),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.add_circle_outline_rounded,
                color: AppColors.secondaryButtonColor,
              ),
              title: Text(
                'Create custom rotation'.tr,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryButtonColor,
                ),
              ),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.workScheduleSettingsScreen);
              },
            ),
            const SizedBox(height: 12),
          ],
        );
      }),
    );
  }
}
