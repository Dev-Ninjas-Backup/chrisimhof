import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/settings/legal_and_data/widgets/build_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataControlsScreen extends StatelessWidget {
  const DataControlsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
            child: Column(
              children: [
                CustomAppBar(
                  title: 'Data controls'.tr,
                  showBackButton: true,
                  showMoreButton: true,
                ),
                SizedBox(height: 28),
                Text(
                  'Your data controls'.tr,
                  style: getTextStyle2(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Keep the product useful while staying in control of what is connected.'
                      .tr,
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textMid,
                  ),
                ),
                SizedBox(height: 30),
                BuildMenuItem(
                  iconPath: IconPath.terms,
                  iconBackgroundColor: AppColors.mint2,
                  title: 'Export my data'.tr,
                  subtitle: 'Download profile inputs and logs.'.tr,
                  onTap: () {},
                  iconColor: AppColors.green,
                ),
                SizedBox(height: 16),
                BuildMenuItem(
                  iconPath: IconPath.lifestyle,
                  iconBackgroundColor: AppColors.indigoSoft2,
                  title: 'Connected sources'.tr,
                  subtitle:
                      'Manage Apple Health, Health Connect or manual inputs.'
                          .tr,
                  onTap: () {},
                  iconColor: AppColors.blue,
                ),
                SizedBox(height: 16),
                BuildMenuItem(
                  iconPath: IconPath.connectedSource,
                  iconBackgroundColor: AppColors.indigoSoft4,
                  title: 'Privacy preferences'.tr,
                  subtitle: 'Choose reminder and analytics settings.'.tr,
                  onTap: () {},
                ),
                SizedBox(height: 16),
                BuildMenuItem(
                  iconPath: IconPath.delete,
                  iconBackgroundColor: AppColors.roseSoft2,
                  title: 'Delete account'.tr,
                  subtitle: 'Request permanent deletion.'.tr,
                  onTap: () {
                    Get.toNamed('/deleteAccountScreen');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
