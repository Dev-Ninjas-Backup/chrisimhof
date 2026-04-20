import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/analytics/controller/analytics_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyActivitySplitCard extends StatelessWidget {
  const DailyActivitySplitCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AnalyticsController>();

    return Container(
      width: Get.width,
      height: 290,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Activity Split',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Average time allocation',
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Obx(() {
              final items = controller.activityItems;
              return Row(
                children: [
                  Expanded(
                    flex: 11,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                            startDegreeOffset: 110,
                            sectionsSpace: 10,
                            centerSpaceRadius: 72,
                            borderData: FlBorderData(show: false),
                            pieTouchData: PieTouchData(enabled: false),
                            sections: items.map((item) {
                              return PieChartSectionData(
                                value: item.percent,
                                color: item.color,
                                radius: 25,
                                showTitle: false,

                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 0,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: items.map((item) {
                        return _LegendItem(
                          color: item.color,
                          percent: item.percentLabel,
                          title: item.title,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String percent;
  final String title;

  const _LegendItem({
    required this.color,
    required this.percent,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$percent ',
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
              TextSpan(
                text: title,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
