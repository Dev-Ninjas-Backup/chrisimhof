class ProfileResponseModel {
  final bool success;
  final String message;
  final ProfileData? data;

  ProfileResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    );
  }
}

class ProfileData {
  final String id;
  final String userId;
  final String? firstName;
  final String? avatarUrl;
  final String? bio;
  final String createdAt;
  final String updatedAt;
  final String email;
  final String userName;
  final bool isSubscribed;
  final String signInBy;
  final String accountStatus;
  final String role;

  ProfileData({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.avatarUrl,
    required this.bio,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
    required this.userName,
    required this.isSubscribed,
    required this.signInBy,
    required this.accountStatus,
    required this.role,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      firstName: json['firstName'],
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      email: json['email'] ?? '',
      userName: json['userName'] ?? '',
      isSubscribed: json['isSubscribed'] ?? false,
      signInBy: json['signInBy'] ?? '',
      accountStatus: json['accountStatus'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
