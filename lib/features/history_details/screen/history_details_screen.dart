import 'package:chrisimhof/features/history_details/controller/history_details_controller.dart';
import 'package:chrisimhof/features/history_details/model/history_details_model.dart';
import 'package:chrisimhof/features/history_details/widgets/history_details_activity_split_card.dart';
import 'package:chrisimhof/features/history_details/widgets/history_details_metric_card.dart';
import 'package:chrisimhof/features/history_details/widgets/history_details_overall_state_card.dart';
import 'package:chrisimhof/features/history_details/widgets/history_details_recommendations_card.dart';
import 'package:chrisimhof/features/history_details/widgets/history_details_weekly_analytics_card.dart';
import 'package:flutter/material.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:get/get.dart';

class HistoryDetailsScreen extends StatelessWidget {
  const HistoryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HistoryDetailsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
     appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'History Details',
          style: getTextStyle(
            color: AppColors.primaryTextColor,
            fontSize: 23, 
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '17 March 2026 20:48:33',
                style: getTextStyle(
                  color: AppColors.primaryTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          final resultData = controller.resultData.value;

          if (controller.isLoading.value && resultData == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (resultData == null) {
            return const SizedBox.shrink();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 22, 16, 34),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overall State Section
                HistoryDetailsOverallStateCard(
                  score: resultData.overallScore,
                  label: controller.getLabelForScore(resultData.overallScore),
                ),
                const SizedBox(height: 16),
                
                // 2x2 Grid for State Summary Cards
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.98,
                  ),
                  itemBuilder: (context, index) {
                    final metrics = [
                      HistoryMetric(
                        title: 'Sleep',
                        score: resultData.scoreBreakdown.sleep,
                        category: 'sleep',
                      ),
                      HistoryMetric(
                        title: 'Hydration',
                        score: resultData.scoreBreakdown.hydration,
                        category: 'hydration',
                      ),
                      HistoryMetric(
                        title: 'Caffeine',
                        score: resultData.scoreBreakdown.caffeine,
                        category: 'caffeine',
                      ),
                      HistoryMetric(
                        title: 'Nutrition',
                        score: resultData.scoreBreakdown.nutrition,
                        category: 'nutrition',
                      ),
                    ];
                    return HistoryDetailsMetricCard(metric: metrics[index]);
                  },
                ),
                const SizedBox(height: 16),
                
                // Daily Activity Split Section
                HistoryDetailsActivitySplitCard(
                  activityItems: resultData.activityItems,
                ),
                const SizedBox(height: 16),
                
                // Weekly Analytics Section
                HistoryDetailsWeeklyAnalyticsCard(
                  weeklyScores: resultData.weeklyScores,
                ),
                const SizedBox(height: 16),
                
                // Recommendations Section
                HistoryDetailsRecommendationsCard(
                  recommendations: resultData.recommendations,
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}