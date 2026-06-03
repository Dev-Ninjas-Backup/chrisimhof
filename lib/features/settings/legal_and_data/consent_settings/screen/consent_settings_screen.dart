import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/settings/legal_and_data/consent_settings/controller/consent_settings_controller.dart';
import 'package:chrisimhof/features/settings/legal_and_data/consent_settings/widgets/consent_toggle_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConsentSettingsScreen extends StatelessWidget {
  ConsentSettingsScreen({super.key});
  final ConsentSettingsController controller = ConsentSettingsController();

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
                  title: 'Consent settings'.tr,
                  showBackButton: true,
                  showMoreButton: true,
                ),
                const SizedBox(height: 28),
                Text(
                  'Consent settings'.tr,
                  style: getTextStyle2(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Choose what RYVENZA can use to personalise your rhythm. You can change this later.'
                      .tr,
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textMid,
                  ),
                ),
                const SizedBox(height: 30),
                Obx(
                  () => ConsentToggleItem(
                    iconPath: IconPath.lifestyle,
                    iconBackgroundColor: AppColors.mintSoft2,
                    title: 'Lifestyle recommendations'.tr,
                    subtitle:
                        'Use sleep, caffeine, hydration, meals, activity and work rhythm to calculate timing suggestions.'
                            .tr,
                    value: controller.lifestyleRecommendations.value,
                    onChanged: (v) =>
                        controller.lifestyleRecommendations.value = v,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => ConsentToggleItem(
                    iconPath: IconPath.reminder,
                    iconBackgroundColor: AppColors.indigoSoft2,
                    title: 'Reminders'.tr,
                    subtitle:
                        'Allow gentle nudges for hydration, caffeine cut-off, sleep window and recovery.'
                            .tr,
                    value: controller.reminders.value,
                    onChanged: (v) => controller.reminders.value = v,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => ConsentToggleItem(
                    iconPath: IconPath.connectedSource,
                    iconBackgroundColor: AppColors.indigoSoft4,
                    title: 'Connected sources'.tr,
                    subtitle:
                        'Use optional connected data only after you link a source yourself.'
                            .tr,
                    value: controller.connectedSources.value,
                    onChanged: (v) => controller.connectedSources.value = v,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => ConsentToggleItem(
                    iconPath: IconPath.lifestyle,
                    iconBackgroundColor: AppColors.mintSoft2,
                    title: 'Company pilot insights'.tr,
                    subtitle:
                        'Share aggregated and anonymised trends only. No individual logs are shown to an employer.'
                            .tr,
                    value: controller.companyPilotInsights.value,
                    onChanged: (v) => controller.companyPilotInsights.value = v,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => ConsentToggleItem(
                    iconPath: IconPath.usageAnalytics,
                    iconBackgroundColor: AppColors.subtle,
                    title: 'Usage analytics'.tr,
                    subtitle:
                        'Help improve RYVENZA with privacy-preserving usage analytics.'
                            .tr,
                    value: controller.usageAnalytics.value,
                    onChanged: (v) => controller.usageAnalytics.value = v,
                  ),
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Save consent settings'.tr,
                  onTap: controller.saveSettings,
                  width: double.infinity,
                  backgroundColor: AppColors.primaryButtonColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
