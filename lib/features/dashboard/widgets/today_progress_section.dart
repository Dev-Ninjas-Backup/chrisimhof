import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodayProgressSection extends StatelessWidget {
  const TodayProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TODAY',
          style: getTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryTextColor,
          ),
        ),
        const SizedBox(height: 14),
        Obx(() {
          final data = controller.dashboardData.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProgressRing(
                progress: data.sleepProgress,
                label: 'Sleep',
                color: AppColors.secondaryButtonColor, // Mint
              ),
              _buildProgressRing(
                progress: data.hydrationProgress,
                label: 'Hydration',
                color: AppColors.blue, // Blue
              ),
              _buildProgressRing(
                progress: data.caffeineProgress,
                label: 'Caffeine',
                color: AppColors.amber, // Orange
              ),
              _buildProgressRing(
                progress: data.recoveryProgress,
                label: 'Recovery',
                color: AppColors.violet, // Purple
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildProgressRing({
    required double progress,
    required String label,
    required Color color,
  }) {
    final displayPercent = (progress * 100).toInt();

    return Expanded(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Ring track background & active progress
              SizedBox(
                width: 58,
                height: 58,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 5.5,
                  backgroundColor: color.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Text(
                '$displayPercent%',
                style: getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: getTextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSoft,
            ),
          ),
        ],
      ),
    );
  }
}
