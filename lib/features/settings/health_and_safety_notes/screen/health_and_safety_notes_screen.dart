import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/settings/legal_and_data/widgets/build_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HealthAndSafetyNotesScreen extends StatelessWidget {
  const HealthAndSafetyNotesScreen({super.key});

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
                  title: 'Safety'.tr,
                  showBackButton: true,
                  showMoreButton: true,
                ),
                SizedBox(height: 28),
                Text(
                  'Health & safety note'.tr,
                  style: getTextStyle2(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'RYVENZA gives lifestyle timing guidance. It is not medical care.'
                      .tr,
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textMid,
                  ),
                ),
                SizedBox(height: 30),

                // Top info card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.mintSoft2,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.mint, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GENERAL WELLBEING ONLY'.tr,
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mintSoftText,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Plan the when, not diagnose the why.'.tr,
                        style: getTextStyle2(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Sleep, caffeine, hydration, meals, activity and recovery suggestions are informative and based on the data you enter.'
                            .tr,
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.mintSoftText,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                BuildMenuItem(
                  iconPath: IconPath.medicalAdvice,
                  iconBackgroundColor: AppColors.roseSoft2,
                  title: 'Not medical advice'.tr,
                  subtitle:
                      'No diagnosis, treatment, prevention, cure or emergency'
                          .tr,
                  onTap: () {},
                ),
                SizedBox(height: 16),
                BuildMenuItem(
                  iconPath: IconPath.professional,
                  iconBackgroundColor: AppColors.orangeSoft,
                  title: 'Ask a professional'.tr,
                  subtitle:
                      'Use extra caution with medical conditions, medication,'
                          .tr,
                  onTap: () {},
                ),
                SizedBox(height: 16),
                BuildMenuItem(
                  iconPath: IconPath.safety,
                  iconBackgroundColor: AppColors.mintSoft2,
                  title: 'Safety comes first'.tr,
                  subtitle:
                      'Do not use RYVENZA to decide if you are fit to drive, work, operate'
                          .tr,
                  onTap: () {},
                ),

                SizedBox(height: 30),
                CustomButton(text: 'I understand'.tr, onTap: Get.back),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
