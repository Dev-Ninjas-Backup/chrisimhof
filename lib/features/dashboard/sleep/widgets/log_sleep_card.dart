import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/time_widget.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/dashboard/sleep/controller/sleep_controller.dart';
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
                      'LOG TONIGHT\'S SLEEP'.tr,
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryButtonColor,
                      ).copyWith(letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'drag or tap to adjust'.tr,
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
                  () => TimeWidget(
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
                  () => TimeWidget(
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
          CustomButton(
            text: 'Save Sleep',
            onTap: controller.saveSleep,
            textColor: AppColors.black,
            backgroundColor: AppColors.primaryButtonColor,
            plusIcon: true,
            icon: null,
            showIcon: Icons.check,
          ),
        ],
      ),
    );
  }
}
