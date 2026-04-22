class MicrosoftSignInResponse {
  final bool success;
  final String? message;
  final String? accessToken;
  final String? refreshToken;
  final dynamic user;

  MicrosoftSignInResponse({
    required this.success,
    this.message,
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  factory MicrosoftSignInResponse.fromJson(Map<String, dynamic> json) {
    return MicrosoftSignInResponse(
      success: json['success'] ?? false,
      message: json['message'],
      accessToken: json['data']?['tokens']?['accessToken'],
      refreshToken: json['data']?['tokens']?['refreshToken'],
      user: json['data']?['user'],
    );
  }
}
