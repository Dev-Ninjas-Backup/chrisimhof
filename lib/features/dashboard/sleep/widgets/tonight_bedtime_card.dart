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
      final bedtimeMap = controller.tonightBedtime.value;
      String? apiSleepStart = (bedtimeMap?['sleepStart'] ?? bedtimeMap?['time']) as String?;
      String? apiWakeTime   = (bedtimeMap?['wakeTime'] ?? bedtimeMap?['sleepEnd']) as String?;
      final apiNote         = controller.tonightNote.value;

      // Fallback to shift-aware optimal bedtime from DashboardController if not yet in map
      if (apiSleepStart == null || apiSleepStart.isEmpty || apiSleepStart == '--:--') {
        if (Get.isRegistered<DashboardController>()) {
          final optimal = Get.find<DashboardController>().dashboardData.value.optimalBedtime;
          if (optimal.isNotEmpty && optimal != '--:--') {
            apiSleepStart = optimal;
          }
        }
      }

      // Fallback to controller's calculated/parsed wakeup time if wakeTime not in map
      if (apiWakeTime == null || apiWakeTime.isEmpty || apiWakeTime == '--:--') {
        if (controller.wakeupHour.value != 0 || controller.wakeupMinute.value != 0) {
          apiWakeTime =
              '${controller.wakeupHour.value.toString().padLeft(2, '0')}:${controller.wakeupMinute.value.toString().padLeft(2, '0')}';
        }
      }

      String bedtime = apiSleepStart ?? '--:--';
      String wakeup  = apiWakeTime  ?? '--:--';
      String note    = apiNote      ?? '';

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
                    'TONIGHT\'S BEDTIME'.tr,
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
}

