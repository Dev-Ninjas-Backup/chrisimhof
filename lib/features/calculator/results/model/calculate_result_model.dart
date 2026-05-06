class CalculateResultResponse {
  final String id;
  final int overallScore;
  final ScoreBreakdown scoreBreakdown;
  final List<ApiRecommendation> recommendations;
  final String createdAt;

  CalculateResultResponse({
    required this.id,
    required this.overallScore,
    required this.scoreBreakdown,
    required this.recommendations,
    required this.createdAt,
  });

  factory CalculateResultResponse.fromJson(Map<String, dynamic> json) =>
      CalculateResultResponse(
        id: json['id'] as String? ?? '',
        overallScore: json['overallScore'] as int? ?? 0,
        scoreBreakdown: ScoreBreakdown.fromJson(
          json['scoreBreakdown'] as Map<String, dynamic>? ?? {},
        ),
        recommendations: (json['recommendations'] as List<dynamic>? ?? [])
            .map(
              (e) => ApiRecommendation.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList(),
        createdAt: json['createdAt'] as String? ?? '',
      );

  @override
  String toString() =>
      'CalculateResultResponse(id: $id, overallScore: $overallScore, recommendations: ${recommendations.length})';
}

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

  factory ScoreBreakdown.fromJson(Map<String, dynamic> json) => ScoreBreakdown(
    sleep: json['sleep'] as int? ?? 0,
    nutrition: json['nutrition'] as int? ?? 0,
    hydration: json['hydration'] as int? ?? 0,
    caffeine: json['caffeine'] as int? ?? 0,
    activity: json['activity'] as int? ?? 0,
    recovery: json['recovery'] as int? ?? 0,
  );
}

class ApiRecommendation {
  final String id;
  final String category;
  final String title;
  final String body;
  final int priority;
  final bool isPremium;

  ApiRecommendation({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.priority,
    required this.isPremium,
  });

  factory ApiRecommendation.fromJson(Map<String, dynamic> json) =>
      ApiRecommendation(
        id: json['id'] as String? ?? '',
        category: json['category'] as String? ?? '',
        title: json['title'] as String? ?? '',
        body: json['body'] as String? ?? '',
        priority: json['priority'] as int? ?? 0,
        isPremium: json['isPremium'] as bool? ?? false,
      );
}

class ApiMetric {
  final String title;
  final int score;
  final String category;

  ApiMetric({required this.title, required this.score, required this.category});

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
