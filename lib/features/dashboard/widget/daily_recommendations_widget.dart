import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';

class DailyRecommendationsWidget extends StatelessWidget {
  final String imagePath;
  final String recommendationText;
  final String subText;
  const DailyRecommendationsWidget({
    super.key,
    required this.imagePath,
    required this.recommendationText,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(imagePath, height: 24, width: 24),
        SizedBox(height: 16),
        Text(
          recommendationText,
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          subText,
          style: getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryTextColor,
          ),
        ),
        SizedBox(height: 16),
        Divider(),
      ],
    );
  }
}
