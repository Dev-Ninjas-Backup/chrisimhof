class DashboardAnalyticsModel {
  String? period;
  int? totalDays;
  GlobalRhythmScore? globalRhythmScore;
  AvgScores? avgScores;
  CircadianStability? circadianStability;
  SleepDuration? sleepDuration;
  SleepDebt7d? sleepDebt7d;
  Recovery? recovery;
  List<WeeklyBlock>? weeklyBlocks;
  List<ScoreTrend>? scoreTrend;
  FatiguePrediction? fatiguePrediction;
  List<WeeklyBlock>? weeklyBlocksfatigue;

  DashboardAnalyticsModel({
    this.period,
    this.totalDays,
    this.globalRhythmScore,
    this.avgScores,
    this.circadianStability,
    this.sleepDuration,
    this.sleepDebt7d,
    this.recovery,
    this.weeklyBlocks,
    this.scoreTrend,
    this.fatiguePrediction,
    this.weeklyBlocksfatigue,
  });

  factory DashboardAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return DashboardAnalyticsModel(
      period: json['period'],
      totalDays: json['totalDays'],
      globalRhythmScore: json['globalRhythmScore'] != null
          ? GlobalRhythmScore.fromJson(json['globalRhythmScore'])
          : null,
      avgScores: json['avgScores'] != null
          ? AvgScores.fromJson(json['avgScores'])
          : null,
      circadianStability: json['circadianStability'] != null
          ? CircadianStability.fromJson(json['circadianStability'])
          : null,
      sleepDuration: json['sleepDuration'] != null
          ? SleepDuration.fromJson(json['sleepDuration'])
          : null,
      sleepDebt7d: json['sleepDebt7d'] != null
          ? SleepDebt7d.fromJson(json['sleepDebt7d'])
          : null,
      recovery: json['recovery'] != null
          ? Recovery.fromJson(json['recovery'])
          : null,
      weeklyBlocks: json['weeklyBlocks'] != null
          ? (json['weeklyBlocks'] as List)
              .map((e) => WeeklyBlock.fromJson(e))
              .toList()
          : null,
      scoreTrend: json['scoreTrend'] != null
          ? (json['scoreTrend'] as List)
              .map((e) => ScoreTrend.fromJson(e))
              .toList()
          : null,
      fatiguePrediction: json['fatiguePrediction'] != null
          ? FatiguePrediction.fromJson(json['fatiguePrediction'])
          : null,
      weeklyBlocksfatigue: json['weeklyBlocksfatigue'] != null
          ? (json['weeklyBlocksfatigue'] as List)
              .map((e) => WeeklyBlock.fromJson(e))
              .toList()
          : null,
    );
  }
}

class GlobalRhythmScore {
  int? average;
  int? latest;
  int? highest;

  GlobalRhythmScore({
    this.average,
    this.latest,
    this.highest,
  });

  factory GlobalRhythmScore.fromJson(Map<String, dynamic> json) {
    return GlobalRhythmScore(
      average: json['average'],
      latest: json['latest'],
      highest: json['highest'],
    );
  }
}

class AvgScores {
  int? sleepScore;
  int? hydrationScore;
  int? caffeineScore;
  int? nutritionScore;
  int? sportScore;
  int? workFitScore;

  AvgScores({
    this.sleepScore,
    this.hydrationScore,
    this.caffeineScore,
    this.nutritionScore,
    this.sportScore,
    this.workFitScore,
  });

  factory AvgScores.fromJson(Map<String, dynamic> json) {
    return AvgScores(
      sleepScore: json['sleepScore'],
      hydrationScore: json['hydrationScore'],
      caffeineScore: json['caffeineScore'],
      nutritionScore: json['nutritionScore'],
      sportScore: json['sportScore'],
      workFitScore: json['workFitScore'],
    );
  }
}

class CircadianStability {
  int? latest;
  int? diff;
  String? label;

  CircadianStability({
    this.latest,
    this.diff,
    this.label,
  });

  factory CircadianStability.fromJson(Map<String, dynamic> json) {
    return CircadianStability(
      latest: json['latest'],
      diff: json['diff'],
      label: json['label'],
    );
  }
}

class SleepDuration {
  int? avgMinutes;
  String? avgDisplay;
  List<SleepDurationTrend>? trend;

  SleepDuration({
    this.avgMinutes,
    this.avgDisplay,
    this.trend,
  });

  factory SleepDuration.fromJson(Map<String, dynamic> json) {
    return SleepDuration(
      avgMinutes: json['avgMinutes'],
      avgDisplay: json['avgDisplay'],
      trend: json['trend'] != null
          ? (json['trend'] as List)
              .map((e) => SleepDurationTrend.fromJson(e))
              .toList()
          : null,
    );
  }
}

class SleepDurationTrend {
  String? date;
  int? durationMinutes;
  String? durationDisplay;

  SleepDurationTrend({
    this.date,
    this.durationMinutes,
    this.durationDisplay,
  });

  factory SleepDurationTrend.fromJson(Map<String, dynamic> json) {
    return SleepDurationTrend(
      date: json['date'],
      durationMinutes: json['durationMinutes'],
      durationDisplay: json['durationDisplay'],
    );
  }
}

class SleepDebt7d {
  int? minutes;
  String? display;
  int? diff;
  String? diffDisplay;

  SleepDebt7d({
    this.minutes,
    this.display,
    this.diff,
    this.diffDisplay,
  });

  factory SleepDebt7d.fromJson(Map<String, dynamic> json) {
    return SleepDebt7d(
      minutes: json['minutes'],
      display: json['display'],
      diff: json['diff'],
      diffDisplay: json['diffDisplay'],
    );
  }
}

class Recovery {
  int? latest;
  int? diff;
  String? label;

  Recovery({
    this.latest,
    this.diff,
    this.label,
  });

  factory Recovery.fromJson(Map<String, dynamic> json) {
    return Recovery(
      latest: json['latest'],
      diff: json['diff'],
      label: json['label'],
    );
  }
}

class WeeklyBlock {
  String? date;
  int? score;
  String? colorTier;
  String? shiftType;

  WeeklyBlock({
    this.date,
    this.score,
    this.colorTier,
    this.shiftType,
  });

  factory WeeklyBlock.fromJson(Map<String, dynamic> json) {
    return WeeklyBlock(
      date: json['date'],
      score: json['score'],
      colorTier: json['colorTier'],
      shiftType: json['shiftType'],
    );
  }
}

class ScoreTrend {
  String? date;
  int? globalRhythmScore;
  int? sleepScore;
  int? hydrationScore;
  int? caffeineScore;
  int? nutritionScore;
  int? recoveryScore;
  int? sportScore;
  int? workFitScore;

  ScoreTrend({
    this.date,
    this.globalRhythmScore,
    this.sleepScore,
    this.hydrationScore,
    this.caffeineScore,
    this.nutritionScore,
    this.recoveryScore,
    this.sportScore,
    this.workFitScore,
  });

  factory ScoreTrend.fromJson(Map<String, dynamic> json) {
    return ScoreTrend(
      date: json['date'],
      globalRhythmScore: json['globalRhythmScore'],
      sleepScore: json['sleepScore'],
      hydrationScore: json['hydrationScore'],
      caffeineScore: json['caffeineScore'],
      nutritionScore: json['nutritionScore'],
      recoveryScore: json['recoveryScore'],
      sportScore: json['sportScore'],
      workFitScore: json['workFitScore'],
    );
  }
}

class FatiguePrediction {
  int? riskScore;
  String? expectedAt;
  String? message;

  FatiguePrediction({
    this.riskScore,
    this.expectedAt,
    this.message,
  });

  factory FatiguePrediction.fromJson(Map<String, dynamic> json) {
    return FatiguePrediction(
      riskScore: json['riskScore'],
      expectedAt: json['expectedAt'],
      message: json['message'],
    );
  }
}