import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

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
                  title: 'Terms'.tr,
                  showBackButton: true,
                  showMoreButton: true,
                ),
                SizedBox(height: 28),
                Text(
                  'Responsible use'.tr,
                  style: getTextStyle2(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Short version of the terms, aligned with a non-medical wellbeing product.'
                      .tr,
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textMid,
                  ),
                ),
                SizedBox(height: 30),

                _buildCard(
                  title: '1. Lifestyle tool'.tr,
                  body:
                      'RYVENZA supports timing habits. It is not a medical, emergency or occupational safety service.'
                          .tr,
                ),
                SizedBox(height: 30),
                _buildCard(
                  title: '2. User responsibility'.tr,
                  body:
                      'You remain responsible for decisions, workplace rules and professional advice in your context.'
                          .tr,
                ),
                SizedBox(height: 30),
                _buildCard(
                  title: '3. Inputs and accuracy'.tr,
                  body:
                      'Recommendations depend on the quality and regularity of the information you provide.'
                          .tr,
                ),
                SizedBox(height: 30),
                _buildCard(
                  title: '4. Changes'.tr,
                  body:
                      'Features, plans and recommendations may evolve as the product improves.'
                          .tr,
                ),

                SizedBox(height: 30),
                CustomButton(
                  text: 'Accept terms'.tr,
                  onTap: Get.back,
                  icon: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required String body}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderSoft, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getTextStyle2(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            body,
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textMid,
            ),
          ),
        ],
      ),
    );
  }
}
