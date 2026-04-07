import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/analytics/widget/daily_activity_split_card.dart';
import 'package:chrisimhof/features/analytics/widget/sleep_trend_card.dart';
import 'package:chrisimhof/features/analytics/widget/weekly_analytics_card.dart';
import 'package:chrisimhof/features/analytics/widget/wellness_score_card.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.only(
            top: 78,
            left: 16,
            right: 16,
            bottom: 150,
          ),
          child: Column(
            children: [
              CustomAppBar(title: 'Analytics', showBackButton: false),
              SizedBox(height: 24),
              WeeklyAnalyticsCard(),
              SizedBox(height: 16),
              SleepTrendCard(),
              SizedBox(height: 16),
              WellnessScoreCard(),
              SizedBox(height: 16),
              DailyActivitySplitCard(),
            ],
          ),
        ),
      ),
    );
  }
}
