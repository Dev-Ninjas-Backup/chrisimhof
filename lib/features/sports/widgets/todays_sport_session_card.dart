import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/sports/controller/sports_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodaysSportSessionCard extends StatelessWidget {
  const TodaysSportSessionCard({
    super.key,
    required this.controller,
  });

  final SportsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.hasTodaySession.value) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: AppColors.lavenderSoft,
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "TODAY'S SESSION".tr,
                style: getTextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF6D28D9),
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                "Rest Day".tr,
                style: getTextStyle2(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF4C1D95),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                "No active workout session logged today.".tr,
                style: getTextStyle(
                  fontSize: 13,
                  color: const Color(0xFF7C3AED),
                ),
              ),
            ],
          ),
        );
      }
    
      final parts = <String>[];
      parts.add(controller.todaySport.value.tr);
      if (controller.todayDistance.value.isNotEmpty) {
        parts.add(controller.todayDistance.value);
      }
      if (controller.todayStartTime.value.isNotEmpty &&
          controller.todayEndTime.value.isNotEmpty) {
        parts.add(
            '${controller.todayStartTime.value} → ${controller.todayEndTime.value}');
      }
      final infoText = parts.join(' · ');
    
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: AppColors.lavenderSoft,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "TODAY'S SESSION".tr,
              style: getTextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF6D28D9),
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${controller.todayDuration.value}',
                  style: getTextStyle2(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4C1D95),
                  ),
                ),
                const SizedBox(width: 4.0),
                Text(
                  'min · ${controller.todayZone.value}'.tr,
                  style: getTextStyle2(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4C1D95),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              infoText,
              style: getTextStyle2(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF7C3AED),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EFFORT'.tr,
                          style: getTextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF7C3AED),
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          controller.todayEffort.value.tr,
                          style: getTextStyle2(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF4C1D95),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TYPE'.tr,
                          style: getTextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF7C3AED),
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          controller.todayType.value.tr,
                          style: getTextStyle2(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF4C1D95),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}