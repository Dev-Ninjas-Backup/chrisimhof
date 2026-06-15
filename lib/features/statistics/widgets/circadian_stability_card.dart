import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/image_path.dart';
import 'package:chrisimhof/features/statistics/controller/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircadianStabilityCard extends StatelessWidget {
  const CircadianStabilityCard({
    super.key,
    required this.controller,
  });

  final StatisticsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.authDarkAlt, // Dark forest green
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CIRCADIAN STABILITY'.tr,
                    style: getTextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryButtonColor,
                    ),
                  ),
                  const SizedBox(height: 12.5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${controller.circadianScore.value}',
                        style: getTextStyle2(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '%',
                        style: getTextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.trending_up,
                        color: AppColors.primaryButtonColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        controller.circadianChange.value.tr,
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 7.5,
              child: Image.asset(
                ImagePath.circadianStability,
                width: 145,
                height: 145,
              ),
            ),
          ],
        ),
      );
    });
  }
}
