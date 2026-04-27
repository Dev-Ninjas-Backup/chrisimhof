import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/history_details/model/history_details_model.dart';
import 'package:chrisimhof/features/history_details/widgets/history_details_icon_badge.dart';
import 'package:flutter/material.dart';

class HistoryDetailsMetricCard extends StatelessWidget {
  final HistoryMetric metric;

  const HistoryDetailsMetricCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  metric.title,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryTextColor,
                  ),
                ),
              ),
              HistoryDetailsIconBadge(iconKey: metric.iconKey),
            ],
          ),
          const Spacer(),
          Text(
            '${metric.score}%',
            style: getTextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Score: ${metric.score}%',
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
