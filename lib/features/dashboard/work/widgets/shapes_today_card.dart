import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/features/dashboard/work/controller/work_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShapesTodayCard extends StatelessWidget {
  final WorkController controller;

  const ShapesTodayCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // --- Dynamic values from DashboardController ---
      String optimalBedtime = '22:30';
      try {
        if (Get.isRegistered<DashboardController>()) {
          final dashData = Get.find<DashboardController>().dashboardData.value;
          optimalBedtime = dashData.optimalBedtime;

          optimalBedtime.split(':');
        }
      } catch (_) {}

      String text;
      if (controller.workShapesToday.isNotEmpty) {
        text = '· ' + controller.workShapesToday.join('\n· ');
      } else {
        text = "";
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.mintSoft3,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.primaryButtonColor.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bolt_rounded,
                color: AppColors.primaryButtonColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HOW THIS SHAPES TODAY'.tr,
                    style: getTextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryButtonColor,
                    ).copyWith(letterSpacing: 1.1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    text,
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.gray700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
