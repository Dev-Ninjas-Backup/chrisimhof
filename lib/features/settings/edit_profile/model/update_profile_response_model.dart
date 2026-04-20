class UpdateProfileResponseModel {
  final bool success;
  final String message;
  final UpdateProfileData? data;

  UpdateProfileResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? UpdateProfileData.fromJson(json['data'])
          : null,
    );
  }
}

class UpdateProfileData {
  final String id;
  final String userId;
  final String? fullName;
  final String? avatarUrl;
  final String? bio;
  final String createdAt;
  final String updatedAt;
  final String email;
  final bool isSubscribed;
  final String signInBy;
  final String accountStatus;

  UpdateProfileData({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.avatarUrl,
    required this.bio,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
    required this.isSubscribed,
    required this.signInBy,
    required this.accountStatus,
  });

  factory UpdateProfileData.fromJson(Map<String, dynamic> json) {
    return UpdateProfileData(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      fullName: json['fullName'],
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      email: json['email'] ?? '',
      isSubscribed: json['isSubscribed'] ?? false,
      signInBy: json['signInBy'] ?? '',
      accountStatus: json['accountStatus'] ?? '',
    );
  }
}
