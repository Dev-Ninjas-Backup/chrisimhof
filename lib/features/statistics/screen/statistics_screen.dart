import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/statistics/controller/statistics_controller.dart';
import 'package:chrisimhof/features/statistics/widgets/circadian_stability_card.dart';
import 'package:chrisimhof/features/statistics/widgets/fatigue_prediction_card.dart';
import 'package:chrisimhof/features/statistics/widgets/period_toggle.dart';
import 'package:chrisimhof/features/statistics/widgets/recovery_card.dart';
import 'package:chrisimhof/features/statistics/widgets/rhythm_score_card.dart';
import 'package:chrisimhof/features/statistics/widgets/sleep_debt_card.dart';
import 'package:chrisimhof/features/statistics/widgets/sleep_duration_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StatisticsController controller = Get.put(StatisticsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 120.0),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(
                showBackButton: false,
                showSettingsButton: false,
                showLogo: false,
                title: 'Statistics',
                showMoreButton: true,
              ),
              const SizedBox(height: 18.0),

              // Period Toggle Bar
              Obx(() => PeriodToggle(controller: controller)),
              const SizedBox(height: 20.0),

              // Obx-wrapped container containing all cards
              Obx(() {
                return Column(
                  children: [
                    // Card 1: Global Rhythm Score
                    RhythmScoreCard(controller: controller),
                    const SizedBox(height: 16.0),

                    // Card 2: Circadian Stability
                    CircadianStabilityCard(controller: controller),
                    const SizedBox(height: 16.0),

                    // Card 3: Sleep Duration
                    SleepDurationCard(controller: controller),
                    const SizedBox(height: 16.0),

                    // Card 4: Recovery
                    RecoveryCard(controller: controller),
                    const SizedBox(height: 16.0),

                    // Card 5: Fatigue Prediction
                    FatiguePredictionCard(controller: controller),
                    const SizedBox(height: 16.0),

                    // Card 6: Sleep Debt
                    SleepDebtCard(controller: controller),
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
