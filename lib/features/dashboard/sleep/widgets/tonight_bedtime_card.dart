import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/features/dashboard/sleep/controller/sleep_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TonightBedtimeCard extends StatelessWidget {
  const TonightBedtimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SleepController>();
    return Obx(() {
      // --- Primary source: live sleep tab data from socket/API ---
      final apiSleepStart = controller.tonightBedtime.value?['sleepStart'] as String?;
      final apiWakeTime   = controller.tonightBedtime.value?['wakeTime']   as String?;
      final apiNote       = controller.tonightNote.value;

      // --- Fallback: use DashboardController's optimalBedtime ---
      String bedtime = apiSleepStart ?? _fallbackBedtime();
      String wakeup  = apiWakeTime  ?? _computeWakeup(bedtime);
      String note    = apiNote      ?? _fallbackNote();

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.white, width: 1),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.blueSoft, AppColors.mintSoft2],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 1),
              blurRadius: 2,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.auto_awesome_outlined,
                  color: AppColors.indigo,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TONIGHT\'S BEDTIME',
                    style: getTextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.indigo,
                    ).copyWith(letterSpacing: 1.1),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        bedtime,
                        style: getTextStyle2(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.arrow_right_alt_rounded,
                        color: AppColors.selectionGray,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        wakeup,
                        style: getTextStyle2(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note,
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyMedium,
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

  /// Returns the optimal bedtime from DashboardController, or '--:--' while loading.
  String _fallbackBedtime() {
    try {
      if (Get.isRegistered<DashboardController>()) {
        final optimal = Get.find<DashboardController>().dashboardData.value.optimalBedtime;
        if (optimal.isNotEmpty && optimal != '--:--') return optimal;
      }
    } catch (_) {}
    return '--:--';
  }

  /// Computes wake time as bedtime + 7h30m (target sleep duration).
  String _computeWakeup(String bedtime) {
    try {
      final parts = bedtime.split(':');
      if (parts.length == 2) {
        final h = int.tryParse(parts[0]) ?? 0;
        final m = int.tryParse(parts[1]) ?? 0;
        final wakeMinutes = (h * 60 + m + 450) % 1440; // +7h30m = +450 min
        return '${(wakeMinutes ~/ 60).toString().padLeft(2, '0')}:${(wakeMinutes % 60).toString().padLeft(2, '0')}';
      }
    } catch (_) {}
    return '--:--';
  }

  /// Builds a contextual note from DashboardController's work shift data.
  String _fallbackNote() {
    try {
      if (Get.isRegistered<DashboardController>()) {
        final data = Get.find<DashboardController>().dashboardData.value;
        final shift = data.workShift;
        final bedtime = data.optimalBedtime;
        if (shift.isNotEmpty && shift.toLowerCase() != 'off' && bedtime.isNotEmpty) {
          return 'Adjusted for your $shift.\nTargets 7h 30m.';
        }
        if (bedtime.isNotEmpty && bedtime != '--:--') {
          return 'Your optimal bedtime based on today\'s schedule.\nTargets 7h 30m.';
        }
      }
    } catch (_) {}
    return 'Log your activity to get a personalised bedtime.';
  }
}

