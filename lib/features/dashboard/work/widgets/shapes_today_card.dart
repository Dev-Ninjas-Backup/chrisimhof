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
      final shift = controller.selectedShiftType.value;
      final startH = controller.startHour.value.toString().padLeft(2, '0');
      final startM = controller.startMinute.value.toString().padLeft(2, '0');
      final shiftStart = '$startH:$startM';

      // --- Dynamic values from DashboardController ---
      String optimalBedtime = '22:30';
      String caffeineEnd = '14:00';
      try {
        if (Get.isRegistered<DashboardController>()) {
          final dashData = Get.find<DashboardController>().dashboardData.value;
          optimalBedtime = dashData.optimalBedtime;

          // Caffeine cut-off heuristic: 8 h before bedtime
          final parts = optimalBedtime.split(':');
          if (parts.length == 2) {
            final bedH = int.tryParse(parts[0]) ?? 22;
            final bedM = int.tryParse(parts[1]) ?? 30;
            final cutoffMinutes = ((bedH * 60 + bedM) - 8 * 60 + 1440) % 1440;
            caffeineEnd =
                '${(cutoffMinutes ~/ 60).toString().padLeft(2, '0')}:${(cutoffMinutes % 60).toString().padLeft(2, '0')}';
          }
        }
      } catch (_) {}

      // Pre-shift meal: 1 h before start
      String preMealTime = shiftStart;
      try {
        final sh = controller.startHour.value;
        final sm = controller.startMinute.value;
        final preMealMin = ((sh * 60 + sm) - 60 + 1440) % 1440;
        preMealTime =
            '${(preMealMin ~/ 60).toString().padLeft(2, '0')}:${(preMealMin % 60).toString().padLeft(2, '0')}';
      } catch (_) {}

      String text;
      if (shift == 'Night') {
        text =
            'Night shift starts $shiftStart → bedtime pushed to $optimalBedtime tomorrow'
            ' · caffeine cut-off at $caffeineEnd'
            ' · pre-shift light meal at $preMealTime.';
      } else if (shift == 'Day') {
        text =
            'Day shift starts $shiftStart → standard bedtime $optimalBedtime tonight'
            ' · caffeine cut-off at $caffeineEnd'
            ' · pre-shift breakfast at $preMealTime.';
      } else if (shift == 'Evening') {
        text =
            'Evening shift starts $shiftStart → bedtime pushed to $optimalBedtime tomorrow'
            ' · caffeine cut-off at $caffeineEnd'
            ' · pre-shift light meal at $preMealTime.';
      } else {
        text =
            'Day off today → focus on recovery, natural daylight exposure, and catching up on sleep debt.';
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
