class SleepCalculatorRequest {
  final String wakeUpTime;
  final double sleepHours;
  final double desiredSleepHours;
  final String fatigueLevel;
  final String desiredSleepStart;
  final String desiredWakeTime;
  final List<NapData> naps;

  SleepCalculatorRequest({
    required this.wakeUpTime,
    required this.sleepHours,
    required this.desiredSleepHours,
    required this.fatigueLevel,
    required this.desiredSleepStart,
    required this.desiredWakeTime,
    required this.naps,
  });

  Map<String, dynamic> toJson() {
    return {
      'wakeUpTime': wakeUpTime,
      'sleepHours': sleepHours,
      'desiredSleepHours': desiredSleepHours,
      'fatigueLevel': fatigueLevel,
      'desiredSleepStart': desiredSleepStart,
      'desiredWakeTime': desiredWakeTime,
      'naps': naps.map((nap) => nap.toJson()).toList(),
    };
  }
}

class NapData {
  final String startTime;
  final int durationMin;
  final int order;

  NapData({
    required this.startTime,
    required this.durationMin,
    required this.order,
  });

  Map<String, dynamic> toJson() {
    return {'startTime': startTime, 'durationMin': durationMin, 'order': order};
  }
}

class SleepCalculatorResponse {
  final bool success;
  final String message;
  final SleepCalculatorData? data;

  SleepCalculatorResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SleepCalculatorResponse.fromJson(Map<String, dynamic> json) {
    return SleepCalculatorResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      data: json['sessionId'] != null
          ? SleepCalculatorData.fromJson(json)
          : null,
    );
  }
}

class SleepCalculatorData {
  final String sessionId;
  final List<String> completedSteps;
  final String justCompleted;
  final String nextStep;
  final bool isReadyToCalculate;

  SleepCalculatorData({
    required this.sessionId,
    required this.completedSteps,
    required this.justCompleted,
    required this.nextStep,
    required this.isReadyToCalculate,
  });

  factory SleepCalculatorData.fromJson(Map<String, dynamic> json) {
    return SleepCalculatorData(
      sessionId: json['sessionId'] ?? '',
      completedSteps: json['completedSteps'] != null
          ? List<String>.from(json['completedSteps'] as List)
          : [],
      justCompleted: json['justCompleted'] ?? '',
      nextStep: json['nextStep'] ?? '',
      isReadyToCalculate: json['isReadyToCalculate'] ?? false,
    );
  }
}
