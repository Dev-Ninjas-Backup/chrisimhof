import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/statistics/controller/statistics_controller.dart';
import 'package:chrisimhof/features/statistics/widgets/metric_progress_row.dart';
import 'package:chrisimhof/features/statistics/widgets/statistics_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RhythmScoreCard extends StatelessWidget {
  const RhythmScoreCard({
    super.key,
    required this.controller,
  });

  final StatisticsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.authDarkAlt, // Dark forest green: #143226
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -71,
              top: -40,
              child: Container(
                width: 192,
                height: 192,
                decoration: BoxDecoration(
                  color: AppColors.primaryButtonColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(9999.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GlobalRhythmCircle(score: controller.globalScore.value),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: Text(
                          'GLOBAL RHYTHM SCORE'.tr,
                          style: getTextStyle2(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryButtonColor,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 28.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column
                      Expanded(
                        child: Column(
                          children: [
                            MetricProgressRow(
                              label: 'Sleep',
                              percentage: controller.sleepMetric.value,
                              barColor: AppColors.primaryButtonColor,
                            ),
                            const SizedBox(height: 14.0),
                            MetricProgressRow(
                              label: 'Caffeine',
                              percentage: controller.caffeineMetric.value,
                              barColor: AppColors.orangeAccent, // Orange
                            ),
                            const SizedBox(height: 14.0),
                            MetricProgressRow(
                              label: 'Sport',
                              percentage: controller.sportMetric.value,
                              barColor: AppColors.violet, // Purple
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24.0),
                      // Right Column
                      Expanded(
                        child: Column(
                          children: [
                            MetricProgressRow(
                              label: 'Hydration',
                              percentage: controller.hydrationMetric.value,
                              barColor: AppColors.blue,
                            ),
                            const SizedBox(height: 14.0),
                            MetricProgressRow(
                              label: 'Nutrition',
                              percentage: controller.nutritionMetric.value,
                              barColor: AppColors.rose,
                            ),
                            const SizedBox(height: 14.0),
                            MetricProgressRow(
                              label: 'Work fit',
                              percentage: controller.workFitMetric.value,
                              barColor: AppColors.primaryButtonColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
