import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/analytics/controller/analytics_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WellnessScoreCard extends StatelessWidget {
  const WellnessScoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AnalyticsController>();

    return Container(
      width: Get.width,
      height: 384,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wellness Score',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Weekly balance overview',
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final values = _buildWellnessValues(controller);

              return RadarChart(
                RadarChartData(
                  radarBackgroundColor: Colors.transparent,
                  borderData: FlBorderData(show: false),
                  radarBorderData: const BorderSide(
                    color: Color(0xFFC9CDD3),
                    width: 2,
                  ),
                  tickBorderData: const BorderSide(
                    color: Color(0xFFC9CDD3),
                    width: 2,
                  ),
                  gridBorderData: const BorderSide(
                    color: Color(0xFFC9CDD3),
                    width: 2,
                  ),
                  titleTextStyle: getTextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF4B5563),
                  ),
                  ticksTextStyle: getTextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w400,
                    color: Colors.transparent,
                  ),
                  tickCount: 5,
                  radarShape: RadarShape.polygon,
                  dataSets: [
                    RadarDataSet(
                      fillColor: AppColors.primaryButtonColor.withValues(
                        alpha: 0.28,
                      ),
                      borderColor: AppColors.primaryButtonColor,
                      entryRadius: 5,
                      borderWidth: 3,
                      dataEntries: values
                          .map((value) => RadarEntry(value: value))
                          .toList(),
                    ),
                  ],
                  getTitle: (index, angle) {
                    const titles = [
                      'Sleep',
                      'Hydration',
                      'Caffein',
                      'Exercise',
                      'Recovery',
                      'Nutrition',
                    ];

                    return RadarChartTitle(text: titles[index], angle: angle);
                  },
                ),
                // ignore: deprecated_member_use
                swapAnimationDuration: const Duration(milliseconds: 350),
                // ignore: deprecated_member_use
                swapAnimationCurve: Curves.easeInOut,
              );
            }),
          ),
        ],
      ),
    );
  }

  List<double> _buildWellnessValues(AnalyticsController controller) {
    final spots = controller.currentSpots;

    double safeValue(int index) {
      if (index >= spots.length) return 3.0;
      final value = spots[index].y / 10;
      return value.clamp(1.5, 5.0);
    }

    return [
      safeValue(0), // Sleep
      safeValue(1), // Hydration
      safeValue(2), // Caffein
      safeValue(3), // Exercise
      safeValue(4), // Recovery
      safeValue(5), // Nutrition
    ];
  }
}
