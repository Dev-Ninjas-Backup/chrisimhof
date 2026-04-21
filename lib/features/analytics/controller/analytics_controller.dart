import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:chrisimhof/features/analytics/model/analytics_response_model.dart';
import 'package:chrisimhof/features/analytics/service/analytics_service.dart';

class AnalyticsController extends GetxController {
  final AnalyticsService _service = AnalyticsService();
  static const List<String> _weekDayLabels = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  final selectedPeriod = 'Last 7 Days'.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final analyticsData = Rxn<AnalyticsResponseModel>();

  final periods = const ['Last 7 Days', 'Last 30 Days', 'Last 90 Days'];

  static const Map<String, String> _periodQueryMap = {
    'Last 7 Days': '7d',
    'Last 30 Days': '30d',
    'Last 90 Days': '90d',
  };

  @override
  void onInit() {
    super.onInit();
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      analyticsData.value = await _service.getAnalytics(currentPeriodQuery);
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('Analytics error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePeriod(String value) async {
    if (selectedPeriod.value == value) return;
    selectedPeriod.value = value;
    await fetchAnalytics();
  }

  String get currentPeriodQuery =>
      _periodQueryMap[selectedPeriod.value] ?? '7d';

  List<FlSpot> get weeklyScoreSpots {
    final scores = analyticsData.value?.weeklyScores ?? const [];
    if (scores.isEmpty) return const [];

    final groupedScores = <int, List<double>>{};

    for (final item in scores) {
      final index = _weekdayIndex(item.date);
      groupedScores.putIfAbsent(index, () => []).add(item.overallScore);
    }

    return groupedScores.entries.map((entry) {
      final values = entry.value;
      final average =
          values.fold<double>(0, (sum, value) => sum + value) / values.length;
      return FlSpot(entry.key.toDouble(), average);
    }).toList()..sort((a, b) => a.x.compareTo(b.x));
  }

  List<double> get sleepTrendValues {
    final items = analyticsData.value?.sleepTrend ?? const [];
    if (items.isEmpty) return List.filled(_weekDayLabels.length, 0);

    final groupedSleep = <int, List<double>>{};

    for (final item in items) {
      final index = _weekdayIndex(item.date);
      groupedSleep.putIfAbsent(index, () => []).add(item.sleepHours);
    }

    return List.generate(_weekDayLabels.length, (index) {
      final values = groupedSleep[index];
      if (values == null || values.isEmpty) return 0;
      return values.fold<double>(0, (sum, value) => sum + value) /
          values.length;
    });
  }

  List<String> get weeklyLabels => List.unmodifiable(_weekDayLabels);

  List<String> get sleepLabels => List.unmodifiable(_weekDayLabels);

  List<double> get wellnessValues {
    final radar = analyticsData.value?.wellnessRadar;
    if (radar == null) return const [1.5, 1.5, 1.5, 1.5, 1.5, 1.5];

    final maxValue = radar.maxValue <= 0 ? 100.0 : radar.maxValue;

    double normalize(double value) => (value / maxValue * 5).clamp(1.5, 5.0);

    return [
      normalize(radar.sleep),
      normalize(radar.hydration),
      normalize(radar.caffeine),
      normalize(radar.activity),
      normalize(radar.recovery),
      normalize(radar.nutrition),
    ];
  }

  List<AnalyticsActivityItem> get activityItems {
    final items = analyticsData.value?.activitySplit.items ?? const [];
    if (items.isEmpty) return const [];

    return items.map((item) {
      return AnalyticsActivityItem(
        title: item.label,
        color: _parseColor(item.color),
        percent: item.percent,
      );
    }).toList();
  }

  int _weekdayIndex(DateTime? date) {
    if (date == null) return 0;
    return date.weekday % 7;
  }

  Color _parseColor(String hex) {
    final sanitized = hex.replaceFirst('#', '').trim();
    if (sanitized.length != 6) return const Color(0xFF1DB97B);
    final parsedColor = int.tryParse('FF$sanitized', radix: 16);
    if (parsedColor == null) return const Color(0xFF1DB97B);
    return Color(parsedColor);
  }
}

class AnalyticsActivityItem {
  final String title;
  final Color color;
  final double percent;

  const AnalyticsActivityItem({
    required this.title,
    required this.color,
    required this.percent,
  });

  String get percentLabel => '${percent.round()}%';
}
