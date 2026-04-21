class CalculatorResultsData {
  final int overallScore;
  final String overallLabel;
  final List<CalculatorResultMetric> metrics;
  final List<CalculatorRecommendation> recommendations;

  const CalculatorResultsData({
    required this.overallScore,
    required this.overallLabel,
    required this.metrics,
    required this.recommendations,
  });

  factory CalculatorResultsData.fromJson(Map<String, dynamic> json) {
    return CalculatorResultsData(
      overallScore: json['overallScore'] ?? 0,
      overallLabel: json['overallLabel'] ?? '',
      metrics: (json['metrics'] as List<dynamic>? ?? [])
          .map(
            (item) => CalculatorResultMetric.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      recommendations: (json['recommendations'] as List<dynamic>? ?? [])
          .map(
            (item) => CalculatorRecommendation.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overallScore': overallScore,
      'overallLabel': overallLabel,
      'metrics': metrics.map((item) => item.toJson()).toList(),
      'recommendations': recommendations.map((item) => item.toJson()).toList(),
    };
  }
}

class CalculatorResultMetric {
  final String title;
  final int score;
  final String detail;
  final String iconKey;

  const CalculatorResultMetric({
    required this.title,
    required this.score,
    required this.detail,
    required this.iconKey,
  });

  factory CalculatorResultMetric.fromJson(Map<String, dynamic> json) {
    return CalculatorResultMetric(
      title: json['title'] ?? '',
      score: json['score'] ?? 0,
      detail: json['detail'] ?? '',
      iconKey: json['iconKey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'score': score,
      'detail': detail,
      'iconKey': iconKey,
    };
  }
}

class CalculatorRecommendation {
  final String title;
  final String headline;
  final String description;
  final String iconKey;

  const CalculatorRecommendation({
    required this.title,
    required this.headline,
    required this.description,
    required this.iconKey,
  });

  factory CalculatorRecommendation.fromJson(Map<String, dynamic> json) {
    return CalculatorRecommendation(
      title: json['title'] ?? '',
      headline: json['headline'] ?? '',
      description: json['description'] ?? '',
      iconKey: json['iconKey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'headline': headline,
      'description': description,
      'iconKey': iconKey,
    };
  }
}
