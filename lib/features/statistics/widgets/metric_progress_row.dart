import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:get/get.dart';

/// A linear progress indicator row with name and value
class MetricProgressRow extends StatelessWidget {
  final String label;
  final int percentage;
  final Color barColor;

  const MetricProgressRow({
    super.key,
    required this.label,
    required this.percentage,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label.tr,
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.white.withValues(alpha: 0.7),
              ),
            ),
            Text(
              '$percentage%',
              style: getTextStyle2(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: AppColors.darkGreenTrack, // Dark track inside dark card
            borderRadius: BorderRadius.circular(2.5),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (percentage / 100).clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

