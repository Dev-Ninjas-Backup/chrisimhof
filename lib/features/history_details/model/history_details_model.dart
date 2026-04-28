import 'package:flutter/material.dart';

// --------------- HistoryDetailsResponse ---------------

class HistoryDetailsResponse {
  final String id;
  final int overallScore;
  final ScoreBreakdown scoreBreakdown;
  final List<HistoryRecommendation> recommendations;
  final List<ActivityItem> activityItems;
  final List<WeeklyScore> weeklyScores;
  final String createdAt;

  HistoryDetailsResponse({
    required this.id,
    required this.overallScore,
    required this.scoreBreakdown,
    required this.recommendations,
    required this.activityItems,
    required this.weeklyScores,
    required this.createdAt,
  });

  factory HistoryDetailsResponse.fromJson(Map<String, dynamic> json) {
    // Map result.scoreBreakdown
    final resultJson = json['result'] as Map<String, dynamic>? ?? {};
    final scoreBreakdownJson =
        resultJson['scoreBreakdown'] as Map<String, dynamic>? ?? {};

    // Map recommendations from result.recommendations
    final rawRecs =
        resultJson['recommendations'] as List<dynamic>? ?? [];

    // Build ActivityItems from result.napAnalysis or fall back to empty
    // The API does not return activityItems directly — kept as empty so the
    // UI degrades gracefully. Swap the body below if the endpoint adds them.
    final List<ActivityItem> activityItems = [];

    // Build WeeklyScores — not present in the current API shape either.
    final List<WeeklyScore> weeklyScores = [];

    return HistoryDetailsResponse(
      id: json['id'] as String? ?? '',
      overallScore: json['overallScore'] as int? ?? 0,
      scoreBreakdown: ScoreBreakdown.fromJson(scoreBreakdownJson),
      recommendations: rawRecs
          .map((e) =>
              HistoryRecommendation.fromJson(e as Map<String, dynamic>))
          .toList(),
      activityItems: activityItems,
      weeklyScores: weeklyScores,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  @override
  String toString() =>
      'HistoryDetailsResponse(id: $id, overallScore: $overallScore, '
      'recommendations: ${recommendations.length})';
}

// --------------- ScoreBreakdown ---------------

class ScoreBreakdown {
  final int sleep;
  final int nutrition;
  final int hydration;
  final int caffeine;

  ScoreBreakdown({
    required this.sleep,
    required this.nutrition,
    required this.hydration,
    required this.caffeine,
  });

  factory ScoreBreakdown.fromJson(Map<String, dynamic> json) {
    return ScoreBreakdown(
      sleep: json['sleep'] as int? ?? 0,
      nutrition: json['nutrition'] as int? ?? 0,
      hydration: json['hydration'] as int? ?? 0,
      caffeine: json['caffeine'] as int? ?? 0,
    );
  }
}

// --------------- HistoryRecommendation ---------------

class HistoryRecommendation {
  final String id;
  final String category;
  final String title;
  final String body;
  final int priority;
  final bool isPremium;

  HistoryRecommendation({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.priority,
    required this.isPremium,
  });

  factory HistoryRecommendation.fromJson(Map<String, dynamic> json) {
    return HistoryRecommendation(
      id: json['id'] as String? ?? '',
      category: json['category'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      priority: json['priority'] as int? ?? 0,
      isPremium: json['isPremium'] as bool? ?? false,
    );
  }
}

// --------------- HistoryMetric ---------------

class HistoryMetric {
  final String title;
  final int score;
  final String category;

  HistoryMetric({
    required this.title,
    required this.score,
    required this.category,
  });

  String get iconKey {
    switch (category.toLowerCase()) {
      case 'sleep':
        return 'sleep';
      case 'hydration':
        return 'hydration';
      case 'caffeine':
        return 'caffeine';
      case 'nutrition':
        return 'nutrition';
      default:
        return 'circle';
    }
  }
}

// --------------- ActivityItem ---------------

class ActivityItem {
  final String title;
  final Color color;
  final double percent;

  const ActivityItem({
    required this.title,
    required this.color,
    required this.percent,
  });

  String get percentLabel => '${percent.round()}%';
}

// --------------- WeeklyScore ---------------

class WeeklyScore {
  final int dayIndex; // 0 = Sun, 1 = Mon, ... 6 = Sat
  final double score;

  const WeeklyScore({
    required this.dayIndex,
    required this.score,
  });
}

// --------------- Static mock data (kept for offline/dev use) ---------------

final mockHistoryDetailsData = HistoryDetailsResponse(
  id: 'history_001',
  overallScore: 78,
  scoreBreakdown: ScoreBreakdown(
    sleep: 85,
    nutrition: 72,
    hydration: 80,
    caffeine: 68,
  ),
  activityItems: [
    const ActivityItem(title: 'Work', percent: 35, color: Color(0xFF111827)),
    const ActivityItem(title: 'Sleep', percent: 30, color: Color(0xFF006E4A)),
    const ActivityItem(title: 'Exercise', percent: 20, color: Color(0xFF34D399)),
    const ActivityItem(title: 'Meals', percent: 10, color: Color(0xFFD5D7DA)),
    const ActivityItem(title: 'Free time', percent: 5, color: Color(0xFF535862)),
  ],
  recommendations: [
    HistoryRecommendation(
      id: 'rec_001',
      category: 'sleep',
      title: 'Improve Your Sleep Quality',
      body: 'Try to maintain a consistent sleep schedule. Aim for 7-9 hours of sleep each night and avoid screens 30 minutes before bed.',
      priority: 1,
      isPremium: false,
    ),
    HistoryRecommendation(
      id: 'rec_002',
      category: 'hydration',
      title: 'Stay Hydrated Throughout the Day',
      body: 'Drink at least 8 glasses of water daily. Spread your intake evenly throughout the day and increase during exercise.',
      priority: 2,
      isPremium: false,
    ),
    HistoryRecommendation(
      id: 'rec_003',
      category: 'caffeine',
      title: 'Moderate Your Caffeine Intake',
      body: 'Limit caffeine consumption to before 2 PM to avoid sleep disruption. Consider reducing your daily intake by 25%.',
      priority: 3,
      isPremium: false,
    ),
  ],
  weeklyScores: const [
    WeeklyScore(dayIndex: 0, score: 65),
    WeeklyScore(dayIndex: 1, score: 72),
    WeeklyScore(dayIndex: 2, score: 68),
    WeeklyScore(dayIndex: 3, score: 81),
    WeeklyScore(dayIndex: 4, score: 75),
    WeeklyScore(dayIndex: 5, score: 78),
    WeeklyScore(dayIndex: 6, score: 85),
  ],
  createdAt: '2024-04-28T10:30:00Z',
);