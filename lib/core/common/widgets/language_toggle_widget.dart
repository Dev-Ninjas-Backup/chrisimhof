import 'package:chrisimhof/core/common/controller/language_controller.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageToggleWidget extends StatelessWidget {
  final dynamic controller;
  
  const LanguageToggleWidget({
    super.key,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Try to find CreateAccountController first, then fall back to LanguageController
    final dynamic activeController = controller ??
        (Get.isRegistered<LanguageController>()
            ? Get.find<LanguageController>()
            : (Get.isRegistered(tag: 'CreateAccountController')
                ? Get.find(tag: 'CreateAccountController')
                : null));

    // Try different tags for CreateAccountController
    dynamic finalController = activeController;
    if (finalController == null) {
      try {
        finalController = Get.find(tag: 'createAccount');
      } catch (e) {
        // If not found, try direct Get.find
        try {
          finalController = Get.find(tag: 'CreateAccountController');
        } catch (e2) {
          // Default to LanguageController
          finalController = Get.find<LanguageController>();
        }
      }
    }

    return SizedBox(
      width: 140,
      height: 32,
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => finalController.changeLanguage('EN'),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  height: 32,
                  decoration: BoxDecoration(
                    color: finalController.isSelected('EN')
                        ? AppColors.primaryButtonColor
                        : AppColors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                      bottomLeft: Radius.circular(100),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(IconPath.ukLogo, height: 24, width: 24),
                      const SizedBox(width: 4),
                      Text(
                        'En',
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: finalController.isSelected('EN')
                              ? AppColors.white
                              : AppColors.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => finalController.changeLanguage('FR'),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  height: 32,
                  decoration: BoxDecoration(
                    color: finalController.isSelected('FR')
                        ? AppColors.primaryButtonColor
                        : AppColors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(IconPath.freLogo, height: 24, width: 24),
                      const SizedBox(width: 4),
                      Text(
                        'Fre'.tr,
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: finalController.isSelected('FR')
                              ? AppColors.white
                              : AppColors.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
