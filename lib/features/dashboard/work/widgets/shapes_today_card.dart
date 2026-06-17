import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/work/controller/work_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShapesTodayCard extends StatelessWidget {
  final WorkController controller;

  const ShapesTodayCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final shift = controller.selectedShiftType.value;
      final startHStr = controller.startHour.value.toString().padLeft(2, '0');
      final startMStr = controller.startMinute.value.toString().padLeft(2, '0');
      
      String text;
      if (shift == 'Night') {
        text = 'Night shift starts $startHStr:$startMStr → bedtime pushed to 14:30 tomorrow · caffeine cut-off at 10:00 · pre-shift Light meal at 21:00.';
      } else if (shift == 'Day') {
        text = 'Day shift starts $startHStr:$startMStr → standard bedtime tonight · caffeine cut-off at 14:00 · pre-shift breakfast at 08:00.';
      } else if (shift == 'Evening') {
        text = 'Evening shift starts $startHStr:$startMStr → bedtime pushed to 01:30 tomorrow · caffeine cut-off at 16:30 · pre-shift light meal at 13:00.';
      } else {
        text = 'Day off today → focus on recovery, natural daylight exposure, and catching up on sleep debt.';
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
                    'HOW THIS SHAPES TODAY',
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
