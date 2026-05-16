class ScoreChange {
  final String direction;
  final int percent;
  final String label;

  ScoreChange({
    required this.direction,
    required this.percent,
    required this.label,
  });
  factory ScoreChange.fromJson(Map<String, dynamic> json) {
    return ScoreChange(
      direction: json['direction'] ?? 'up',
      percent: json['percent'] ?? 0,
      label: json['label'] ?? '',
    );
  }
}

class OptimalBedtime {
  final String time;
  final List<String> reasons;
  final String label;
  final String? adjustedLabel;
  final String source;
  final bool sleepAsap;

  OptimalBedtime({
    required this.time,
    this.reasons = const [],
    required this.label,
    this.adjustedLabel,
    required this.source,
    this.sleepAsap = false,
  });

  factory OptimalBedtime.fromJson(Map<String, dynamic> json) {
    return OptimalBedtime(
      time: json['time'] ?? '',
      reasons: (json['reasons'] as List?)?.map((e) => e.toString()).toList() ?? [],
      label: json['label'] ?? '',
      adjustedLabel: json['adjustedLabel'],
      source: json['source'] ?? '',
      sleepAsap: json['sleepAsap'] ?? false,
    );
  }
}

class DashboardModel {
  final int currentScore;
  final String scoreLevel;
  final ScoreChange? scoreChange;
  final DashboardCards cards;
  final List<WeeklyTrendItem> weeklyTrend;
  final int streak;
  final String sleepAdaptationNote;
  final List<DailyRecommendation> dailyRecommendations;
  final OptimalBedtime? optimalBedtime;

  DashboardModel({
    required this.currentScore,
    required this.scoreLevel,
    this.scoreChange,
    this.optimalBedtime,
    required this.cards,
    required this.weeklyTrend,
    required this.streak,
    required this.sleepAdaptationNote,
    required this.dailyRecommendations,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      currentScore: json['currentScore'] ?? 0,
      scoreLevel: json['scoreLevel'] ?? '',
      optimalBedtime: json['optimalBedtime'] != null
          ? OptimalBedtime.fromJson(Map<String, dynamic>.from(json['optimalBedtime']))
          : null,
      scoreChange: json['scoreChange'] != null 
        ? ScoreChange.fromJson(json['scoreChange']) 
        : null,
      cards: DashboardCards.fromJson(json['cards'] ?? {}),
      weeklyTrend: (json['weeklyTrend'] as List?)
              ?.map((item) => WeeklyTrendItem.fromJson(item))
              .toList() ??
          [],
      streak: json['streak'] ?? 0,
      sleepAdaptationNote: json['sleepAdaptationNote'] ?? '',
      dailyRecommendations: (json['dailyRecommendations'] as List?)
              ?.map((item) => DailyRecommendation.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class DashboardCards {
  final CardDetail? sleep;
  final CardDetail? hydration;
  final CardDetail? caffeine;
  final CardDetail? nutrition;
  final CardDetail? activity;
  final CardDetail? recovery;

  DashboardCards({
    this.sleep,
    this.hydration,
    this.caffeine,
    this.nutrition,
    this.activity,
    this.recovery,
  });

  factory DashboardCards.fromJson(Map<String, dynamic> json) {
    return DashboardCards(
      sleep: json['sleep'] != null ? CardDetail.fromJson(json['sleep']) : null,
      hydration: json['hydration'] != null ? CardDetail.fromJson(json['hydration']) : null,
      caffeine: json['caffeine'] != null ? CardDetail.fromJson(json['caffeine']) : null,
      nutrition: json['nutrition'] != null ? CardDetail.fromJson(json['nutrition']) : null,
      activity: json['activity'] != null ? CardDetail.fromJson(json['activity']) : null,
      recovery: json['recovery'] != null ? CardDetail.fromJson(json['recovery']) : null,
    );
  }
}

class CardDetail {
  final int score;
  final String label;
  final String subtitle;
  final Map<String, dynamic> additionalData;

  CardDetail({
    required this.score,
    required this.label,
    required this.subtitle,
    this.additionalData = const {},
  });

  factory CardDetail.fromJson(Map<String, dynamic> json) {
    final additionalData = Map<String, dynamic>.from(json);
    additionalData.removeWhere((key, value) => ['score', 'label', 'subtitle'].contains(key));

    return CardDetail(
      score: json['score'] ?? 0,
      label: json['label'] ?? '',
      subtitle: json['subtitle'] ?? '',
      additionalData: additionalData,
    );
  }
}

class StateIndicators {
  final String sleep;
  final String hydration;
  final String caffeine;
  final String nutrition;
  final String activity;
  final String recovery;

  StateIndicators({
    required this.sleep,
    required this.hydration,
    required this.caffeine,
    required this.nutrition,
    required this.activity,
    required this.recovery,
  });

  factory StateIndicators.fromJson(Map<String, dynamic> json) {
    return StateIndicators(
      sleep: json['sleep'] ?? 'Unknown',
      hydration: json['hydration'] ?? 'Unknown',
      caffeine: json['caffeine'] ?? 'Unknown',
      nutrition: json['nutrition'] ?? 'Unknown',
      activity: json['activity'] ?? 'Unknown',
      recovery: json['recovery'] ?? 'Unknown',
    );
  }
}

class WeeklyTrendItem {
  final DateTime date;
  final int overallScore;
  final Map<String, int> scores;

  WeeklyTrendItem({
    required this.date,
    required this.overallScore,
    required this.scores,
  });

  factory WeeklyTrendItem.fromJson(Map<String, dynamic> json) {
    return WeeklyTrendItem(
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      overallScore: json['overallScore'] ?? 0,
      scores: Map<String, int>.from(json['scores'] ?? {}),
    );
  }
}

class DailyRecommendation {
  final String id;
  final String category;
  final int priority;
  final bool isPremium;
  final String title;
  final String body;

  DailyRecommendation({
    required this.id,
    required this.category,
    required this.priority,
    required this.isPremium,
    required this.title,
    required this.body,
  });

  factory DailyRecommendation.fromJson(Map<String, dynamic> json) {
    return DailyRecommendation(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      priority: json['priority'] ?? 0,
      isPremium: json['isPremium'] ?? false,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }
}
