class CaffeineIntakeRequest {
  final List<CaffeineIntake> caffeineIntakes;

  CaffeineIntakeRequest({required this.caffeineIntakes});

  Map<String, dynamic> toJson() {
    return {'caffeineIntakes': caffeineIntakes.map((e) => e.toJson()).toList()};
  }
}

class CaffeineIntake {
  final int amountMg;
  final String consumedAt;
  final String drinkType;
  final String drinkName;

  CaffeineIntake({
    required this.amountMg,
    required this.consumedAt,
    required this.drinkType,
    required this.drinkName,
  });

  Map<String, dynamic> toJson() {
    return {
      'amountMg': amountMg,
      'consumedAt': consumedAt,
      'drinkType': drinkType,
      'drinkName': drinkName,
    };
  }
}

class CaffeineIntakeResponse {
  final String sessionId;
  final List<String> completedSteps;
  final String justCompleted;
  final String nextStep;
  final bool isReadyToCalculate;
  final String message;

  CaffeineIntakeResponse({
    required this.sessionId,
    required this.completedSteps,
    required this.justCompleted,
    required this.nextStep,
    required this.isReadyToCalculate,
    required this.message,
  });

  factory CaffeineIntakeResponse.fromJson(Map<String, dynamic> json) {
    return CaffeineIntakeResponse(
      sessionId: json['sessionId'] ?? '',
      completedSteps: List<String>.from(json['completedSteps'] ?? []),
      justCompleted: json['justCompleted'] ?? '',
      nextStep: json['nextStep'] ?? '',
      isReadyToCalculate: json['isReadyToCalculate'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
