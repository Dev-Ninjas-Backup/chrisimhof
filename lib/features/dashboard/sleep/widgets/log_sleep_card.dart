import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/dashboard/sleep/controller/sleep_controller.dart';
import 'package:chrisimhof/features/dashboard/sleep/widgets/time_adjuster_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogSleepCard extends StatelessWidget {
  final SleepController controller;

  const LogSleepCard({super.key, required this.controller});

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
            offset: Offset(0, 20),
            blurRadius: 25,
            spreadRadius: -5,
          ),
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.10),
            offset: Offset(0, 8),
            blurRadius: 10,
            spreadRadius: -6,
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
                      'LOG TONIGHT\'S SLEEP',
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryButtonColor,
                      ).copyWith(letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mon 17 May · tap arrows to adjust',
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.selectionGray,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryButtonColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryButtonColor.withValues(
                        alpha: 0.30,
                      ),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    controller.currentSleepDuration,
                    style: getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryButtonColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => TimeAdjusterBox(
                    title: 'Bedtime',
                    iconPath: IconPath.moon,
                    hour: controller.bedtimeHour.value,
                    minute: controller.bedtimeMinute.value,
                    onHourUp: controller.incrementBedtimeHour,
                    onHourDown: controller.decrementBedtimeHour,
                    onMinuteUp: controller.incrementBedtimeMinute,
                    onMinuteDown: controller.decrementBedtimeMinute,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => TimeAdjusterBox(
                    title: 'Wake-up',
                    iconPath: IconPath.sun,
                    hour: controller.wakeupHour.value,
                    minute: controller.wakeupMinute.value,
                    onHourUp: controller.incrementWakeupHour,
                    onHourDown: controller.decrementWakeupHour,
                    onMinuteUp: controller.incrementWakeupMinute,
                    onMinuteDown: controller.decrementWakeupMinute,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Save sleep button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.primaryButtonColor, // Selection color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: controller.saveSleep,
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
                    'Save sleep',
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
}
