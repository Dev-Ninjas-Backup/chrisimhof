class ForgotPasswordResponse {
  final bool success;
  final String message;
  final ForgotPasswordData data;

  ForgotPasswordResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ForgotPasswordData.fromJson(
        json['data'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class ForgotPasswordData {
  final String message;

  ForgotPasswordData({
    required this.message,
  });

  factory ForgotPasswordData.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordData(
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
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
