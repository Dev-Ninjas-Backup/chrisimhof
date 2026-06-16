import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SplitStatusSection extends StatelessWidget {
  const SplitStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    return Obx(() {
      final data = controller.dashboardData.value;
      return Row(
        children: [
          // Left Card: WORK
          Expanded(
            child: _buildStatusCard(
              headerIcon: Icons.work_outline,
              headerLabel: 'WORK',
              titleText: data.workShift,
              subtitleText: data.workShiftCountdown,
              onTap: () => EasyLoading.showToast('Work schedule clicked!'),
              bottomWidget: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: data.workProgress,
                    minHeight: 6,
                    backgroundColor: AppColors.gray100,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.secondaryButtonColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Right Card: LAST SLEEP
          Expanded(
            child: _buildStatusCard(
              headerIcon: Icons.nightlight_round,
              headerLabel: 'LAST SLEEP',
              titleText: data.lastSleepDuration,
              subtitleText: data.sleepDebtText,
              onTap: () => EasyLoading.showToast('Sleep analysis clicked!'),
              bottomWidget: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(data.lastSleepWeekBars.length, (
                    index,
                  ) {
                    final val = data.lastSleepWeekBars[index];
                    return Container(
                      width: 10,
                      height: 24 * val,
                      decoration: BoxDecoration(
                        color: index == data.lastSleepWeekBars.length - 1
                            ? AppColors
                                  .secondaryButtonColor // highlight last bar
                            : AppColors.mint,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStatusCard({
    required IconData headerIcon,
    required String headerLabel,
    required String titleText,
    required String subtitleText,
    required VoidCallback onTap,
    required Widget bottomWidget,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderSoft, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(headerIcon, size: 14, color: AppColors.textSoft),
                const SizedBox(width: 4),
                Text(
                  headerLabel,
                  style: getTextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSoft,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  size: 14,
                  color: AppColors.textSoft.withValues(alpha: 0.7),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              titleText,
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitleText,
              style: getTextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: AppColors.textSoft,
              ),
            ),
            bottomWidget,
          ],
        ),
      ),
    );
  }
}
