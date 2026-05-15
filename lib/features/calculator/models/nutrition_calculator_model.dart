class NutritionCalculatorRequest {
  final bool hadMealToday;
  final int desiredMealCount;
  final String firstMealTime;
  final String lastMealTime;
  final List<NutritionMealRequest> meals;

  NutritionCalculatorRequest({
    required this.hadMealToday,
    required this.desiredMealCount,
    required this.firstMealTime,
    required this.lastMealTime,
    required this.meals,
  });

  Map<String, dynamic> toJson() {
    return {
      'hadMealToday': hadMealToday,
      'desiredMealCount': desiredMealCount,
      'firstMealTime': firstMealTime,
      'lastMealTime': lastMealTime,
      'meals': meals.map((meal) => meal.toJson()).toList(),
    };
  }
}

class NutritionMealRequest {
  final String time;
  final String tag;
  final int order;

  NutritionMealRequest({
    required this.time,
    required this.tag,
    required this.order,
  });

  Map<String, dynamic> toJson() {
    return {'time': time, 'tag': tag, 'order': order};
  }

  factory NutritionMealRequest.fromJson(Map<String, dynamic> json) {
    return NutritionMealRequest(
      time: json['time']?.toString() ?? '00:00',
      tag: json['tag']?.toString() ?? 'LIGHT',
      order: (json['order'] as num?)?.toInt() ?? 1,
    );
  }

  NutritionMealRequest copyWith({String? time, String? tag, int? order}) {
    return NutritionMealRequest(
      time: time ?? this.time,
      tag: tag ?? this.tag,
      order: order ?? this.order,
    );
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
