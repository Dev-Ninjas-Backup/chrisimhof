import 'package:chrisimhof/features/statistics/model/statistics_model.dart';
import 'package:chrisimhof/features/statistics/service/statistics_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class StatisticsController extends GetxController {
  final RxString selectedPeriod = '7d'.obs;
  final List<String> periods = ['7d', '30d', '90d', '1y'];

  String get apiPeriod {
    switch (selectedPeriod.value) {
      case '7d':
        return '7d';
      case '30d':
        return '30d';
      case '90d':
        return '90d';
      case '1y':
        return '365d';
      default:
        return '7d';
    }
  }

  final RxBool isLoading = false.obs;
  final AnalyticsService _analyticsService = AnalyticsService();

  // Global Rhythm Score metrics
  final RxInt globalScore = 0.obs;
  final RxInt sleepMetric = 0.obs;
  final RxInt caffeineMetric = 0.obs;
  final RxInt sportMetric = 0.obs;
  final RxInt hydrationMetric = 0.obs;
  final RxInt nutritionMetric = 0.obs;
  final RxInt workFitMetric = 0.obs;

  // Circadian Stability metrics
  final RxInt circadianScore = 0.obs;
  final RxString circadianChange = ''.obs;

  // Sleep Duration metrics
  final RxString sleepDurationValue = ''.obs;
  final RxList<double> sleepDurationData = <double>[].obs;

  // Recovery metrics
  final RxInt recoveryScore = 0.obs;
  final RxInt recoveryChange = 0.obs;
  final RxList<double> recoveryData = <double>[].obs;

  // Fatigue Prediction metrics
  final RxString fatigueExpectedTime = ''.obs;
  final RxList<double> fatigueWeeklyData = <double>[].obs;

  // Sleep Debt metrics
  final RxString sleepDebtValue = ''.obs;
  final RxString sleepDebtChange = ''.obs;
  final RxDouble sleepDebtProgress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
    try {
      isLoading.value = true;
      final result = await _analyticsService.getAnalytics(period: apiPeriod);
      if (result != null) {
        _updateMetrics(result);
      } else {
        debugPrint("Analytics data not found, setting mock data");
        // _setMockData(selectedPeriod.value);
      }
    } catch (e) {
      debugPrint("Error loading analytics: $e");
      debugPrint("Setting mock data");
      // _setMockData(selectedPeriod.value);
    } finally {
      isLoading.value = false;
    }
  }

  void _updateMetrics(DashboardAnalyticsModel analytics) {
    globalScore.value = analytics.globalRhythmScore?.average ?? 0;
    sleepMetric.value = analytics.avgScores?.sleepScore ?? 0;
    caffeineMetric.value = analytics.avgScores?.caffeineScore ?? 0;
    sportMetric.value = analytics.avgScores?.sportScore ?? 0;
    hydrationMetric.value = analytics.avgScores?.hydrationScore ?? 0;
    nutritionMetric.value = analytics.avgScores?.nutritionScore ?? 0;
    workFitMetric.value = analytics.avgScores?.workFitScore ?? 0;

    circadianScore.value = analytics.circadianStability?.latest ?? 0;
    circadianChange.value = analytics.circadianStability?.label ?? '';

    sleepDurationValue.value = analytics.sleepDuration?.avgDisplay ?? '';
    if (analytics.sleepDuration?.trend != null &&
        analytics.sleepDuration!.trend!.isNotEmpty) {
      final trendList = analytics.sleepDuration!.trend!;
      final List<double> normalized = trendList.map((t) {
        final mins = t.durationMinutes ?? 0;
        return (mins / 720.0) * 1.5.clamp(0.0, 1.5);
      }).toList();
      sleepDurationData.assignAll(normalized);
      debugPrint(
        " duration minute length: ${analytics.sleepDuration?.trend!.length.toString()}",
      );
      debugPrint("sleep duration normalized: $normalized");
    }

    recoveryScore.value = analytics.recovery?.latest ?? 0;
    recoveryChange.value = analytics.recovery?.diff ?? 0;

    // Map recoveryData from scoreTrend list using globalRhythmScore values normalized
    if (analytics.scoreTrend != null && analytics.scoreTrend!.isNotEmpty) {
      final List<double> trends = analytics.scoreTrend!.map((t) {
        final score = t.recoveryScore ?? 0;
        return (score / 15.0).clamp(0.0, 2.0);
      }).toList();
      recoveryData.assignAll(trends);
      debugPrint(" recoveryData: $trends");
    }

    sleepDebtValue.value = analytics.sleepDebt7d?.display ?? '';
    sleepDebtChange.value = analytics.sleepDebt7d?.diffDisplay ?? '';
    if (analytics.sleepDebt7d?.minutes != null) {
      sleepDebtProgress.value = (analytics.sleepDebt7d!.minutes! / 480.0).clamp(
        0.0,
        1.0,
      );
      print("sleep debt: ${analytics.sleepDebt7d!.minutes!.toString()}");
      print("sleep debt progress: ${sleepDebtProgress.value.toString()}");
    }

    fatigueExpectedTime.value = analytics.fatiguePrediction?.expectedAt ?? '';
    if (analytics.weeklyBlocksfatigue != null &&
        analytics.weeklyBlocksfatigue!.isNotEmpty) {
      final List<double> fatigueScores = analytics.weeklyBlocksfatigue!.map((
        block,
      ) {
        final score = block.score ?? 0;
        return (score / 100.0).clamp(0.0, 1.0);
      }).toList();
      fatigueWeeklyData.assignAll(fatigueScores);
    }
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
    loadAnalytics();
  }

  // void _setMockData(String period) {
  //   if (period == '7d') {
  //     globalScore.value = 69;
  //     sleepMetric.value = 88;
  //     caffeineMetric.value = 45;
  //     sportMetric.value = 64;
  //     hydrationMetric.value = 72;
  //     nutritionMetric.value = 67;
  //     workFitMetric.value = 80;
  //     circadianScore.value = 82;
  //     circadianChange.value = '+6 vs last week';
  //     sleepDurationValue.value = '6h 58m';
  //     sleepDurationData.assignAll([0.3, 0.5, 0.4, 0.45, 0.25, 0.6, 0.4]);
  //     recoveryScore.value = 78;
  //     recoveryChange.value = 4;
  //     recoveryData.assignAll([0.2, 0.35, 0.28, 0.35, 0.28, 0.45, 0.48]);
  //     fatigueWeeklyData.assignAll([0.35, 0.7, 0.95, 0.7, 0.35, 0.15, 0.35]);
  //     sleepDebtValue.value = '1h 18m';
  //     sleepDebtChange.value = '-35m';
  //     sleepDebtProgress.value = 0.35;
  //   } else if (period == '30d') {
  //     globalScore.value = 72;
  //     sleepMetric.value = 82;
  //     caffeineMetric.value = 50;
  //     sportMetric.value = 70;
  //     hydrationMetric.value = 68;
  //     nutritionMetric.value = 75;
  //     workFitMetric.value = 85;
  //     circadianScore.value = 79;
  //     circadianChange.value = '-2 vs last month';
  //     sleepDurationValue.value = '7h 12m';
  //     sleepDurationData.assignAll([0.4, 0.35, 0.6, 0.55, 0.4, 0.7, 0.55]);
  //     recoveryScore.value = 75;
  //     recoveryChange.value = -2;
  //     recoveryData.assignAll([0.3, 0.4, 0.35, 0.42, 0.3, 0.55, 0.5]);
  //     fatigueWeeklyData.assignAll([0.4, 0.65, 0.8, 0.65, 0.4, 0.25, 0.4]);
  //     sleepDebtValue.value = '0h 45m';
  //     sleepDebtChange.value = '-15m';
  //     sleepDebtProgress.value = 0.22;
  //   } else if (period == '90d') {
  //     globalScore.value = 75;
  //     sleepMetric.value = 85;
  //     caffeineMetric.value = 40;
  //     sportMetric.value = 75;
  //     hydrationMetric.value = 78;
  //     nutritionMetric.value = 70;
  //     workFitMetric.value = 82;
  //     circadianScore.value = 85;
  //     circadianChange.value = '+8 vs last period';
  //     sleepDurationValue.value = '7h 05m';
  //     sleepDurationData.assignAll([0.45, 0.55, 0.5, 0.65, 0.3, 0.55, 0.6]);
  //     recoveryScore.value = 80;
  //     recoveryChange.value = 5;
  //     recoveryData.assignAll([0.35, 0.45, 0.4, 0.5, 0.35, 0.6, 0.55]);
  //     fatigueWeeklyData.assignAll([0.3, 0.6, 0.75, 0.6, 0.3, 0.2, 0.3]);
  //     sleepDebtValue.value = '0h 58m';
  //     sleepDebtChange.value = '-22m';
  //     sleepDebtProgress.value = 0.28;
  //   } else if (period == '365d') {
  //     globalScore.value = 78;
  //     sleepMetric.value = 80;
  //     caffeineMetric.value = 35;
  //     sportMetric.value = 78;
  //     hydrationMetric.value = 82;
  //     nutritionMetric.value = 73;
  //     workFitMetric.value = 84;
  //     circadianScore.value = 88;
  //     circadianChange.value = '+12 vs last year';
  //     sleepDurationValue.value = '7h 20m';
  //     sleepDurationData.assignAll([0.5, 0.6, 0.55, 0.7, 0.45, 0.65, 0.7]);
  //     recoveryScore.value = 82;
  //     recoveryChange.value = 8;
  //     recoveryData.assignAll([0.4, 0.5, 0.45, 0.55, 0.4, 0.65, 0.6]);
  //     fatigueWeeklyData.assignAll([0.3, 0.55, 0.7, 0.55, 0.3, 0.18, 0.3]);
  //     sleepDebtValue.value = '0h 30m';
  //     sleepDebtChange.value = '-45m';
  //     sleepDebtProgress.value = 0.15;
  //   }
  // }
}
