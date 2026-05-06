class HistoryDetailsResponse {
  final String id;
  final int overallScore;
  final ScoreBreakdown scoreBreakdown;
  final List<HistoryRecommendation> recommendations;
  final String createdAt;

  HistoryDetailsResponse({
    required this.id,
    required this.overallScore,
    required this.scoreBreakdown,
    required this.recommendations,
    required this.createdAt,
  });

  factory HistoryDetailsResponse.fromJson(Map<String, dynamic> json) {
    // Map result.scoreBreakdown
    final resultJson = json['result'] as Map<String, dynamic>? ?? {};
    final scoreBreakdownJson =
        resultJson['scoreBreakdown'] as Map<String, dynamic>? ?? {};

    // Map recommendations from result.recommendations
    final rawRecs = resultJson['recommendations'] as List<dynamic>? ?? [];

    return HistoryDetailsResponse(
      id: json['id'] as String? ?? '',
      overallScore: json['overallScore'] as int? ?? 0,
      scoreBreakdown: ScoreBreakdown.fromJson(scoreBreakdownJson),
      recommendations: rawRecs
          .map((e) => HistoryRecommendation.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}

// --------------- ScoreBreakdown ---------------

class ScoreBreakdown {
  final int sleep;
  final int nutrition;
  final int hydration;
  final int caffeine;
  final int activity;
  final int recovery;

  ScoreBreakdown({
    required this.sleep,
    required this.nutrition,
    required this.hydration,
    required this.caffeine,
    required this.activity,
    required this.recovery,
  });

  factory ScoreBreakdown.fromJson(Map<String, dynamic> json) {
    return ScoreBreakdown(
      sleep: json['sleep'] as int? ?? 0,
      nutrition: json['nutrition'] as int? ?? 0,
      hydration: json['hydration'] as int? ?? 0,
      caffeine: json['caffeine'] as int? ?? 0,
      activity: json['activity'] as int? ?? 0,
      recovery: json['recovery'] as int? ?? 0,
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
      case 'activity':
        return 'activity';
      case 'recovery':
        return 'recovery';
      default:
        return 'circle';
    }
  }
}
