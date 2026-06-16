import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
//import 'package:chrisimhof/features/auth/connected_sources/controller/connected_sources_controller.dart';
import 'package:chrisimhof/features/auth/connected_sources/widgets/source_card.dart';
import 'package:chrisimhof/features/nav_bar/screen/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectedSourcesScreen extends StatelessWidget {
  const ConnectedSourcesScreen({super.key});

  Future<void> _handleSaveSources() async {
      Get.offAll(() => const NavbarScreen());
  }

  @override
  Widget build(BuildContext context) {
    //final controller = Get.put(ConnectedSourcesController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
        child: SafeArea(
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
                'Connect your rhythm'.tr,
                style: getTextStyle2(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'RYVENZA works with manual inputs first. Optional sources can reduce friction later.'
                    .tr,
                style: getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 30),
              SourceCard(
                title: 'Manual logging'.tr,
                subtitle: 'Always available'.tr,
                iconPath: IconPath.lifestyle,
                iconBackgroundColor: AppColors.mintSoft2,
                iconColor: AppColors.secondaryButtonColor,
                badgeText: 'Enabled'.tr,
                badgeBackgroundColor: AppColors.mintSoft2,
                badgeTextColor: AppColors.secondaryButtonColor,
              ),
              const SizedBox(height: 16),
              SourceCard(
                title: 'Work schedule'.tr,
                subtitle: 'Editable day by day'.tr,
                iconPath: IconPath.lifestyle,
                iconBackgroundColor: AppColors.mintSoft2,
                iconColor: AppColors.secondaryButtonColor,
                badgeText: 'Enabled'.tr,
                badgeBackgroundColor: AppColors.mintSoft2,
                badgeTextColor: AppColors.secondaryButtonColor,
              ),
              const SizedBox(height: 16),
              SourceCard(
                title: 'Apple Health'.tr,
                subtitle: 'Coming later'.tr,
                iconPath: IconPath.privacy,
                iconBackgroundColor: AppColors.gray50,
                iconColor: AppColors.textSoft,
                badgeText: 'Not linked'.tr,
                badgeBackgroundColor: AppColors.gray100,
                badgeTextColor: AppColors.textMid,
              ),
              const SizedBox(height: 16),
              SourceCard(
                title: 'Google Health Connect'.tr,
                subtitle: 'Coming later'.tr,
                iconPath: IconPath.privacy,
                iconBackgroundColor: AppColors.gray50,
                iconColor: AppColors.textSoft,
                badgeText: 'Not linked'.tr,
                badgeBackgroundColor: AppColors.gray100,
                badgeTextColor: AppColors.textMid,
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Save sources'.tr,
                icon: null,
                onTap: _handleSaveSources,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
