class LoginResponseModel {
  final bool success;
  final String message;
  final LoginData? data;

  LoginResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
    );
  }
}

class LoginData {
  final LoginUser? user;
  final LoginTokens? tokens;

  LoginData({required this.user, required this.tokens});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: json['user'] != null ? LoginUser.fromJson(json['user']) : null,
      tokens: json['tokens'] != null
          ? LoginTokens.fromJson(json['tokens'])
          : null,
    );
  }
}

class LoginUser {
  final String id;
  final String email;
  final String userName;
  final String passwordHash;
  final String accountStatus;
  final LoginRole? role;
  final dynamic profile;

  LoginUser({
    required this.id,
    required this.email,
    required this.userName,
    required this.passwordHash,
    required this.accountStatus,
    required this.role,
    required this.profile,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      userName: json['userName'] ?? '',
      passwordHash: json['passwordHash'] ?? '',
      accountStatus: json['accountStatus'] ?? '',
      role: json['role'] != null ? LoginRole.fromJson(json['role']) : null,
      profile: json['profile'],
    );
  }
}

class LoginRole {
  final String name;

  LoginRole({required this.name});

  factory LoginRole.fromJson(Map<String, dynamic> json) {
    return LoginRole(name: json['name'] ?? '');
  }
}

class LoginTokens {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  LoginTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory LoginTokens.fromJson(Map<String, dynamic> json) {
    return LoginTokens(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      expiresIn: json['expiresIn'] ?? 0,
    );
  }
}
