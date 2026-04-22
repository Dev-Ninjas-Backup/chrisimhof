import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_text_form_field.dart';
import 'package:chrisimhof/core/common/widgets/selectble_tab_button.dart';
import 'package:chrisimhof/core/common/widgets/time_widget.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class CalculatorWorkTab extends StatelessWidget {
  const CalculatorWorkTab({super.key});

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.find<CalculatorController>();

    return Column(
      children: [
        TimeWidget(
          topTitle: 'Work Begins'.tr,
          controller: controller.workBeginsController,
        ),
        const SizedBox(height: 16),
        TimeWidget(
          topTitle: 'Work Complete'.tr,
          controller: controller.workCompleteController,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          label: "Days Worked".tr,
          hintText: "Enter Duration".tr,
          isRequired: true,
          controller: controller.daysWorkedController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Shift Type".tr,
              style: getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Obx(
                    () => SelectableTabButton(
                      text: 'Night'.tr,
                      isSelected: controller.selectedShiftType.value == 'Night',
                      onTap: () => controller.selectShiftType('Night'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Obx(
                    () => SelectableTabButton(
                      text: 'Rotating'.tr,
                      isSelected:
                          controller.selectedShiftType.value == 'Rotating',
                      onTap: () => controller.selectShiftType('Rotating'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Obx(
                    () => SelectableTabButton(
                      text: 'Early Morning'.tr,
                      isSelected:
                          controller.selectedShiftType.value == 'Early_Morning',
                      onTap: () => controller.selectShiftType('Early_Morning'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Obx(
                    () => SelectableTabButton(
                      text: 'Split'.tr,
                      isSelected: controller.selectedShiftType.value == 'Split',
                      onTap: () => controller.selectShiftType('Split'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Obx(
                    () => SelectableTabButton(
                      text: 'Standard'.tr,
                      isSelected:
                          controller.selectedShiftType.value == 'Standard',
                      onTap: () => controller.selectShiftType('Standard'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 150),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Obx(
            () => CustomButton(
              text: controller.isWorkSubmitting.value
                  ? 'Submitting...'.tr
                  : 'Next'.tr,
              onTap: controller.isWorkSubmitting.value
                  ? null
                  : () {
                      controller.submitWorkData();
                    },
              width: double.infinity,
            ),
          ),
        ),
        Obx(() {
          final errorMessage = controller.workSubmitError.value;

          if (errorMessage.isEmpty) {
            return const SizedBox.shrink();
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            EasyLoading.showError(errorMessage);
            if (controller.workSubmitError.value == errorMessage) {
              controller.workSubmitError.value = '';
            }
          });

          return const SizedBox.shrink();
        }),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TabButton(
                text: 'Skip'.tr,
                onTap: () {
                  controller.skipWorkData();
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TabButton(text: 'Reset'.tr, onTap: () {}),
            ),
          ],
        ),
      ],
    );
  }
}

class TabButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const TabButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10000),
        ),
        child: Text(
          text.tr,
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
        ),
      ),
    );
  }
}
