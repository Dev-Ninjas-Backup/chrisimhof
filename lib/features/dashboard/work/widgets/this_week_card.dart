import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/work/controller/work_controller.dart';
import 'package:chrisimhof/features/dashboard/work/widgets/day_bubble.dart';
import 'package:chrisimhof/features/dashboard/work/widgets/edit_pattern_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThisWeekCard extends StatelessWidget {
  final WorkController controller;

  const ThisWeekCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.gray100, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'THIS WEEK'.tr,
                style: getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryTextColor,
                ).copyWith(letterSpacing: 1.1),
              ),
              GestureDetector(
                onTap: () => Get.bottomSheet(EditPatternBottomSheet(controller: controller)),
                child: Text(
                  'Edit pattern →'.tr,
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondaryButtonColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Monday - Sunday Row
          Obx(() {
            // weekday: 1=Mon, 2=Tue, ..., 7=Sun  →  index 0–6
            final todayIndex = DateTime.now().weekday - 1;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final dayData = controller.weeklyPattern[index];
                return DayBubble(
                  index: index,
                  dayLabel: dayData['day']!,
                  shift: dayData['shift']!,
                  isToday: index == todayIndex,
                  onTap: () => controller.toggleDayShift(index),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}
