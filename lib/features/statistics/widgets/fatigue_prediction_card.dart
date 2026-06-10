import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/statistics/controller/statistics_controller.dart';
import 'package:chrisimhof/features/statistics/widgets/fatigue_week_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FatiguePredictionCard extends StatelessWidget {
  const FatiguePredictionCard({super.key, required this.controller});

  final StatisticsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF2F3), // Soft pink/rose
            Color(0xFFFFFDF2), // Soft warm yellow
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt, color: AppColors.rose, size: 16),
              const SizedBox(width: 6.0),
              Text(
                'FATIGUE PREDICTION'.tr,
                style: getTextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.rose,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          RichText(
            text: TextSpan(
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
              children: [
                TextSpan(text: '${'Energy dip expected'.tr} '),
                TextSpan(
                  text: controller.fatigueExpectedTime.value,
                  style: const TextStyle(color: AppColors.rose),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          FatigueWeekChart(weeklyData: controller.fatigueWeeklyData),
        ],
      ),
    );
  }
}
