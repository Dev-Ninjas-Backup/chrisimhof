// ignore_for_file: unused_import

import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/history_details/model/history_details_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class HistoryDetailsActivitySplitCard extends StatelessWidget {
  // final List<ActivityItem> activityItems;
  //
  // const HistoryDetailsActivitySplitCard({
  //   super.key,
  //   required this.activityItems,
  // });

  const HistoryDetailsActivitySplitCard({
    super.key,
    // required this.activityItems,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
    // return Container(
    //   width: Get.width,
    //   height: 290,
    //   padding: const EdgeInsets.all(16),
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.circular(24),
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text(
    //         'Activity Split',
    //         style: getTextStyle(
    //           fontSize: 18,
    //           fontWeight: FontWeight.w600,
    //           color: AppColors.primaryTextColor,
    //         ),
    //       ),
    //       const SizedBox(height: 4),
    //       Text(
    //         'Average time allocation',
    //         style: getTextStyle(
    //           fontSize: 14,
    //           fontWeight: FontWeight.w400,
    //           color: AppColors.secondaryTextColor,
    //         ),
    //       ),
    //       const SizedBox(height: 30),
    //       Expanded(
    //         child: Row(
    //           children: [
    //             Expanded(
    //               flex: 11,
    //               child: Center(
    //                 child: AspectRatio(
    //                   aspectRatio: 1,
    //                   child: PieChart(
    //                     PieChartData(
    //                       startDegreeOffset: 110,
    //                       sectionsSpace: 10,
    //                       centerSpaceRadius: 72,
    //                       borderData: FlBorderData(show: false),
    //                       pieTouchData: PieTouchData(enabled: false),
    //                       sections: activityItems.map((item) {
    //                         return PieChartSectionData(
    //                           value: item.percent,
    //                           color: item.color,
    //                           radius: 25,
    //                           showTitle: false,
    //                           borderSide: const BorderSide(
    //                             color: Colors.white,
    //                             width: 0,
    //                           ),
    //                         );
    //                       }).toList(),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(width: 20),
    //             Expanded(
    //               flex: 10,
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: activityItems.map((item) {
    //                   return _LegendItem(
    //                     color: item.color,
    //                     percent: item.percentLabel,
    //                     title: item.title,
    //                   );
    //                 }).toList(),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

// class _LegendItem extends StatelessWidget {
//   final Color color;
//   final String percent;
//   final String title;
//
//   const _LegendItem({
//     required this.color,
//     required this.percent,
//     required this.title,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 22,
//           height: 22,
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         const SizedBox(width: 12),
//         RichText(
//           text: TextSpan(
//             children: [
//               TextSpan(
//                 text: '$percent ',
//                 style: getTextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.primaryTextColor,
//                 ),
//               ),
//               TextSpan(
//                 text: title,
//                 style: getTextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: AppColors.secondaryTextColor,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
