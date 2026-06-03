import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/settings/legal_and_data/privacy_policy/widgets/build_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                  title: 'Privacy'.tr,
                  showBackButton: true,
                  showMoreButton: true,
                ),
                SizedBox(height: 28),
                Text(
                  'Privacy first by design'.tr,
                  style: getTextStyle2(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'RYVENZA should feel useful without exposing individual health-like habits to an employer.'
                      .tr,
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textMid,
                  ),
                ),
                SizedBox(height: 30),

                BuildCard(
                  title: 'Your inputs'.tr,
                  body:
                      'Profile basics, work rhythm, sleep target, caffeine, hydration, meals, activity and recovery logs you choose to enter.'
                          .tr,
                ),
                SizedBox(height: 16),
                BuildCard(
                  title: 'Why we use them'.tr,
                  body:
                      'To calculate timing recommendations, personalize reminders and improve the product experience.'
                          .tr,
                ),
                SizedBox(height: 16),
                BuildCard(
                  title: 'Employer view'.tr,
                  body:
                      'In a company pilot, employers see aggregated trends only. No individual profile, log, note or recommendation is shown.'
                          .tr,
                ),
                SizedBox(height: 16),
                BuildCard(
                  title: 'Your controls'.tr,
                  body:
                      'You can edit core inputs, disconnect sources, export data or request deletion from settings.'
                          .tr,
                ),

                SizedBox(height: 30),
                CustomButton(text: 'Accept privacy policy', onTap: Get.back),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
