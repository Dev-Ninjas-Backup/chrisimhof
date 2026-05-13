// ignore_for_file: avoid_print

import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/dashboard/model/dashboard_item_model.dart';
import 'package:chrisimhof/features/dashboard/model/dashboard_model.dart';
import 'package:chrisimhof/features/dashboard/service/dashboard_service.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final dashboardService = DashboardService();

  final vitalityScore = 0.0.obs;
  final levelText = 'Loading...'.obs;
  final improvementPercentLabel = "".obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final optimalBedtime = ''.obs;

  final dashboardItems = <DashboardItemModel>[].obs;
  final sleepAdaptationNote = ''.obs;
  final dailyRecommendations = <DashboardRecommendation>[].obs;
  final weeklyTrendData = <WeeklyTrendItem>[].obs;
  final streak = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData().whenComplete(() => fetchOptimalBedtime());
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final dashboard = await dashboardService.fetchDashboard();

      // Update vitality score
      vitalityScore.value = dashboard.currentScore.toDouble();
      levelText.value = dashboard.scoreLevel;
      streak.value = dashboard.streak;
      sleepAdaptationNote.value = dashboard.sleepAdaptationNote;

      // Update improvement percentage from scoreChange
      if (dashboard.scoreChange != null) {
        improvementPercentLabel.value = dashboard.scoreChange!.label;
      }

      // Build dashboard items from cards
      final items = <DashboardItemModel>[];

      if (dashboard.cards.sleep != null) {
        items.add(
          DashboardItemModel(
            title: 'Sleep',
            image: IconPath.moon,
            percent: '${dashboard.cards.sleep!.score}%',
            description: dashboard.cards.sleep!.subtitle,
          ),
        );
      }

      if (dashboard.cards.hydration != null) {
        items.add(
          DashboardItemModel(
            title: 'Hydration',
            image: IconPath.waterDrops,
            percent: '${dashboard.cards.hydration!.score}%',
            description: dashboard.cards.hydration!.subtitle,
          ),
        );
      }

      if (dashboard.cards.caffeine != null) {
        items.add(
          DashboardItemModel(
            title: 'Caffeine',
            image: IconPath.vector,
            percent: '${dashboard.cards.caffeine!.score}%',
            description: dashboard.cards.caffeine!.subtitle,
          ),
        );
      }

      if (dashboard.cards.nutrition != null) {
        items.add(
          DashboardItemModel(
            title: 'Nutrition',
            image: IconPath.iron,
            percent: '${dashboard.cards.nutrition!.score}%',
            description: dashboard.cards.nutrition!.subtitle,
          ),
        );
      }

      if (dashboard.cards.activity != null) {
        items.add(
          DashboardItemModel(
            title: 'Activity',
            image: IconPath.waterDrops,
            percent: '${dashboard.cards.activity!.score}%',
            description: dashboard.cards.activity!.subtitle,
          ),
        );
      }

      if (dashboard.cards.recovery != null) {
        items.add(
          DashboardItemModel(
            title: 'Recovery',
            image: IconPath.iron,
            percent: '${dashboard.cards.recovery!.score}%',
            description: dashboard.cards.recovery!.subtitle,
          ),
        );
      }

      dashboardItems.value = items;

      // Update daily recommendations
      dailyRecommendations.value = dashboard.dailyRecommendations
          .map(
            (rec) => DashboardRecommendation(
              id: rec.id,
              category: rec.category,
              priority: rec.priority,
              isPremium: rec.isPremium,
              title: rec.title,
              body: rec.body,
            ),
          )
          .toList();

      // Update weekly trend
      weeklyTrendData.value = dashboard.weeklyTrend;

      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'Failed to load dashboard data';
      isLoading.value = false;
      print('Dashboard Error: $e');
    }
  }

  Future<void> refreshDashboard() async {
    await fetchDashboardData();
  }

  Future<void> fetchOptimalBedtime() async {
    try {
      final time = await dashboardService.fetchOptimalBedtime();
      if (time != null) {
        optimalBedtime.value = time;
      } else {
        optimalBedtime.value = '';
      }
    } catch (e) {
      // leave empty or set a friendly fallback
      optimalBedtime.value = '';
    }
  }

  String get formattedScore => '${vitalityScore.value.toInt()}%';
}

class DashboardRecommendation {
  final String id;
  final String category;
  final int priority;
  final bool isPremium;
  final String title;
  final String body;

  DashboardRecommendation({
    required this.id,
    required this.category,
    required this.priority,
    required this.isPremium,
    required this.title,
    required this.body,
  });
}
