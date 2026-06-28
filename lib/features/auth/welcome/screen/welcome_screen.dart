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
      backgroundColor: AppColors.welcomeScreenBg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    width: 0.5,
                    color: const Color(0x669CAAA6),
                  ),
                ),
                child: CircadianAvatar(
                  imagePath: ImagePath.circadianAvatar,
                  avatarSize: 300,
                  orbitRadius: 100,
                  orbitCenterY: 55,
                ),
              ),
              SizedBox(height: 45),

              Image.asset(IconPath.welcomeLogo, width: 87.37, height: 37.8),
              Text(
                'RYVENZA',
                style: getTextStyle2(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Your rhythm, rebuilt around real life.'.tr,
                textAlign: TextAlign.center,
                style: getTextStyle2(
                  color: AppColors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Sleep, caffeine, hydration, meals and work shifts in one adaptive daily plan.'
                    .tr,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  color: AppColors.sage,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 40),

              CustomButton(
                text: 'Create account'.tr,
                onTap: () => Get.toNamed(AppRoutes.createAccountScreen),
              ),
              const SizedBox(height: 10),
              CustomButton(
                text: 'Log in'.tr,
                onTap: () => Get.toNamed(AppRoutes.signInScreen),
                borderWidth: 1,
                backgroundColor: AppColors.white,
                icon: null,
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
