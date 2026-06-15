import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/statistics/controller/statistics_controller.dart';
import 'package:chrisimhof/features/statistics/widgets/statistics_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SleepDurationCard extends StatelessWidget {
  const SleepDurationCard({
    super.key,
    required this.controller,
  });

  final StatisticsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SLEEP DURATION'.tr,
            style: getTextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSoft,
            ),
          ),
          const SizedBox(height: 6.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                controller.sleepDurationValue.value,
                style: getTextStyle2(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
              ),
              const SizedBox(width: 4.0),
              Text(
                'avg'.tr,
                style: getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryButtonColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          SparklineCurve(
            data: controller.sleepDurationData,
            lineColor: AppColors.violet, // Purple
            fillColor: AppColors.violet,
          ),
        ],
      ),
    );
  }
}
