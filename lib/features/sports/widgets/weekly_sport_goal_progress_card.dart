import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/sports/controller/sports_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeeklySportGoalProgressCard extends StatelessWidget {
  final SportsController controller;

  const WeeklySportGoalProgressCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final goal = controller.weeklyGoal.value;
      if (goal <= 0) return const SizedBox.shrink();

      final completed = controller.workoutsCompletedThisWeek.value;
      final daysRemaining = controller.daysRemainingInWeek.value;
      final isMet = controller.isGoalMet.value || completed >= goal;
      final isAdaptiveRest = controller.adaptiveRestRecommended.value;
      final progress = (completed / goal).clamp(0.0, 1.0);

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: AppColors.borderSoft),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Title + Adaptive Rest or Goal Met Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.mintSoft3,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.fitness_center_rounded,
                        size: 18,
                        color: AppColors.secondaryButtonColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WEEKLY GOAL'.tr,
                          style: getTextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondaryTextColor,
                          ),
                        ),
                        Text(
                          '$completed / $goal ${'workouts'.tr}',
                          style: getTextStyle2(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (isAdaptiveRest)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF), // Lavender soft
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFC084FC)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.spa_rounded,
                          size: 14,
                          color: Color(0xFF7E22CE),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Adaptive Rest'.tr,
                          style: getTextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF7E22CE),
                          ),
                        ),
                      ],
                    ),
                  )
                else if (isMet)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.mintSoft3,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.secondaryButtonColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 14,
                          color: AppColors.secondaryButtonColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Goal Met'.tr,
                          style: getTextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondaryButtonColor,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.gray100,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isMet
                      ? AppColors.secondaryButtonColor
                      : const Color(0xFF10B981),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Days left / pacing description
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isMet
                      ? 'Weekly workout target reached!'.tr
                      : '$daysRemaining ${daysRemaining == 1 ? 'day remaining'.tr : 'days remaining'.tr}',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSoft,
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ],
            ),

            // Adaptive Rest Recommendation Callout
            if (isAdaptiveRest) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF5FF), // soft purple tint
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE9D5FF)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: Color(0xFF9333EA),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "You're on track with your weekly goal — taking a rest day today will support your recovery and performance."
                            .tr,
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6B21A8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}
