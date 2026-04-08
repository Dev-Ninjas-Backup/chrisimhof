import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/dashboard/widget/daily_recommendations_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyRecommendations extends StatelessWidget {
  const DailyRecommendations({super.key});

  @override
  Widget build(BuildContext context) {
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
            'Daily Recommendations',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
          SizedBox(height: 24),
          DailyRecommendationsWidget(
            imagePath: IconPath.iron,
            recommendationText: 'Recommendations of the day',
            subText:
                'A small nighttime meal: light, easy to digest, not too fatty, with easily digestible protein and simple/moderate carbohydrates. Not a large fast-food meal at 3 a.m.',
          ),
          DailyRecommendationsWidget(
            imagePath: IconPath.vector,
            recommendationText: 'Caffeine',
            subText:
                'Moderate caffeine intake. Try to stop around 7:32 PM to protect your sleep.',
          ),
          DailyRecommendationsWidget(
            imagePath: IconPath.sports,
            recommendationText: 'Sport',
            subText:
                'Moderate caffeine intake. Try to stop around 7:32 PM to protect your sleep.',
          ),
        ],
      ),
    );
  }
}
