class CalculatorSessionResponse {
  final bool success;
  final String message;
  final CalculatorSession data;

  CalculatorSessionResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CalculatorSessionResponse.fromJson(Map<String, dynamic> json) {
    return CalculatorSessionResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      data: CalculatorSession.fromJson(json),
    );
  }
}

class CalculatorSession {
  final String? sessionId;
  final List<String> completedSteps;
  final String nextStep;
  final bool isFinalized;
  final bool isReadyToCalculate;
  final bool prefilled;
  final dynamic data;

  CalculatorSession({
    this.sessionId,
    required this.completedSteps,
    required this.nextStep,
    required this.isFinalized,
    required this.isReadyToCalculate,
    required this.prefilled,
    this.data,
  });

  factory CalculatorSession.fromJson(Map<String, dynamic> json) {
    return CalculatorSession(
      sessionId: json['sessionId'],
      completedSteps: json['completedSteps'] != null
          ? List<String>.from(json['completedSteps'] as List)
          : [],
      nextStep: json['nextStep'] ?? 'sleep',
      isFinalized: json['isFinalized'] ?? false,
      isReadyToCalculate: json['isReadyToCalculate'] ?? false,
      prefilled: json['prefilled'] ?? false,
      data: json['data'],
    );
  }
}
