import 'package:flutter/material.dart';

class HistoryDetailsResponse {
  final String id;
  final int overallScore;
  final ScoreBreakdown scoreBreakdown;
  final List<HistoryRecommendation> recommendations;
  final List<ActivityItem> activityItems;
  final String createdAt;

  HistoryDetailsResponse({
    required this.id,
    required this.overallScore,
    required this.scoreBreakdown,
    required this.recommendations,
    required this.activityItems,
    required this.createdAt,
  });

  @override
  String toString() =>
      'HistoryDetailsResponse(id: $id, overallScore: $overallScore, recommendations: ${recommendations.length})';
}

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
}

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
}

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

// Static mock data
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
    ActivityItem(
      title: 'Work',
      percent: 35,
      color: const Color(0xFF111827),
    ),
    ActivityItem(
      title: 'Sleep',
      percent: 30,
      color: const Color(0xFF006E4A),
    ),
    ActivityItem(
      title: 'Exercise',
      percent: 20,
      color: const Color(0xFF34D399),
    ),
    ActivityItem(
      title: 'Meals',
      percent: 10,
      color: const Color(0xFFD5D7DA),
    ),
    ActivityItem(
      title: 'Free time',
      percent: 5,
      color: const Color(0xFF535862),
    ),
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
  createdAt: '2024-04-28T10:30:00Z',
);
