import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/caffeine/controller/caffeine_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CaffeineBedtimeClearanceCard extends StatelessWidget {
  const CaffeineBedtimeClearanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CaffeineController>();

    return Obx(() {
      final activeAtBedtime = controller.activeCaffeineAtBedtime.value;
      final bufferMinutes = controller.bedtimeBufferMinutes.value;

      // Only show if active caffeine at bedtime is significant (> 50 mg) or buffer is applied
      if (activeAtBedtime <= 50 && bufferMinutes <= 0) {
        return const SizedBox.shrink();
      }

      final mgFormatted = activeAtBedtime.toStringAsFixed(0);
      final String message;
      if (bufferMinutes > 0) {
        message =
            '$mgFormatted ${'mg active at bedtime — your recommended sleep time has been delayed by'.tr} $bufferMinutes ${'minutes to allow clearance.'.tr}';
      } else {
        message =
            '$mgFormatted ${'mg active at bedtime — elevated caffeine may impact your sleep latency and quality.'.tr}';
      }

      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.amberDark.withValues(alpha: 0.4),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.amberDark.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.amberSoft3,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bedtime_outlined,
                color: AppColors.amberDark,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'BEDTIME DELAY'.tr,
                        style: getTextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.amberDark,
                        ).copyWith(letterSpacing: 1.1),
                      ),
                      if (bufferMinutes > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.amberSoft3,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '+${bufferMinutes}m',
                            style: getTextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.amberDark,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryTextColor,
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
