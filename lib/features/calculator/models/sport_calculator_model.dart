class SportRequest {
  final int activityDuration;
  final String activityType;
  final String activityIntensity;
  final String activityTime;

  SportRequest({
    required this.activityDuration,
    required this.activityType,
    required this.activityIntensity,
    required this.activityTime,
  });

  Map<String, dynamic> toJson() => {
    'activityDuration': activityDuration,
    'activityType': activityType,
    'activityIntensity': activityIntensity,
    'activityTime': activityTime,
  };
}

class SportResponse {
  final String sessionId;
  final List<String> completedSteps;
  final String justCompleted;
  final String nextStep;
  final bool isReadyToCalculate;
  final String message;

  SportResponse({
    required this.sessionId,
    required this.completedSteps,
    required this.justCompleted,
    required this.nextStep,
    required this.isReadyToCalculate,
    required this.message,
  });

  factory SportResponse.fromJson(Map<String, dynamic> json) => SportResponse(
    sessionId: json['sessionId'] as String? ?? '',
    completedSteps:
        (json['completedSteps'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [],
    justCompleted: json['justCompleted'] as String? ?? '',
    nextStep: json['nextStep'] as String? ?? '',
    isReadyToCalculate: json['isReadyToCalculate'] as bool? ?? false,
    message: json['message'] as String? ?? '',
  );

  @override
  String toString() {
    return 'SportResponse(sessionId: $sessionId, completedSteps: $completedSteps, justCompleted: $justCompleted, nextStep: $nextStep, isReadyToCalculate: $isReadyToCalculate, message: $message)';
  }
}
