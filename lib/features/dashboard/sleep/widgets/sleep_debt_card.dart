import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/sleep/controller/sleep_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SleepDebtCard extends StatelessWidget {
  const SleepDebtCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SleepController>();
    return Obx(() {
      final chartData = controller.sleepDebtChartData;
      final selectedIndex = controller.selectedDebtIndex.value;
      final displayDebt = controller.sleepDebtTotalDisplay.value;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.gray100, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 1),
              blurRadius: 2,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SLEEP DEBT'.tr,
                  style: getTextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.selectionGray,
                  ).copyWith(letterSpacing: 1.1),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    controller.sleepDebtLabel.value,
                    style: getTextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greyMedium,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              displayDebt,
              style: getTextStyle2(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 16),

            if (chartData.isNotEmpty)
              Builder(
                builder: (context) {
                  chartData
                      .map((d) => (d['debtMinutes'] as num?)?.toDouble() ?? 0.0)
                      .reduce((a, b) => a > b ? a : b);

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(chartData.length, (index) {
                      final dayData = chartData[index];
                      final dayLabel = dayData['day'] as String? ?? '';
                      final isSelected = index == selectedIndex;

                      // Calculate height: min 6, max 40
                      double barHeight = 6.0;

                      return Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            controller.selectedDebtIndex.value = index;
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: barHeight,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryButtonColor
                                        : AppColors.sleepIndicatorFaint,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  dayLabel,
                                  style: getTextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.w800
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? AppColors.primaryTextColor
                                        : AppColors.selectionGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              )
            else
              const SizedBox(height: 32),
          ],
        ),
      );
    });
  }
}
