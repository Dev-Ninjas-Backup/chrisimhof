import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/analytics/controller/analytics_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SleepTrendCard extends StatelessWidget {
  const SleepTrendCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AnalyticsController>();

    return Container(
      width: Get.width,
      height: 326,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Trend',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hours per night vs goal',
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final spots = controller.currentSpots;
              return BarChart(
                BarChartData(
                  minY: 0,
                  maxY: 10,
                  alignment: BarChartAlignment.spaceBetween,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    enabled: true,
                    handleBuiltInTouches: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBorderRadius: BorderRadius.circular(100),
                      getTooltipColor: (_) => const Color(0xFF0B1736),
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      tooltipMargin: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final day = controller.days[group.x.toInt()];
                        return BarTooltipItem(
                          '$day-Sleep(h): ${rod.toY.toInt()}',
                          getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 34,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= controller.days.length) {
                            return const SizedBox.shrink();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              controller.days[index],
                              style: getTextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondaryTextColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(spots.length, (index) {
                    final spot = spots[index];

                    return BarChartGroupData(
                      x: index,
                      barsSpace: 0,
                      barRods: [
                        BarChartRodData(
                          toY: spot.y / 10,
                          width: 28,
                          color: const Color(0xFF1DB97B),
                          borderRadius: BorderRadius.circular(24),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: false,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
