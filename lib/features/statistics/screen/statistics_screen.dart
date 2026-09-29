import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/statistics/controller/statistics_controller.dart';
import 'package:chrisimhof/features/statistics/widgets/analytics_header_tabs.dart';
import 'package:chrisimhof/features/statistics/widgets/daily_timeline_view.dart';
import 'package:chrisimhof/features/statistics/widgets/date_range_navigation_bar.dart';
import 'package:chrisimhof/features/statistics/widgets/lifestyle_indicators_card.dart';
import 'package:chrisimhof/features/statistics/widgets/period_filter_bar.dart';
import 'package:chrisimhof/features/statistics/widgets/rhythm_evolution_line_chart_card.dart';
import 'package:chrisimhof/features/statistics/widgets/sleep_overview_stacked_chart_card.dart';
import 'package:chrisimhof/features/statistics/widgets/top_scores_cards_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StatisticsController controller = Get.find<StatisticsController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 120.0),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12.0),
              AnalyticsHeaderTabs(controller: controller),
              const SizedBox(height: 18.0),

              Obx(() {
                if (controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 100.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryButtonColor,
                      ),
                    ),
                  );
                }

                if (controller.selectedTab.value == 0) {
                  return DailyTimelineView(controller: controller);
                }

                return Column(
                  children: [
                    PeriodFilterBar(controller: controller),
                    const SizedBox(height: 14.0),
                    DateRangeNavigationBar(controller: controller),
                    const SizedBox(height: 16.0),
                    TopScoresCardsGrid(controller: controller),
                    const SizedBox(height: 16.0),
                    RhythmEvolutionLineChartCard(controller: controller),
                    const SizedBox(height: 16.0),
                    LifestyleIndicatorsCard(controller: controller),
                    const SizedBox(height: 16.0),
                    SleepOverviewStackedChartCard(controller: controller),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
