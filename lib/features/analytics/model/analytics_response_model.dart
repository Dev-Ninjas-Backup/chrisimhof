class AnalyticsResponseModel {
  final String period;
  final bool isPremium;
  final int totalCalculations;
  final int highestScore;
  final int avgScore;
  final List<AnalyticsScorePoint> weeklyScores;
  final List<SleepTrendPoint> sleepTrend;
  final WellnessRadar wellnessRadar;
  final ActivitySplit activitySplit;
  final CircadianAnalysis? circadianAnalysis;

  const AnalyticsResponseModel({
    required this.period,
    required this.isPremium,
    required this.totalCalculations,
    required this.highestScore,
    required this.avgScore,
    required this.weeklyScores,
    required this.sleepTrend,
    required this.wellnessRadar,
    required this.activitySplit,
    this.circadianAnalysis,
  });

  factory AnalyticsResponseModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsResponseModel(
      period: json['period']?.toString() ?? '',
      isPremium: json['isPremium'] == true,
      totalCalculations: _toInt(json['totalCalculations']),
      highestScore: _toInt(json['highestScore']),
      avgScore: _toInt(json['avgScore']),
      weeklyScores: (json['weeklyScores'] as List<dynamic>? ?? [])
          .map((item) => AnalyticsScorePoint.fromJson(item))
          .toList(),
      sleepTrend: (json['sleepTrend'] as List<dynamic>? ?? [])
          .map((item) => SleepTrendPoint.fromJson(item))
          .toList(),
      wellnessRadar: WellnessRadar.fromJson(
        json['wellnessRadar'] as Map<String, dynamic>? ?? const {},
      ),
      activitySplit: ActivitySplit.fromJson(
        json['activitySplit'] as Map<String, dynamic>? ?? const {},
      ),
      circadianAnalysis: json['circadianAnalysis'] != null
          ? CircadianAnalysis.fromJson(
              json['circadianAnalysis'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class CircadianPoint {
  final int hour;
  final double avgScore;
  final int sampleCount;

  const CircadianPoint({
    required this.hour,
    required this.avgScore,
    required this.sampleCount,
  });

  factory CircadianPoint.fromJson(Map<String, dynamic> json) {
    return CircadianPoint(
      hour: _toInt(json['hour']),
      avgScore: _toDouble(json['avgScore']),
      sampleCount: _toInt(json['sampleCount']),
    );
  }
}

class CircadianAnalysis {
  final List<CircadianPoint> data;
  final int? peakHour;
  final int? peakScore;
  final String? insight;

  const CircadianAnalysis({
    required this.data,
    this.peakHour,
    this.peakScore,
    this.insight,
  });

  factory CircadianAnalysis.fromJson(Map<String, dynamic> json) {
    final dataList = (json['data'] as List<dynamic>? ?? [])
        .map((item) => CircadianPoint.fromJson(item as Map<String, dynamic>))
        .toList();

    return CircadianAnalysis(
      data: dataList,
      peakHour: json['peakHour'] != null ? _toInt(json['peakHour']) : null,
      peakScore: json['peakScore'] != null ? _toInt(json['peakScore']) : null,
      insight: json['insight']?.toString(),
    );
  }
}

class AnalyticsScorePoint {
  final DateTime? date;
  final double overallScore;

  const AnalyticsScorePoint({required this.date, required this.overallScore});

  factory AnalyticsScorePoint.fromJson(Map<String, dynamic> json) {
    return AnalyticsScorePoint(
      date: DateTime.tryParse(json['date']?.toString() ?? ''),
      overallScore: _toDouble(json['overallScore']),
    );
  }
}

class SleepTrendPoint {
  final DateTime? date;
  final double sleepHours;

  const SleepTrendPoint({required this.date, required this.sleepHours});

  factory SleepTrendPoint.fromJson(Map<String, dynamic> json) {
    return SleepTrendPoint(
      date: DateTime.tryParse(json['date']?.toString() ?? ''),
      sleepHours: _toDouble(json['sleepHours']),
    );
  }
}

class WellnessRadar {
  final double sleep;
  final double nutrition;
  final double hydration;
  final double caffeine;
  final double activity;
  final double recovery;
  final double maxValue;

  const WellnessRadar({
    required this.sleep,
    required this.nutrition,
    required this.hydration,
    required this.caffeine,
    required this.activity,
    required this.recovery,
    required this.maxValue,
  });

  factory WellnessRadar.fromJson(Map<String, dynamic> json) {
    return WellnessRadar(
      sleep: _toDouble(json['sleep']),
      nutrition: _toDouble(json['nutrition']),
      hydration: _toDouble(json['hydration']),
      caffeine: _toDouble(json['caffeine']),
      activity: _toDouble(json['activity']),
      recovery: _toDouble(json['recovery']),
      maxValue: _toDouble(json['maxValue'], fallback: 100),
    );
  }
}

class ActivitySplit {
  final double totalHours;
  final List<ActivitySplitItem> items;
  final bool locked;
  final String? message;

  const ActivitySplit({
    required this.totalHours,
    required this.items,
    this.locked = false,
    this.message,
  });

  factory ActivitySplit.fromJson(Map<String, dynamic> json) {
    final isLocked = json['locked'] == true;
    final message = json['message']?.toString();

    if (isLocked) {
      return ActivitySplit(
        totalHours: _toDouble(json['totalHours'], fallback: 0),
        items: const [],
        locked: true,
        message: message,
      );
    }

    return ActivitySplit(
      totalHours: _toDouble(json['totalHours'], fallback: 24),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => ActivitySplitItem.fromJson(item))
          .toList(),
      locked: false,
      message: message,
    );
  }
}

class ActivitySplitItem {
  final String label;
  final double hours;
  final String color;
  final double percent;

  const ActivitySplitItem({
    required this.label,
    required this.hours,
    required this.color,
    required this.percent,
  });

  factory ActivitySplitItem.fromJson(Map<String, dynamic> json) {
    return ActivitySplitItem(
      label: json['label']?.toString() ?? '',
      hours: _toDouble(json['hours']),
      color: json['color']?.toString() ?? '',
      percent: _toDouble(json['percent']),
    );
  }
}

int _toInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

double _toDouble(dynamic value, {double fallback = 0}) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? fallback;
}
