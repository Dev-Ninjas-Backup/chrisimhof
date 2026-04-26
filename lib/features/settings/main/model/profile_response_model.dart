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
  final String? fcmToken;
  final String? firstName;
  final String? avatarUrl;
  final String? bio;
  final String createdAt;
  final String updatedAt;
  final String email;
  final String fullName;
  final bool isSubscribed;
  final String signInBy;
  final String accountStatus;
  final String role;
  final String? language;

  ProfileData({
    required this.id,
    required this.userId,
    required this.fcmToken,
    required this.firstName,
    required this.avatarUrl,
    required this.bio,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
    required this.fullName,
    required this.isSubscribed,
    required this.signInBy,
    required this.accountStatus,
    required this.role,
    required this.language,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> profile =
        (json['profile'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final Map<String, dynamic> role =
        (json['role'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    return ProfileData(
      id: json['id'] ?? profile['id'] ?? '',
      userId: profile['userId'] ?? json['id'] ?? '',
      fcmToken: json['fcmToken'],
      firstName: profile['firstName'] ?? json['firstName'],
      avatarUrl: profile['avatarUrl'],
      bio: profile['bio'],
      createdAt: profile['createdAt'] ?? json['createdAt'] ?? '',
      updatedAt: profile['updatedAt'] ?? json['updatedAt'] ?? '',
      email: json['email'] ?? '',
      fullName: profile['fullName'] ?? json['fullName'] ?? '',
      isSubscribed: json['isSubscribed'] ?? false,
      signInBy: json['signInBy'] ?? '',
      accountStatus: json['accountStatus'] ?? '',
      role: role['name'] ?? json['role'] ?? '',
      language:
          (json['language'] as String?) ?? (profile['language'] as String?),
    );
  }
}
