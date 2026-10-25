import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/features/tutorial/controller/tutorial_controller.dart';
import 'package:chrisimhof/features/tutorial/model/tutorial_step.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplitStatusSection extends StatelessWidget {
  const SplitStatusSection({super.key});

  static final GlobalKey _workCardKey = GlobalKey();
  static final GlobalKey _lastSleepCardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<TutorialController>()) {
        final tc = Get.find<TutorialController>();
        tc.registerKey(TutorialTargetId.workCard, _workCardKey);
        tc.registerKey(TutorialTargetId.lastSleepCard, _lastSleepCardKey);
      }
    });

    return Obx(() {
      final data = controller.dashboardData.value;
      return Row(
        children: [
          // Left Card: WORK
          Expanded(
            child: _buildStatusCard(
              cardKey: _workCardKey,
              headerIcon: Icons.work_outline,
              headerLabel: 'WORK'.tr,
              badgeText: data.workRotationName.isNotEmpty ? data.workRotationName : null,
              titleText: data.workShift,
              subtitleText: data.workShiftCountdown,
              onTap: () => Get.toNamed(AppRoutes.workScheduleScreen),
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
              cardKey: _lastSleepCardKey,
              headerIcon: Icons.nightlight_round,
              headerLabel: 'LAST SLEEP'.tr,
              titleText: data.lastSleepDuration,
              subtitleText: data.sleepDebtText,
              onTap: () => Get.toNamed(AppRoutes.sleepScreen),
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
    Key? cardKey,
    required IconData headerIcon,
    required String headerLabel,
    String? badgeText,
    required String titleText,
    required String subtitleText,
    required VoidCallback onTap,
    required Widget bottomWidget,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        key: cardKey,
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
                  headerLabel.tr,
                  style: getTextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSoft,
                  ),
                ),
                if (badgeText != null && badgeText.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryButtonColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badgeText,
                        style: getTextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondaryButtonColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Text(
              subtitleText,
              style: getTextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: AppColors.textSoft,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            bottomWidget,
          ],
        ),
      ),
    );
  }
}
