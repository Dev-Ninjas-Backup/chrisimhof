class RegisterResponseModel {
  final bool success;
  final String message;
  final RegisterData? data;

  RegisterResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? RegisterData.fromJson(json['data']) : null,
    );
  }
}

class RegisterData {
  final RegisterUser? user;
  final String otp;

  RegisterData({required this.user, required this.otp});

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      user: json['user'] != null ? RegisterUser.fromJson(json['user']) : null,
      otp: json['otp'] ?? '',
    );
  }
}

class RegisterUser {
  final String id;
  final String email;
  final String userName;
  final String createdAt;

  RegisterUser({
    required this.id,
    required this.email,
    required this.userName,
    required this.createdAt,
  });

  factory RegisterUser.fromJson(Map<String, dynamic> json) {
    return RegisterUser(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      userName: json['userName'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
