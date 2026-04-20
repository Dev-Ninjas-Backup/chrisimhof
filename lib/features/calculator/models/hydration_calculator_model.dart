class HydrationCalculatorRequest {
  final double waterConsumedL;
  final double waterGoalL;

  HydrationCalculatorRequest({
    required this.waterConsumedL,
    required this.waterGoalL,
  });

  Map<String, dynamic> toJson() {
    return {'waterConsumedL': waterConsumedL, 'waterGoalL': waterGoalL};
  }
}

class HydrationCalculatorResponse {
  final bool success;
  final String message;
  final HydrationCalculatorData? data;

  HydrationCalculatorResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory HydrationCalculatorResponse.fromJson(Map<String, dynamic> json) {
    return HydrationCalculatorResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      data: json['sessionId'] != null
          ? HydrationCalculatorData.fromJson(json)
          : null,
    );
  }
}

class HydrationCalculatorData {
  final String sessionId;
  final List<String> completedSteps;
  final String justCompleted;
  final String nextStep;
  final bool isReadyToCalculate;

  HydrationCalculatorData({
    required this.sessionId,
    required this.completedSteps,
    required this.justCompleted,
    required this.nextStep,
    required this.isReadyToCalculate,
  });

  factory HydrationCalculatorData.fromJson(Map<String, dynamic> json) {
    return HydrationCalculatorData(
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
