class WorkCalculatorRequest {
  final String shiftStart;
  final String shiftEnd;
  final int daysWorked;
  final String shiftType;

  WorkCalculatorRequest({
    required this.shiftStart,
    required this.shiftEnd,
    required this.daysWorked,
    required this.shiftType,
  });

  Map<String, dynamic> toJson() {
    return {
      'shiftStart': shiftStart,
      'shiftEnd': shiftEnd,
      'daysWorked': daysWorked,
      'shiftType': shiftType,
    };
  }
}

class WorkCalculatorResponse {
  final bool success;
  final String message;
  final WorkCalculatorData? data;

  WorkCalculatorResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory WorkCalculatorResponse.fromJson(Map<String, dynamic> json) {
    return WorkCalculatorResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      data: json['sessionId'] != null
          ? WorkCalculatorData.fromJson(json)
          : null,
    );
  }
}

class WorkCalculatorData {
  final String sessionId;
  final List<String> completedSteps;
  final String justCompleted;
  final String nextStep;
  final bool isReadyToCalculate;

  WorkCalculatorData({
    required this.sessionId,
    required this.completedSteps,
    required this.justCompleted,
    required this.nextStep,
    required this.isReadyToCalculate,
  });

  factory WorkCalculatorData.fromJson(Map<String, dynamic> json) {
    return WorkCalculatorData(
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
