import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/analytics/controller/analytics_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeeklyAnalyticsCard extends StatelessWidget {
  const WeeklyAnalyticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AnalyticsController());

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
          'Weekly Analytics',
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
                child: Text(period),
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
      final spots = controller.currentSpots;

      return LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
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
                interval: 1,
                reservedSize: 28,
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
          minX: 0,
          maxX: 6,
          minY: 0,
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
                    'Highest: ${spot.y.toInt()}%',
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
          showingTooltipIndicators: [
            ShowingTooltipIndicators([
              LineBarSpot(
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: const Color(0xFF1DB97B),
                ),
                0,
                spots.last,
              ),
            ]),
          ],
        ),
      );
    });
  }
}
