import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/analytics/controller/analytics_controller.dart';
import 'package:chrisimhof/features/settings/subscriptions/screen/subscriptions_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryDetailsWeeklyAnalyticsCard extends StatelessWidget {
  const HistoryDetailsWeeklyAnalyticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure AnalyticsController is available
    if (!Get.isRegistered<AnalyticsController>()) {
      Get.put(AnalyticsController());
    }

    final controller = Get.find<AnalyticsController>();

    return Container(
      width: Get.width,
      height: 369,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildHeader(controller),
          const SizedBox(height: 16),
          Expanded(child: _buildChart(controller)),
        ],
      ),
    );
  }

  Widget _buildHeader(AnalyticsController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Circadian Analysis'.tr,
          style: getTextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
        ),
        _buildDropdown(controller),
      ],
    );
  }

  Widget _buildDropdown(AnalyticsController controller) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedPeriod.value,
            isDense: true,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: Color(0xFF0D1B2A),
            ),
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryTextColor,
            ),
            items: controller.periods.map((period) {
              return DropdownMenuItem<String>(
                value: period,
                child: Text(period.tr),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.changePeriod(value);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChart(AnalyticsController controller) {
    return Obx(() {
      final data = controller.analyticsData.value;
      if (data == null) return const SizedBox.shrink();

      if (data.circadianAnalysis == null) {
        return Center(
          child: GestureDetector(
            onTap: () {
              Get.to(const SubscriptionsScreen());
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 36, color: AppColors.primaryButtonColor),
                const SizedBox(height: 8),
                Text(
                  'Upgrade to Premium to unlock circadian performance analysis.',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextColor,
                  ).copyWith(decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
        );
      }

      final spots = controller.circadianSpots;
      //final labels = controller.circadianLabels;
      final maxX = controller.circadianMaxX;
      final latestSpot = spots.isNotEmpty ? spots.last : const FlSpot(0, 0);

      return LineChart(
        LineChartData(
          clipData: const FlClipData.all(),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 25,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryTextColor,
                    ),
                  );
                },
              ),
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
                interval: 1,
                // Increase reservedSize so labels have more room below the chart
                reservedSize: 70,
                getTitlesWidget: (value, meta) {
                  final hourInt = value.toInt();
                  // Show only even-numbered hours (00, 02, 04, ...)
                  if (hourInt % 4 == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        hourInt.toString().padLeft(2, '0'),
                        style: getTextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          minX: 0,
          maxX: maxX + 0.5,
          minY: -0.5,
          maxY: 100,
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => const Color(0xFF0D1B2A),
              tooltipBorderRadius: BorderRadius.circular(12),
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    'Score: ${spot.y.toInt()}%',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.4,
              preventCurveOverShooting: true,
              color: const Color(0xFF1DB97B),
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) {
                  if (spot.x == spots.last.x && spot.y == spots.last.y) {
                    return FlDotCirclePainter(
                      radius: 7,
                      color: const Color(0xFF1DB97B),
                      strokeWidth: 0,
                    );
                  }
                  return FlDotCirclePainter(
                    radius: 0,
                    color: Colors.transparent,
                    strokeWidth: 0,
                  );
                },
              ),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          showingTooltipIndicators: spots.isEmpty
              ? const []
              : [
                  ShowingTooltipIndicators([
                    LineBarSpot(
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        preventCurveOverShooting: true,
                        color: const Color(0xFF1DB97B),
                      ),
                      0,
                      latestSpot,
                    ),
                  ]),
                ],
        ),
      );
    });
  }
}
