import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/settings/legal_and_data/widgets/build_menu_item.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LegalAndDataScreen extends StatelessWidget {
  const LegalAndDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  title: 'Legal & data'.tr,
                  showBackButton: true,
                  showMoreButton: true,
                ),
                SizedBox(height: 28),
                Text(
                  'Legal & data'.tr,
                  style: getTextStyle2(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Everything important in one place, written for a wellbeing product.'
                      .tr,
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textMid,
                  ),
                ),
                SizedBox(height: 30),
                BuildMenuItem(
                  iconPath: IconPath.health,
                  iconBackgroundColor: AppColors.roseSoft2,
                  title: 'Health & safety note'.tr,
                  subtitle: 'Lifestyle guidance, not medical care.'.tr,
                  onTap: () {
                    Get.toNamed(AppRoutes.healthAndSafetyScreen);
                  },
                ),
                SizedBox(height: 16),
                BuildMenuItem(
                  iconPath: IconPath.privacy,
                  iconBackgroundColor: AppColors.mint2,
                  title: 'Privacy policy'.tr,
                  subtitle: 'Personal data, employer view and retention.'.tr,
                  onTap: () {
                    Get.toNamed(AppRoutes.privacyPolicyScreen);
                  },
                ),
                SizedBox(height: 16),
                BuildMenuItem(
                  iconPath: IconPath.terms,
                  iconBackgroundColor: AppColors.indigoSoft2,
                  title: 'Terms of use'.tr,
                  subtitle: 'Responsible use and account rules.'.tr,
                  onTap: () {
                    Get.toNamed(AppRoutes.termsOfUseScreen);
                  },
                ),
                SizedBox(height: 16),
                BuildMenuItem(
                  iconPath: IconPath.consent,
                  iconBackgroundColor: AppColors.indigoSoft3,
                  title: 'Consent settings'.tr,
                  subtitle: 'Connected sources and permissions.'.tr,
                  onTap: () {
                    Get.toNamed(AppRoutes.consentSettingsScreen);
                  },
                ),
                SizedBox(height: 16),
                BuildMenuItem(
                  iconPath: IconPath.delete,
                  iconBackgroundColor: AppColors.roseSoft2,
                  title: 'Delete account'.tr,
                  subtitle: 'Export or remove your data.'.tr,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
