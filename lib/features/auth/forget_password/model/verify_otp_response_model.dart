class VerifyOtpResponseModel {
  final bool success;
  final String message;
  final VerifyOtpData? data;

  VerifyOtpResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? VerifyOtpData.fromJson(json['data']) : null,
    );
  }
}

class VerifyOtpData {
  final VerifyOtpUser? user;
  final String? message;

  VerifyOtpData({required this.user, required this.message});

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpData(
      user: json['user'] != null ? VerifyOtpUser.fromJson(json['user']) : null,
      message: json['massage'] ?? json['message'],
    );
  }
}

class VerifyOtpUser {
  final String id;
  final String email;
  final bool emailVerified;
  final String accountStatus;
  final String plan;

  VerifyOtpUser({
    required this.id,
    required this.email,
    required this.emailVerified,
    required this.accountStatus,
    required this.plan,
  });

  factory VerifyOtpUser.fromJson(Map<String, dynamic> json) {
    return VerifyOtpUser(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      emailVerified: json['emailVerified'] ?? false,
      accountStatus: json['accountStatus'] ?? '',
      plan: json['plan'] ?? '',
    );
  }
}
