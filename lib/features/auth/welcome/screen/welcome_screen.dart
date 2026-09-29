import 'package:chrisimhof/core/common/widgets/circadian_avatar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/core/const/image_path.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: AppColors.borderColor, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const CircadianAvatar(
                  imagePath: ImagePath.circadianAvatar,
                  avatarSize: 280,
                  orbitRadius: 95,
                  orbitCenterY: 55,
                  isLightMode: true,
                ),
              ),
              const SizedBox(height: 28),

              Image.asset(IconPath.welcomeLogo, width: 68, height: 32),
              const SizedBox(height: 8),
              Text(
                'RYVENZA',
                style: getTextStyle2(
                  color: AppColors.addButtonColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ).copyWith(letterSpacing: 2.2),
              ),
              const SizedBox(height: 16),
              Text(
                'Your rhythm, rebuilt around real life.'.tr,
                textAlign: TextAlign.center,
                style: getTextStyle2(
                  color: AppColors.primaryTextColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Sleep, caffeine, hydration, meals and work shifts in one adaptive daily plan.'
                    .tr,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  color: AppColors.textSoft,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              CustomButton(
                text: 'Create account'.tr,
                backgroundColor: AppColors.addButtonColor,
                textColor: AppColors.white,
                onTap: () => Get.toNamed(AppRoutes.createAccountScreen),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Log in'.tr,
                onTap: () => Get.toNamed(AppRoutes.signInScreen),
                borderWidth: 1,
                borderColor: AppColors.borderColor,
                backgroundColor: AppColors.white,
                textColor: AppColors.primaryTextColor,
                icon: null,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
