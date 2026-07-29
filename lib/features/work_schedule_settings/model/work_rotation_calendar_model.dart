class WorkRotationCalendarDayModel {
  final String date;
  final String shiftType; // 'day', 'evening', 'night', 'off'
  final String shiftStartTime;
  final String shiftEndTime;
  final String derivedWorkTiming;
  final bool isOverride;

  WorkRotationCalendarDayModel({
    required this.date,
    required this.shiftType,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.derivedWorkTiming,
    required this.isOverride,
  });

  factory WorkRotationCalendarDayModel.fromJson(Map<String, dynamic> json) {
    return WorkRotationCalendarDayModel(
      date: json['date']?.toString() ?? '',
      shiftType: json['shiftType']?.toString() ?? 'off',
      shiftStartTime: json['shiftStartTime']?.toString() ?? '',
      shiftEndTime: json['shiftEndTime']?.toString() ?? '',
      derivedWorkTiming: json['derivedWorkTiming']?.toString() ?? '',
      isOverride: json['isOverride'] as bool? ?? false,
    );
  }
}

class WorkRotationCalendarModel {
  final bool hasRotation;
  final List<WorkRotationCalendarDayModel> days;

  WorkRotationCalendarModel({
    required this.hasRotation,
    required this.days,
  });

  factory WorkRotationCalendarModel.fromJson(Map<String, dynamic> json) {
    final bool hasRotation = json['hasRotation'] as bool? ?? false;
    final rawDays = json['days'] as List<dynamic>?;
    final List<WorkRotationCalendarDayModel> daysList = rawDays != null
        ? rawDays
            .whereType<Map<String, dynamic>>()
            .map((e) => WorkRotationCalendarDayModel.fromJson(e))
            .toList()
        : [];
    return WorkRotationCalendarModel(
      hasRotation: hasRotation,
      days: daysList,
    );
  }
}
