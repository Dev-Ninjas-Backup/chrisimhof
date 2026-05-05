// ignore_for_file: unused_import

import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/history_details/controller/history_details_controller.dart';
import 'package:chrisimhof/features/history_details/model/history_details_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HistoryDetailsWeeklyAnalyticsCard extends StatelessWidget {
  // final List<WeeklyScore> weeklyScores;
  //
  // const HistoryDetailsWeeklyAnalyticsCard({
  //   super.key,
  //   required this.weeklyScores,
  // });

  const HistoryDetailsWeeklyAnalyticsCard({
    super.key,
    // required this.weeklyScores,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
    // return Container(
    //   width: Get.width,
    //   height: 369,
    //   padding: const EdgeInsets.all(16),
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.circular(24),
    //   ),
    //   child: Column(
    //     children: [
    //       _buildHeader(),
    //       const SizedBox(height: 16),
    //       Expanded(child: _buildChart()),
    //     ],
    //   ),
    // );
  }

  // Widget _buildHeader() {
  //   final HistoryDetailsController controller = Get.find<HistoryDetailsController>();
  //
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(
  //         'Weekly Analytics',
  //         style: getTextStyle(
  //           fontSize: 18,
  //           fontWeight: FontWeight.w600,
  //           color: AppColors.primaryTextColor,
  //         ),
  //       ),
  //       Obx(() => Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 3),
  //         decoration: BoxDecoration(
  //           color: const Color(0xFFF3F4F6), // Light grey background from screenshot
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         child: DropdownButtonHideUnderline(
  //           child: DropdownButton<String>(
  //             value: controller.selectedPeriod.value,
  //             icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF1F2937)),
  //             elevation: 8,
  //             style: getTextStyle(
  //               fontSize: 12,
  //               fontWeight: FontWeight.w500,
  //               color: const Color(0xFF1F2937),
  //             ),
  //             onChanged: (String? value) => controller.updateSelectedPeriod(value),
  //             items: controller.analyticPeriodOptions.map<DropdownMenuItem<String>>((String value) {
  //               return DropdownMenuItem<String>(
  //                 value: value,
  //                 child: Text(value),
  //               );
  //             }).toList(),
  //           ),
  //         ),
  //       )),
  //     ],
  //   );
  // }
  //
  // Widget _buildChart() {
  //   final labels = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  //   final spots = weeklyScores
  //       .map((score) => FlSpot(score.dayIndex.toDouble(), score.score))
  //       .toList()
  //     ..sort((a, b) => a.x.compareTo(b.x));
  //
  //   final latestSpot = spots.isNotEmpty ? spots.last : const FlSpot(0, 0);
  //
  //   return LineChart(
  //     LineChartData(
  //       gridData: const FlGridData(show: false),
  //       borderData: FlBorderData(show: false),
  //       titlesData: FlTitlesData(
  //         leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //         topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //         rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //         bottomTitles: AxisTitles(
  //           sideTitles: SideTitles(
  //             showTitles: true,
  //             interval: 1,
  //             reservedSize: 28,
  //             getTitlesWidget: (value, meta) {
  //               final index = value.toInt();
  //               if (index < 0 || index >= labels.length) return const SizedBox.shrink();
  //               return Padding(
  //                 padding: const EdgeInsets.only(top: 8),
  //                 child: Text(
  //                   labels[index],
  //                   style: getTextStyle(
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w400,
  //                     color: AppColors.secondaryTextColor,
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ),
  //       minX: 0,
  //       maxX: 6,
  //       minY: 0,
  //       maxY: 100,
  //       lineTouchData: LineTouchData(
  //         enabled: true,
  //         touchTooltipData: LineTouchTooltipData(
  //           getTooltipColor: (_) => const Color(0xFF0D1B2A),
  //           tooltipBorderRadius: BorderRadius.circular(12),
  //           getTooltipItems: (touchedSpots) {
  //             return touchedSpots.map((spot) {
  //               return LineTooltipItem(
  //                 'Score: ${spot.y.toInt()}%',
  //                 const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
  //               );
  //             }).toList();
  //           },
  //         ),
  //       ),
  //       lineBarsData: [
  //         LineChartBarData(
  //           spots: spots,
  //           isCurved: true,
  //           curveSmoothness: 0.4,
  //           color: const Color(0xFF1DB97B),
  //           barWidth: 2.5,
  //           isStrokeCapRound: true,
  //           dotData: FlDotData(
  //             show: true,
  //             getDotPainter: (spot, percent, bar, index) {
  //               if (spot.x == spots.last.x && spot.y == spots.last.y) {
  //                 return FlDotCirclePainter(radius: 7, color: const Color(0xFF1DB97B), strokeWidth: 0);
  //               }
  //               return FlDotCirclePainter(radius: 0, color: Colors.transparent, strokeWidth: 0);
  //             },
  //           ),
  //         ),
  //       ],
  //       showingTooltipIndicators: spots.isEmpty
  //           ? const []
  //           : [
  //               ShowingTooltipIndicators([
  //                 LineBarSpot(
  //                   LineChartBarData(spots: spots, isCurved: true, color: const Color(0xFF1DB97B)),
  //                   0,
  //                   latestSpot,
  //                 ),
  //               ]),
  //             ],
  //     ),
  //   );
  // }
}
