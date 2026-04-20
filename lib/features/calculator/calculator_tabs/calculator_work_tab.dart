import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_text_form_field.dart';
import 'package:chrisimhof/core/common/widgets/selectble_tab_button.dart';
import 'package:chrisimhof/core/common/widgets/time_widget.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculatorWorkTab extends StatelessWidget {
  const CalculatorWorkTab({super.key});

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.find<CalculatorController>();

    return Column(
      children: [
        TimeWidget(
          topTitle: 'Work Begins',
          controller: controller.workBeginsController,
        ),
        const SizedBox(height: 16),
        TimeWidget(
          topTitle: 'Work Complete',
          controller: controller.workCompleteController,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          label: "Days Worked",
          hintText: "Enter Duration",
          isRequired: true,
          controller: controller.daysWorkedController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Shift Type",
              style: getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => SelectableTabButton(
                      text: 'Night',
                      isSelected: controller.selectedShiftType.value == 'Night',
                      onTap: () => controller.selectShiftType('Night'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => SelectableTabButton(
                      text: 'Day',
                      isSelected: controller.selectedShiftType.value == 'Day',
                      onTap: () => controller.selectShiftType('Day'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 150),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: CustomButton(text: 'Next', onTap: () {}),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TabButton(text: 'Skip', onTap: () {}),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TabButton(text: 'Reset', onTap: () {}),
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
          text,
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


