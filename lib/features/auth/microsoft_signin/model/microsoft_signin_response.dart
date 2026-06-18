class MicrosoftSignInResponse {
  final bool success;
  final String? message;
  final String? accessToken;
  final String? refreshToken;
  final dynamic user;
  final bool isNewUser;

  MicrosoftSignInResponse({
    required this.success,
    this.message,
    this.accessToken,
    this.refreshToken,
    this.user,
    this.isNewUser = false,
  });

  factory MicrosoftSignInResponse.fromJson(Map<String, dynamic> json) {
    return MicrosoftSignInResponse(
      success: json['success'] ?? false,
      message: json['message'],
      accessToken: json['data']?['tokens']?['accessToken'],
      refreshToken: json['data']?['tokens']?['refreshToken'],
      user: json['data']?['user'],
      isNewUser: json['data']?['isNewUser'] ?? false,
    );
  }
}
