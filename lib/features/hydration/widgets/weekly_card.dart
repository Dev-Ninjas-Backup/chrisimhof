import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/hydration/controller/hydration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color _hydrationWeekGreen = Color(0xFF83EDBA);

class WeeklyCard extends StatelessWidget {
  const WeeklyCard({super.key, required this.controller});

  final HydrationController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.subtle, width: 1.5),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'WEEKLY'.tr,
                  style: getTextStyle2(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                Text(
                  '${'avg'.tr} ${controller.weeklyAverage.toStringAsFixed(1)} L',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyAlt,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: controller.computedWeeklySummary.asMap().entries.map((
                entry,
              ) {
                final int index = entry.key;
                final day = entry.value;

                // Define colors depending on if it is selected
                final bool isSelected =
                    index == controller.selectedDayIndex.value;
                final Color barColor = isSelected
                    ? AppColors.blue2
                    : _hydrationWeekGreen;
                final FontWeight fontW = isSelected
                    ? FontWeight.w800
                    : FontWeight.w500;
                final Color labelColor = isSelected
                    ? AppColors.primaryTextColor
                    : AppColors.greyAlt;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => controller.selectDay(index),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      children: [
                        // Horizontal bar above each day name
                        Container(
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: barColor,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Day name label
                        Text(
                          day.label,
                          style: getTextStyle(
                            fontSize: 11,
                            fontWeight: fontW,
                            color: labelColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }
}
