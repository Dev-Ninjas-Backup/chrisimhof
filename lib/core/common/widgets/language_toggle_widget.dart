import 'package:chrisimhof/core/common/controller/language_controller.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageToggleWidget extends StatelessWidget {
  const LanguageToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageController controller = Get.isRegistered<LanguageController>()
        ? Get.find<LanguageController>()
        : Get.put(LanguageController(), permanent: true);

    return SizedBox(
      width: 140,
      height: 32,
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => controller.changeLanguage('en'),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  height: 32,
                  decoration: BoxDecoration(
                    color: controller.isSelected('en')
                        ? AppColors.primaryButtonColor
                        : Colors.white,
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
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.changeLanguage('fr'),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  height: 32,
                  decoration: BoxDecoration(
                    color: controller.isSelected('fr')
                        ? AppColors.primaryButtonColor
                        : Colors.white,
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
                        'Fre',
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
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
