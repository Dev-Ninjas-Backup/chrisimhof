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
  const ConsentSettingsScreen({super.key});

  String _getIconPath(String key) {
    switch (key) {
      case 'lifestyleRecommendations':
        return IconPath.lifestyle;
      case 'reminders':
        return IconPath.reminder;
      case 'connectedSources':
        return IconPath.connectedSource;
      case 'companyPilotInsights':
        return IconPath.lifestyle;
      case 'usageAnalytics':
        return IconPath.usageAnalytics;
      default:
        return IconPath.consent;
    }
  }

  Color _getIconBgColor(String key) {
    switch (key) {
      case 'lifestyleRecommendations':
        return AppColors.mintSoft2;
      case 'reminders':
        return AppColors.indigoSoft2;
      case 'connectedSources':
        return AppColors.indigoSoft4;
      case 'companyPilotInsights':
        return AppColors.mintSoft2;
      case 'usageAnalytics':
        return AppColors.subtle;
      default:
        return AppColors.subtle;
    }
  }

  RxBool? _getRxBool(ConsentSettingsController controller, String key) {
    switch (key) {
      case 'lifestyleRecommendations':
        return controller.lifestyleRecommendations;
      case 'reminders':
        return controller.reminders;
      case 'connectedSources':
        return controller.connectedSources;
      case 'companyPilotInsights':
        return controller.companyPilotInsights;
      case 'usageAnalytics':
        return controller.usageAnalytics;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConsentSettingsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Obx(() {
          // 1. LOADING STATE
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryButtonColor),
              ),
            );
          }

          // 2. ERROR/EMPTY STATE
          final data = controller.consentSettingsData.value;
          if (data == null) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load consent settings.'.tr,
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Retry'.tr,
                    onTap: controller.fetchConsentSettings,
                  ),
                ],
              ),
            );
          }

          // 3. SUCCESS STATE
          return SingleChildScrollView(
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
                    data.title.tr,
                    style: getTextStyle2(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data.subtitle.tr,
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMid,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: data.settings.map((setting) {
                      final rxVal = _getRxBool(controller, setting.key);
                      if (rxVal == null) return const SizedBox.shrink();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Obx(
                          () => ConsentToggleItem(
                            iconPath: _getIconPath(setting.key),
                            iconBackgroundColor: _getIconBgColor(setting.key),
                            title: setting.label.tr,
                            subtitle: setting.desc.tr,
                            value: rxVal.value,
                            onChanged: (v) => rxVal.value = v,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: data.cta.tr,
                    onTap: controller.saveSettings,
                    backgroundColor: AppColors.primaryButtonColor,
                    icon: null,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
