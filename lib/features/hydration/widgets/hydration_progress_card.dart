import 'package:chrisimhof/core/common/widgets/global_rhythm_ring_painter.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/hydration/controller/hydration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color _hydrationTrack = Color(0xFFD6EEFB);

class HydrationProgressCard extends StatelessWidget {
  const HydrationProgressCard({super.key, required this.controller});

  final HydrationController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final double progress = (controller.dailyGoal.value > 0)
          ? controller.selectedDayIntake / controller.dailyGoal.value
          : 0.0;
      final String? previewBody = controller.isSelectedDayToday
          ? controller.hydrationPreviewBody.value
          : null;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.blueSoft2.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular Progress Ring
            SizedBox(
              width: 190,
              height: 190,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: progress),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (context, animatedProgress, child) {
                      return CustomPaint(
                        size: const Size(190, 190),
                        painter: GlobalRhythmRingPainter(
                          progress: animatedProgress,
                          trackColor: _hydrationTrack,
                          progressColor: AppColors.blue2,
                          trackStrokeWidth: 8.0,
                          progressStrokeWidth: 12.0,
                          offset: 10.0,
                        ),
                      );
                    },
                    key: ValueKey(progress),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.water_drop_rounded,
                        color: AppColors.blue2,
                        size: 26,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${controller.selectedDayIntake.toStringAsFixed(1)} L',
                        style: getTextStyle2(
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'of ${controller.dailyGoal.value.toStringAsFixed(1)} L',
                        style: getTextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.greyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // Dynamic Left sub-indicator text
            if (previewBody != null && previewBody.isNotEmpty)
              Text(
                previewBody,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.greyMedium,
                ),
              )
            else
              RichText(
                text: TextSpan(
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyMedium,
                  ),
                  children: [
                    TextSpan(
                      text: '${controller.selectedDayLeftIntakeMl} ml ',
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue2,
                      ),
                    ),
                    TextSpan(
                      text: controller.isSelectedDayToday
                          ? 'left for today'.tr
                          : 'left'.tr,
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
