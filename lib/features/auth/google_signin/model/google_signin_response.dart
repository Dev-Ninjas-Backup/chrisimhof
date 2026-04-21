class GoogleSignInResponse {
  final bool success;
  final String? message;
  final String? accessToken;
  final String? refreshToken;
  final dynamic user;

  GoogleSignInResponse({
    required this.success,
    this.message,
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  factory GoogleSignInResponse.fromJson(Map<String, dynamic> json) {
    return GoogleSignInResponse(
      success: json['success'] ?? false,
      message: json['message'],
      accessToken: json['data']?['tokens']?['accessToken'],
      refreshToken: json['data']?['tokens']?['refreshToken'],
      user: json['data']?['user'],
    );
  }
}
