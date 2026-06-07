import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/auth/safety/controller/safety_controller.dart';
import 'package:chrisimhof/features/auth/safety/widgets/safety_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SafetyController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              CustomAppBar(
                title: 'Safety'.tr,
                showBackButton: true,
                showMoreButton: true,
              ),
              const SizedBox(height: 28),
              Text(
                'Before you continue'.tr,
                style: getTextStyle2(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Confirm the key limits so recommendations stay in the right context.'
                    .tr,
                style: getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 30),
              Obx(
                () => Column(
                  children: [
                    SafetyCard(
                      text:
                          'RYVENZA is a lifestyle and wellbeing app, not a medical service.',
                      isChecked: controller.isLimit1Checked.value,
                      onTap: controller.toggleLimit1,
                    ),
                    const SizedBox(height: 16),
                    SafetyCard(
                      text:
                          'I will not use it for emergencies or safety-critical decisions.',
                      isChecked: controller.isLimit2Checked.value,
                      onTap: controller.toggleLimit2,
                    ),
                    const SizedBox(height: 16),
                    SafetyCard(
                      text:
                          'Professional medical advice and employer safety rules always come',
                      isChecked: controller.isLimit3Checked.value,
                      onTap: controller.toggleLimit3,
                    ),
                    const SizedBox(height: 16),
                    SafetyCard(
                      text:
                          'Recommendations depend on the information I choose to enter.',
                      isChecked: controller.isLimit4Checked.value,
                      onTap: controller.toggleLimit4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Obx(
                () => CustomButton(
                  text: 'Continue'.tr,
                  icon: null,
                  backgroundColor: controller.isAllChecked
                      ? AppColors.primaryButtonColor
                      : AppColors.primaryButtonColor.withAlpha(128),
                  onTap: controller.handleContinue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
