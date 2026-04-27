import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/history_details/model/history_details_model.dart';
import 'package:chrisimhof/features/history_details/widgets/history_details_icon_badge.dart';
import 'package:flutter/material.dart';

class HistoryDetailsRecommendationsCard extends StatelessWidget {
  final List<HistoryRecommendation> recommendations;

  const HistoryDetailsRecommendationsCard({
    super.key,
    required this.recommendations,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommendations of the day',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(recommendations.length, (index) {
            final recommendation = recommendations[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HistoryDetailsIconBadge(
                  iconKey: _mapCategoryToIconKey(recommendation.category),
                  size: 24,
                ),
                const SizedBox(height: 12),
                Text(
                  recommendation.title,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  recommendation.body,
                  style: getTextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextColor,
                  ),
                ),
                if (index < recommendations.length - 1) ...[
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFE5E7EB), height: 1),
                  const SizedBox(height: 16),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  String _mapCategoryToIconKey(String category) {
    switch (category.toLowerCase()) {
      case 'sleep':
        return 'sleep';
      case 'hydration':
        return 'hydration';
      case 'caffeine':
        return 'caffeine';
      case 'nutrition':
        return 'nutrition';
      case 'activity':
      case 'sport':
        return 'sport';
      default:
        return 'circle';
    }
  }
}
