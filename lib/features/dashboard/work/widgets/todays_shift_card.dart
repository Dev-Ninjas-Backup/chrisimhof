import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/work/controller/work_controller.dart';
import 'package:chrisimhof/features/dashboard/work/widgets/shift_type_pill.dart';
import 'package:chrisimhof/features/dashboard/work/widgets/work_time_adjuster_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodaysShiftCard extends StatelessWidget {
  final WorkController controller;

  const TodaysShiftCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.sleepCardBg,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 10),
            blurRadius: 20,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TODAY'S SHIFT",
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryButtonColor,
                      ).copyWith(letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formattedDate(),
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.selectionGray,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                return ShiftTypePill(
                  shift: controller.selectedShiftType.value,
                  duration: controller.shiftDurationText,
                );
              }),
            ],
          ),
          const SizedBox(height: 20),

          // Time Adjusters Row
          Row(
            children: [
              Expanded(
                child: Obx(() => WorkTimeAdjusterBox(
                      title: 'START',
                      icon: Icons.access_time_outlined,
                      hour: controller.startHour.value,
                      minute: controller.startMinute.value,
                      onHourUp: controller.incrementStartHour,
                      onHourDown: controller.decrementStartHour,
                      onMinuteUp: controller.incrementStartMinute,
                      onMinuteDown: controller.decrementStartMinute,
                    )),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(() => WorkTimeAdjusterBox(
                      title: 'END',
                      icon: Icons.flag_outlined,
                      hour: controller.endHour.value,
                      minute: controller.endMinute.value,
                      onHourUp: controller.incrementEndHour,
                      onHourDown: controller.decrementEndHour,
                      onMinuteUp: controller.incrementEndMinute,
                      onMinuteDown: controller.decrementEndMinute,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Save Shift Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButtonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: controller.saveShift,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_rounded,
                    color: AppColors.sleepCardBg,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Save shift',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.sleepCardBg,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formattedDate() {
    final now = DateTime.now();
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final weekday = weekdays[now.weekday - 1];
    final month = months[now.month - 1];
    return '$weekday · ${now.day} $month · tap arrows to adjust';
  }
}
