import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/dashboard/model/dashboard_item_model.dart';
import 'package:chrisimhof/features/dashboard/model/dashboard_model.dart';
import 'package:chrisimhof/features/dashboard/service/dashboard_service.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final dashboardService = DashboardService();

  final vitalityScore = 0.0.obs;
  final levelText = 'Loading...'.obs;
  final improvementPercent = 0.obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  final dashboardItems = <DashboardItemModel>[
    DashboardItemModel(
      title: 'Sleep',
      image: IconPath.moon,
      percent: '90%',
      description: '7h slept / 0h debt',
    ),
    DashboardItemModel(
      title: 'Hydration',
      image: IconPath.waterDrops,
      percent: '72%',
      description: '1.5L / 2.5L',
    ),
    DashboardItemModel(
      title: 'Caffeine',
      image: IconPath.vector,
      percent: '82%',
      description: '123 mg today',
    ),
    DashboardItemModel(
      title: 'Nutrition',
      image: IconPath.iron,
      percent: '86%',
      description: 'Small night meal • 3 meals',
    ),
  ].obs;
  final sleepAdaptationNote = ''.obs;
  final dailyRecommendations = <DashboardRecommendation>[].obs;
  final weeklyTrendData = <WeeklyTrendItem>[].obs;
  final streak = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final dashboard = await dashboardService.fetchDashboard();

      // Update vitality score
      vitalityScore.value = dashboard.currentScore.toDouble();
      levelText.value = _getLevelText(dashboard.currentScore);
      streak.value = dashboard.streak;
      sleepAdaptationNote.value = dashboard.sleepAdaptationNote;

      // Update daily recommendations
      dailyRecommendations.value = dashboard.dailyRecommendations
          .map((rec) => DashboardRecommendation(
                id: rec.id,
                category: rec.category,
                priority: rec.priority,
                isPremium: rec.isPremium,
                title: rec.title,
                body: rec.body,
              ))
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

  String get formattedScore => '${vitalityScore.value.toInt()}%';

  String _getLevelText(int score) {
    if (score >= 80) return 'Excellent level';
    if (score >= 60) return 'Good level';
    if (score >= 40) return 'Moderate level';
    return 'Poor level';
  }
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
