import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/time_widget.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:chrisimhof/features/calculator/widgets/calculator_live_score_section.dart';
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
        const CalculatorLiveScoreSection(sectionKey: 'work'),
        const SizedBox(height: 16),
        TimeWidget(
          topTitle: 'Work Begins'.tr,
          controller: controller.workBeginsController,
        ),
        const SizedBox(height: 16),
        TimeWidget(
          topTitle: 'Work Complete'.tr,
          controller: controller.workCompleteController,
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
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
        TabButton(
          text: 'I won\'t work today'.tr,
          onTap: () {
            controller.skipWorkData();
          },
        ),
        const SizedBox(height: 16),
        TabButton(
          text: 'Reset'.tr,
          onTap: () {
            controller.workBeginsController.reset();
            controller.workCompleteController.reset();
            controller.daysWorkedController.clear();
            controller.selectShiftType('STANDARD');
          },
        ),
        const SizedBox(height: 10),
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
