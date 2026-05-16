import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/analytics/controller/analytics_controller.dart';
import 'package:chrisimhof/features/analytics/widget/daily_activity_split_card.dart';
import 'package:chrisimhof/features/analytics/widget/sleep_trend_card.dart';
import 'package:chrisimhof/features/analytics/widget/weekly_analytics_card.dart';
import 'package:chrisimhof/features/analytics/widget/wellness_score_card.dart';
import 'package:chrisimhof/features/analytics/widget/history_details_weekly_analytics_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AnalyticsController>()) {
      Get.put(AnalyticsController());
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.only(
            top: 78,
            left: 16,
            right: 16,
            bottom: 100,
          ),
          child: Column(
            children: [
              CustomAppBar(title: 'Analytics'.tr, showBackButton: false),
              SizedBox(height: 24),
              WeeklyAnalyticsCard(),
              SizedBox(height: 16),
              SleepTrendCard(),
              SizedBox(height: 16),
              WellnessScoreCard(),
              SizedBox(height: 16),
              
              DailyActivitySplitCard(),
              SizedBox(height: 16),
              // Circadian peak summary (shows peak hour, score, and insight)
              Obx(() {
                final controller = Get.find<AnalyticsController>();
                final circ = controller.analyticsData.value?.circadianAnalysis;
                if (circ == null) return const SizedBox.shrink();

                final peakHourLabel = circ.peakHour != null
                    ? '${circ.peakHour.toString().padLeft(2, '0')}:00'
                    : '';
                final peakScoreLabel = circ.peakScore != null
                    ? '${circ.peakScore}%'
                    : '';
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Peak Performance'.tr,
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (peakHourLabel.isNotEmpty)
                            Text(
                              peakHourLabel,
                              style: getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTextColor,
                              ),
                            ),
                          if (peakHourLabel.isNotEmpty &&
                              peakScoreLabel.isNotEmpty)
                            const SizedBox(width: 8),
                          if (peakScoreLabel.isNotEmpty)
                            Text(
                              peakScoreLabel,
                              style: getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTextColor,
                              ),
                            ),
                        ],
                      ),
                      if ((circ.insight ?? '').isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          circ.insight!,
                          style: getTextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondaryTextColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
              SizedBox(height: 16),
              HistoryDetailsWeeklyAnalyticsCard(),
            ],
          ),
        ),
      ),
    );
  }
}
