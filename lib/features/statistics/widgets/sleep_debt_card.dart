import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/statistics/controller/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SleepDebtCard extends StatelessWidget {
  const SleepDebtCard({
    super.key,
    required this.controller,
  });

  final StatisticsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SLEEP DEBT - ${controller.selectedPeriod.value.toUpperCase()} ROLLING'.tr,
              style: getTextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSoft,
              ),
            ),
          ),
          const SizedBox(height: 6.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                controller.sleepDebtValue.value,
                style: getTextStyle2(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
              ),
              const SizedBox(width: 8.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_downward,
                    color: AppColors.primaryButtonColor,
                    size: 12,
                  ),
                  const SizedBox(width: 2.0),
                  Text(
                    controller.sleepDebtChange.value,
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryButtonColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18.0),

          // Progress bar with orange-to-green gradient
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: (controller.sleepDebtProgress.value * 100).round(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.orangeAccent, // Orange
                          AppColors.primaryButtonColor, // Mint green
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: ((1.0 - controller.sleepDebtProgress.value) * 100)
                      .round(),
                  child: const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
