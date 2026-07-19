import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/auth/connected_sources/controller/connected_sources_controller.dart';
import 'package:chrisimhof/features/auth/connected_sources/widgets/source_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectedSourcesScreen extends StatelessWidget {
  const ConnectedSourcesScreen({super.key});

  String _getIconPath(String key) {
    switch (key) {
      case 'manual':
        return IconPath.lifestyle;
      case 'work':
        return IconPath.work;
      case 'apple':
        return IconPath.apple;
      case 'google':
        return IconPath.google;
      default:
        return IconPath.privacy;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConnectedSourcesController>();

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
          final data = controller.sourcesData.value;
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
                    'Failed to load connected sources.'.tr,
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
                    onTap: controller.fetchConnectedSources,
                  ),
                ],
              ),
            );
          }

          // 3. SUCCESS STATE
          return SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  title: 'Connected sources'.tr,
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
                    color: AppColors.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  children: data.sources.map((src) {
                    final isApple = src.key == 'apple';
                    final isGoogle = src.key == 'google';
                    
                    // Determine connection status based on key and controller state
                    final bool isConnected;
                    if (isApple) {
                      isConnected = controller.isAppleHealthConnected.value;
                    } else if (isGoogle) {
                      isConnected = controller.isGoogleHealthConnected.value;
                    } else {
                      isConnected = src.status == 'enabled' || src.status == 'linked';
                    }

                    // Dynamically set layout styles
                    final String badgeText = isConnected ? 'Enabled'.tr : 'Not linked'.tr;
                    final Color badgeBgColor = isConnected ? AppColors.mintSoft2 : AppColors.gray100;
                    final Color badgeTextColor = isConnected ? AppColors.secondaryButtonColor : AppColors.textMid;
                    
                    final Color iconBgColor = isConnected ? AppColors.mintSoft2 : AppColors.gray50;
                    final Color iconColor = isConnected ? AppColors.secondaryButtonColor : AppColors.textSoft;

                    final VoidCallback? onTap;
                    if (isApple) {
                      onTap = controller.toggleAppleHealth;
                    } else if (isGoogle) {
                      onTap = controller.toggleGoogleHealthConnect;
                    } else {
                      onTap = null;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SourceCard(
                        title: src.label.tr,
                        subtitle: src.desc.tr,
                        iconPath: _getIconPath(src.key),
                        iconBackgroundColor: iconBgColor,
                        iconColor: iconColor,
                        badgeText: badgeText,
                        badgeBackgroundColor: badgeBgColor,
                        badgeTextColor: badgeTextColor,
                        onTap: onTap,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: data.cta.tr,
                  icon: null,
                  onTap: controller.handleSaveSources,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
