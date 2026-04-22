import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/features/dashboard/widget/daily_recommendations_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyRecommendations extends StatelessWidget {
  const DailyRecommendations({super.key});

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'sleep':
        return IconPath.moon;
      case 'caffeine':
        return IconPath.vector;
      case 'nutrition':
        return IconPath.iron;
      case 'hydration':
        return IconPath.waterDrops;
      case 'activity':
      case 'sport':
        return IconPath.sports;
      case 'recovery':
        return IconPath.moon;
      default:
        return IconPath.iron;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Container(
      width: Get.width,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(right: 16, bottom: 100),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Recommendations'.tr,
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
          SizedBox(height: 24),
          Obx(() {
            if (controller.dailyRecommendations.isEmpty) {
              return Text(
                'No recommendations available'.tr,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                ),
              );
            }

            return Column(
              children: controller.dailyRecommendations
                  .map(
                    (rec) => DailyRecommendationsWidget(
                      imagePath: _getCategoryIcon(rec.category),
                      recommendationText: rec.title.tr,
                      subText: rec.body.tr,
                    ),
                  )
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}
