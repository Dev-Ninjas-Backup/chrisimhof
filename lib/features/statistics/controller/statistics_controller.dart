import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/statistics/model/statistics_model.dart';
import 'package:chrisimhof/features/statistics/service/statistics_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class StatisticsController extends GetxController {
  // Tab Selection: 0 = "Ma journée" (My day), 1 = "Vue d'ensemble" (Overview)
  final RxInt selectedTab = 1.obs;

  final RxString selectedPeriod = '7d'.obs;
  final List<String> periods = ['7d', '30d', '90d', '1y'];

  // Date navigation
  final Rx<DateTime> periodEndDate = DateTime.now().obs;
  final Rx<DateTime> myDaySelectedDate = DateTime.now().obs;

  // Selected event in My Day timeline
  final RxnString selectedTimelineEventId = RxnString();
  final RxMap<String, dynamic> selectedTimelineEvent = <String, dynamic>{}.obs;

  // Trend data for Overview charts
  final RxList<Map<String, dynamic>> rhythmTrendList =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> sleepBarsList =
      <Map<String, dynamic>>[].obs;
  final RxInt totalNapsInPeriod = 0.obs;
  final RxInt globalRhythmDiff = 0.obs;

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

  final Rxn<Map<String, dynamic>> dailyTimelineData = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    loadAnalytics();
    loadDailyTimeline();

    ever(selectedPeriod, (_) => loadAnalytics());
    ever(periodEndDate, (_) => loadAnalytics());
    ever(myDaySelectedDate, (_) => loadDailyTimeline());
    ever(selectedTab, (tab) {
      if (tab == 0) {
        loadDailyTimeline();
      } else {
        loadAnalytics();
      }
    });
  }

  Future<void> loadAnalytics() async {
    try {
      isLoading.value = true;
      final endStr =
          '${periodEndDate.value.year}-${periodEndDate.value.month.toString().padLeft(2, '0')}-${periodEndDate.value.day.toString().padLeft(2, '0')}';
      final result = await _analyticsService.getAnalytics(
        period: apiPeriod,
        endDate: endStr,
      );
      if (result != null) {
        _updateMetrics(result);
      } else {
        _resetMetrics();
      }
    } catch (e) {
      debugPrint("Error loading analytics: $e");
      _resetMetrics();
    } finally {
      isLoading.value = false;
    }
  }

  void _resetMetrics() {
    globalScore.value = 0;
    globalRhythmDiff.value = 0;
    sleepMetric.value = 0;
    caffeineMetric.value = 0;
    sportMetric.value = 0;
    hydrationMetric.value = 0;
    nutritionMetric.value = 0;
    workFitMetric.value = 0;
    circadianScore.value = 0;
    circadianChange.value = '';
    sleepDurationValue.value = '';
    sleepDurationData.clear();
    recoveryScore.value = 0;
    recoveryChange.value = 0;
    recoveryData.clear();
    sleepDebtValue.value = '';
    sleepDebtChange.value = '';
    sleepDebtProgress.value = 0.0;
    fatigueExpectedTime.value = '';
    fatigueWeeklyData.clear();
    rhythmTrendList.clear();
    sleepBarsList.clear();
    totalNapsInPeriod.value = 0;
  }

  Future<void> loadDailyTimeline() async {
    try {
      final dateStr =
          '${myDaySelectedDate.value.year}-${myDaySelectedDate.value.month.toString().padLeft(2, '0')}-${myDaySelectedDate.value.day.toString().padLeft(2, '0')}';
      final tz = await SharedPreferencesHelper.getTimezone();
      final data = await _analyticsService.getDailyTimeline(
        date: dateStr,
        timezone: tz,
      );
      if (data != null) {
        dailyTimelineData.value = data;
      }
    } catch (e) {
      debugPrint("Error loading daily timeline: $e");
    }
  }

  void _updateMetrics(DashboardAnalyticsModel analytics) {
    _resetMetrics();

    globalScore.value = analytics.globalRhythmScore?.average ?? 0;
    globalRhythmDiff.value = analytics.globalRhythmScore?.diff ?? 0;
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
        final mins = t.totalMinutes ?? t.durationMinutes ?? 0;
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

    // Build Rhythm Trend Points for Evolution Line Chart
    final List<Map<String, dynamic>> rhythmPoints = [];
    final daysFrench = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

    if (analytics.scoreTrend != null && analytics.scoreTrend!.isNotEmpty) {
      final list = analytics.scoreTrend!;
      for (int i = 0; i < list.length && i < 7; i++) {
        final st = list[i];
        final dayLabel = daysFrench[i % 7];
        final scoreVal = (st.globalRhythmScore ?? 0).clamp(0, 100);
        rhythmPoints.add({
          'day': dayLabel,
          'score': scoreVal.toDouble(),
          'date': st.date ?? '',
        });
      }
    }
    rhythmTrendList.assignAll(rhythmPoints);

    // Build Sleep Stacked Bars (Main sleep + Naps)
    final List<Map<String, dynamic>> sleepBars = [];
    int napsCount = 0;
    if (analytics.sleepDuration?.trend != null &&
        analytics.sleepDuration!.trend!.isNotEmpty) {
      final trendList = analytics.sleepDuration!.trend!;
      for (int i = 0; i < trendList.length && i < 7; i++) {
        final t = trendList[i];
        final totalMins = t.totalMinutes ?? t.durationMinutes ?? 0;
        final napMins = t.napMinutes ?? 0;
        final mainMins = t.mainSleepMinutes ?? (totalMins - napMins).clamp(0, totalMins);
        if (napMins > 0) napsCount++;
        final dayLabel = (t.dayLabel != null && t.dayLabel!.isNotEmpty)
            ? t.dayLabel!
            : daysFrench[i % 7];
        sleepBars.add({
          'day': dayLabel,
          'mainHours': (mainMins / 60.0).clamp(0.0, 12.0),
          'napHours': (napMins / 60.0).clamp(0.0, 4.0),
          'totalHours': (totalMins / 60.0).clamp(0.0, 12.0),
        });
      }
    }
    totalNapsInPeriod.value = napsCount;
    sleepBarsList.assignAll(sleepBars);
  }

  String get formattedDateRange {
    final end = periodEndDate.value;
    DateTime start;
    switch (selectedPeriod.value) {
      case '7d':
        start = end.subtract(const Duration(days: 6));
        break;
      case '30d':
        start = end.subtract(const Duration(days: 29));
        break;
      case '90d':
        start = end.subtract(const Duration(days: 89));
        break;
      case '1y':
        start = end.subtract(const Duration(days: 364));
        break;
      default:
        start = end.subtract(const Duration(days: 6));
    }

    final isFrench = Get.locale?.languageCode == 'fr';
    final monthsFr = [
      '', 'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    final monthsEn = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final months = isFrench ? monthsFr : monthsEn;

    if (selectedPeriod.value == '1y') {
      return '${start.year} – ${end.year}';
    }

    if (start.month == end.month) {
      return '${start.day} – ${end.day} ${months[end.month]} ${end.year}';
    } else {
      return '${start.day} ${months[start.month]} – ${end.day} ${months[end.month]} ${end.year}';
    }
  }

  String get formattedSingleDay {
    final dt = myDaySelectedDate.value;
    final isFrench = Get.locale?.languageCode == 'fr';
    final monthsFr = [
      '', 'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    final monthsEn = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final months = isFrench ? monthsFr : monthsEn;
    return '${dt.day} ${months[dt.month]} ${dt.year}';
  }

  void previousPeriod() {
    int days = 7;
    if (selectedPeriod.value == '30d') days = 30;
    if (selectedPeriod.value == '90d') days = 90;
    if (selectedPeriod.value == '1y') days = 365;
    periodEndDate.value = periodEndDate.value.subtract(Duration(days: days));
  }

  void nextPeriod() {
    int days = 7;
    if (selectedPeriod.value == '30d') days = 30;
    if (selectedPeriod.value == '90d') days = 90;
    if (selectedPeriod.value == '1y') days = 365;
    final candidate = periodEndDate.value.add(Duration(days: days));
    if (!candidate.isAfter(DateTime.now())) {
      periodEndDate.value = candidate;
    }
  }

  void previousDay() {
    myDaySelectedDate.value = myDaySelectedDate.value.subtract(const Duration(days: 1));
  }

  void nextDay() {
    final candidate = myDaySelectedDate.value.add(const Duration(days: 1));
    if (!candidate.isAfter(DateTime.now())) {
      myDaySelectedDate.value = candidate;
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
