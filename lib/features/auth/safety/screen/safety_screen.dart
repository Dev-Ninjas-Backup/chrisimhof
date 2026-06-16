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
    // Instantiate/Find the SafetyController using GetX
    final controller = Get.put(SafetyController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Obx(() {
          // 1. LOADING STATE
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryButtonColor),
              ),
            );
          }

          // 2. ERROR/EMPTY STATE
          final data = controller.safetyData.value;
          if (data == null) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load safety requirements.'.tr,
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Retry'.tr,
                    onTap: controller.fetchSafetyData,
                  ),
                ],
              ),
            );
          }

          // 3. SUCCESS STATE (Dynamic content rendering)
          return SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
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
                  data.title.tr,
                  style: getTextStyle2(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  data.subtitle.tr,
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  children: data.items.map((item) {
                    final isChecked = controller.isItemChecked(item.index);
                    // Append '*' or similar suffix if required
                    final String displayLabel = item.required 
                        ? '${item.text} *' 
                        : item.text;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SafetyCard(
                        text: displayLabel,
                        isChecked: isChecked,
                        onTap: () => controller.toggleItem(item.index),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: data.cta.tr,
                  icon: null,
                  backgroundColor: controller.canProceed
                      ? AppColors.primaryButtonColor
                      : AppColors.primaryButtonColor.withValues(alpha: 0.5),
                  onTap: controller.handleContinue,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
