class RefreshResponseModel {
  final bool success;
  final String message;
  final RefreshData? data;

  RefreshResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RefreshResponseModel.fromJson(Map<String, dynamic> json) {
    return RefreshResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? RefreshData.fromJson(json['data']) : null,
    );
  }
}

class RefreshData {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  RefreshData({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory RefreshData.fromJson(Map<String, dynamic> json) {
    return RefreshData(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      expiresIn: json['expiresIn'] ?? 0,
    );
  }
}
