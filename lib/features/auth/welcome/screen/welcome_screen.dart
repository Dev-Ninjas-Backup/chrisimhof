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
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 532,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImagePath.welcomeImage),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: CircadianAvatar(
                        imagePath: ImagePath.circadianAvatar,
                        avatarSize: 280,
                        imageShiftFactor: 0.42,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 64,
                          left: 16,
                          bottom: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  IconPath.welcomeLogo,
                                  width: 87,
                                  height: 34,
                                ),
                                Text(
                                  'RYVENZA'.tr,
                                  style: getTextStyle2(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 280),
                            SizedBox(
                              width: context.width * 0.9,
                              child: Text(
                                'Your rhythm, rebuilt around real life.',
                                style: getTextStyle2(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 50),
                    Text(
                      'Sleep, caffeine, hydration, meals and work shifts in one adaptive daily plan.'
                          .tr,
                      style: getTextStyle(
                        color: const Color(0xFFB9C9C3),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 43),

                    CustomButton(
                      text: 'Create account'.tr,
                      onTap: () => Get.toNamed(AppRoutes.createAccountScreen),
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      text: 'Log in'.tr,
                      onTap: () => Get.toNamed(AppRoutes.signInScreen),
                      borderWidth: 1,
                      backgroundColor: Colors.white,
                      icon: null,
                    ),
                    const SizedBox(height: 35),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
