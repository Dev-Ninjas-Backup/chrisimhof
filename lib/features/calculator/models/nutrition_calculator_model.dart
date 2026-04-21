class NutritionCalculatorRequest {
  final int mealsPerDay;
  final bool hadMealToday;
  final int desiredMealCount;
  final String firstMealTime;
  final String lastMealTime;

  NutritionCalculatorRequest({
    required this.mealsPerDay,
    required this.hadMealToday,
    required this.desiredMealCount,
    required this.firstMealTime,
    required this.lastMealTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'mealsPerDay': mealsPerDay,
      'hadMealToday': hadMealToday,
      'desiredMealCount': desiredMealCount,
      'firstMealTime': firstMealTime,
      'lastMealTime': lastMealTime,
    };
  }
}

class NutritionCalculatorResponse {
  final bool success;
  final String message;
  final NutritionCalculatorData? data;

  NutritionCalculatorResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory NutritionCalculatorResponse.fromJson(Map<String, dynamic> json) {
    return NutritionCalculatorResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      data: json['sessionId'] != null
          ? NutritionCalculatorData.fromJson(json)
          : null,
    );
  }
}

class NutritionCalculatorData {
  final String sessionId;
  final List<String> completedSteps;
  final String justCompleted;
  final String nextStep;
  final bool isReadyToCalculate;

  NutritionCalculatorData({
    required this.sessionId,
    required this.completedSteps,
    required this.justCompleted,
    required this.nextStep,
    required this.isReadyToCalculate,
  });

  factory NutritionCalculatorData.fromJson(Map<String, dynamic> json) {
    return NutritionCalculatorData(
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
