import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/work/controller/work_controller.dart';
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select shift rotation pattern',
            style: getTextStyle2(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a preset pattern to update this week\'s schedule, or tap individual day bubbles directly on the screen to customize.',
            style: getTextStyle(
              fontSize: 13,
              color: AppColors.textSoft,
            ),
          ),
          const SizedBox(height: 16),
          ...['3-2-2 night', '2-2-3 schedule', '4-4 split', 'None (Fixed)'].map((option) => ListTile(
                title: Text(
                  option.tr,
                  style: getTextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                trailing: Obx(() => controller.defaultRotation.value == option
                    ? const Icon(Icons.check_circle, color: AppColors.secondaryButtonColor)
                    : const SizedBox.shrink()),
                onTap: () {
                  controller.applyRotationPattern(option);
                  Get.back();
                  EasyLoading.showSuccess('Applied $option rotation!');
                },
              )),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
