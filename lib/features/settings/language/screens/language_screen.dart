import 'package:chrisimhof/core/common/controller/language_controller.dart';
import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/settings/language/widget/language_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use find if the controller was already put by the toggle widget or main
    final controller = Get.find<LanguageController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(
                    title: 'Choose Language'.tr,
                    showBackButton: true,
                  ),
                  SizedBox(height: 28),
                  Text(
                    'Choose Language'.tr,
                    style: getTextStyle2(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'The app can support French and British English wording.'
                        .tr,
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMid,
                    ),
                  ),
                  SizedBox(height: 30),
                  LanguageButton(
                    languageCode: 'EN',
                    label: 'English',
                    subtitle: 'Current language',
                    iconPath: IconPath.ukLogo,
                    isSelected: controller.isSelected('EN'),
                    onTap: () => controller.selectedLanguage.value = 'EN',
                  ),
                  SizedBox(height: 16),
                  LanguageButton(
                    languageCode: 'FR',
                    label: 'Français',
                    subtitle: 'Available for the app',
                    iconPath: IconPath.freLogo,
                    isSelected: controller.isSelected('FR'),
                    onTap: () => controller.selectedLanguage.value = 'FR',
                  ),
                  SizedBox(height: 30),
                  CustomButton(
                    text: 'Save'.tr,
                    onTap: () => controller.changeLanguage(
                      controller.selectedLanguage.value,
                      force: true,
                    ),
                    icon: null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
