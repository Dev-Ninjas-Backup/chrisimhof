class HistoryModel {
  final String id;
  final String createdAt;
  final int overallScore;
  final double sleepHours;
  final String shiftType;
  final String fatigueLevel;
  final int sleepScore;
  final int hydrationScore;
  final int caffeineScore;
  final int nutritionScore;
  final int activityScore;
  final int recoveryScore;
  final String summary;
  final String filter;

  HistoryModel({
    required this.id,
    required this.createdAt,
    required this.overallScore,
    required this.sleepHours,
    required this.shiftType,
    required this.fatigueLevel,
    required this.sleepScore,
    required this.hydrationScore,
    required this.caffeineScore,
    required this.nutritionScore,
    required this.activityScore,
    required this.recoveryScore,
    required this.summary,
    required this.filter,
  });

  // Factory method to create from JSON
  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      overallScore: json['overallScore'] ?? 0,
      sleepHours: (json['sleepHours'] ?? 0).toDouble(),
      shiftType: json['shiftType'] ?? '',
      fatigueLevel: json['fatigueLevel'] ?? '',
      sleepScore: json['sleepScore'] ?? 0,
      hydrationScore: json['hydrationScore'] ?? 0,
      caffeineScore: json['caffeineScore'] ?? 0,
      nutritionScore: json['nutritionScore'] ?? 0,
      activityScore: json['activityScore'] ?? 0,
      recoveryScore: json['recoveryScore'] ?? 0,
      summary: json['summary'] ?? '',
      filter: json['filter'] ?? 'recent',
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'overallScore': overallScore,
      'sleepHours': sleepHours,
      'shiftType': shiftType,
      'fatigueLevel': fatigueLevel,
      'sleepScore': sleepScore,
      'hydrationScore': hydrationScore,
      'caffeineScore': caffeineScore,
      'nutritionScore': nutritionScore,
      'activityScore': activityScore,
      'recoveryScore': recoveryScore,
      'summary': summary,
      'filter': filter,
    };
  }
}
