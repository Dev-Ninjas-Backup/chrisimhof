import 'package:chrisimhof/core/common/widgets/build_menu_item.dart';
import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chrisimhof/features/auth/baseline_setup/widgets/sleep_taret_bottomsheet.dart';
import 'package:chrisimhof/features/auth/baseline_setup/widgets/chronotype_bottomsheet.dart';
import 'package:chrisimhof/features/auth/baseline_setup/widgets/caffeine_sensitivity_bottomsheet.dart';
import 'package:chrisimhof/features/auth/baseline_setup/widgets/sport_profile_bottomsheet.dart';
import 'package:chrisimhof/features/auth/baseline_setup/controller/baseline_setup_controller.dart';

class BaselineSetupScreen extends StatelessWidget {
  const BaselineSetupScreen({super.key});

  String _getSportProfileSubtitle(String enumValue) {
    switch (enumValue) {
      case 'sedentary':
        return 'Little to no exercise';
      case 'light':
        return '1-2x per week';
      case 'cardio':
        return '3-4x per week';
      case 'strength':
        return '5-6x per week';
      case 'mixed':
        return 'Mixed training';
      case 'endurance':
        return 'Intense training daily';
      default:
        return '3-4x per week';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BaselineSetupController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: 'Setup'.tr,
                showBackButton: true,
                showMoreButton: true,
              ),
              const SizedBox(height: 28),
              Text(
                'Build your baseline'.tr,
                style: getTextStyle2(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Stable profile inputs only. Water is calculated automatically, and work rhythm stays editable day by day.'
                    .tr,
                style: getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 30),
              Obx(
                () => BuildMenuItem(
                  iconPath: IconPath.sleep,
                  iconBackgroundColor: AppColors.subtle,
                  iconColor: AppColors.secondaryButtonColor,
                  title: 'Sleep target'.tr,
                  subtitle: controller.sleepTargetDisplay.value.tr,
                  borderRadius: 20,
                  containerWidth: 36,
                  containerHeight: 36,
                  iconSize: 18,
                  onTap: () {
                    Get.bottomSheet(
                      const SleepTaretBottomsheet(),
                      isScrollControlled: true,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => BuildMenuItem(
                  iconPath: IconPath.chronotype,
                  iconBackgroundColor: AppColors.subtle,
                  iconColor: AppColors.secondaryButtonColor,
                  title: 'Chronotype'.tr,
                  subtitle: controller
                      .getChronotypeDisplay(controller.chronotype.value)
                      .tr,
                  borderRadius: 20,
                  containerWidth: 36,
                  containerHeight: 36,
                  iconSize: 18,
                  onTap: () {
                    Get.bottomSheet(
                      const ChronotypeBottomsheet(),
                      isScrollControlled: true,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => BuildMenuItem(
                  iconPath: IconPath.caffeine_sensitivity,
                  iconBackgroundColor: AppColors.subtle,
                  iconColor: AppColors.secondaryButtonColor,
                  title: 'Caffeine sensitivity'.tr,
                  subtitle: controller
                      .getCaffeineDisplay(controller.caffeineSensitivity.value)
                      .tr,
                  borderRadius: 20,
                  containerWidth: 36,
                  containerHeight: 36,
                  iconSize: 18,
                  onTap: () {
                    Get.bottomSheet(
                      const CaffeineSensitivityBottomsheet(),
                      isScrollControlled: true,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => BuildMenuItem(
                  iconPath: IconPath.sport_profile,
                  iconBackgroundColor: AppColors.subtle,
                  iconColor: AppColors.secondaryButtonColor,
                  title: 'Sport profile'.tr,
                  subtitle: _getSportProfileSubtitle(
                    controller.sportProfile.value,
                  ).tr,
                  borderRadius: 20,
                  containerWidth: 36,
                  containerHeight: 36,
                  iconSize: 18,
                  onTap: () {
                    Get.bottomSheet(
                      const SportProfileBottomsheet(),
                      isScrollControlled: true,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryButtonColor.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Auto: '.tr,
                        style: getTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryButtonColor,
                        ),
                      ),
                      TextSpan(
                        text:
                            'hydration goal adapts from activity sleep debt and the current day. Work schedule is edited from its own page whenever shifts change.'
                                .tr,
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Continue setup'.tr,
                icon: null,
                onTap: controller.saveBaselineData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
