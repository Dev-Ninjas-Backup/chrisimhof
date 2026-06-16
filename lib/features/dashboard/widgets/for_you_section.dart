import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForYouSection extends StatelessWidget {
  const ForYouSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'FOR YOU',
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryTextColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to RecommendationsScreen
                Get.toNamed(AppRoutes.recomendationsScreen);
              },
              child: Row(
                children: [
                  Text(
                    'See all',
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryButtonColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_right_alt,
                    color: AppColors.secondaryButtonColor,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.borderSoft,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildRecommendationItem(
                iconPath: IconPath.homeScreenCaffeineIcon,
                iconColor: AppColors.amberDark,
                iconBgColor: AppColors.amberSoft,
                title: 'Caffeine cut-off at 16:30',
                description:
                    "You worked nights — stop early to protect tomorrow's recovery.",
              ),
              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: AppColors.borderSoft,
              ),
              _buildRecommendationItem(
                iconPath: IconPath.homeScreenWaterIcon,
                iconColor: AppColors.blue,
                iconBgColor: AppColors.indigoSoft2,
                title: 'Drink 600 ml before shift',
                description: 'Hydration is 28% behind target for today.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationItem({
    required String iconPath,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                width: 18,
                height: 18,
                color: iconColor,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.lightbulb_outline,
                  color: iconColor,
                  size: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: getTextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSoft,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
