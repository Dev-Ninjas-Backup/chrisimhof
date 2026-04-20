import 'package:chrisimhof/core/common/controller/language_controller.dart';
import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
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
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 78),
        child: Obx(
          () => Column(
            children: [
              CustomAppBar(title: 'Choose Language'.tr, showBackButton: true),
              SizedBox(height: 24),
              LanguageButton(
                languageCode: 'en',
                label: 'English'.tr,
                iconPath: IconPath.ukLogo,
                isSelected: controller.isSelected('en'),
                onTap: () => controller.changeLanguage('en'),
              ),
              SizedBox(height: 16),
              LanguageButton(
                languageCode: 'fr',
                label: 'French'.tr,
                iconPath: IconPath.freLogo,
                isSelected: controller.isSelected('fr'),
                onTap: () => controller.changeLanguage('fr'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
