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
              final items = _buildActivityItems(controller);
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

  List<_ActivityItem> _buildActivityItems(AnalyticsController controller) {
    final spots = controller.currentSpots;

    double safeY(int index) {
      if (index >= spots.length) return 10;
      return spots[index].y <= 0 ? 10 : spots[index].y;
    }

    final rawValues = [safeY(0), safeY(1), safeY(2), safeY(3), safeY(4)];

    final total = rawValues.fold<double>(0, (sum, value) => sum + value);

    final percentages = rawValues
        .map((value) => total == 0 ? 0.0 : (value / total) * 100)
        .toList();

    return [
      _ActivityItem(
        title: 'Sleep',
        color: const Color(0xFF006E4A),
        percent: percentages[0],
      ),
      _ActivityItem(
        title: 'Work',
        color: const Color(0xFF111827),
        percent: percentages[1],
      ),
      _ActivityItem(
        title: 'Exercise',
        color: const Color(0xFF34D399),
        percent: percentages[2],
      ),
      _ActivityItem(
        title: 'Meals',
        color: const Color(0xFFD5D7DA),
        percent: percentages[3],
      ),
      _ActivityItem(
        title: 'Free Time',
        color: const Color(0xFF535862),
        percent: percentages[4],
      ),
    ];
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

class _ActivityItem {
  final String title;
  final Color color;
  final double percent;

  const _ActivityItem({
    required this.title,
    required this.color,
    required this.percent,
  });

  String get percentLabel => '${percent.round()}%';
}
