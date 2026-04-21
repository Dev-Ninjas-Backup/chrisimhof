class UserModel {
  final String email;
  final String fullName;

  UserModel({
    required this.email,
    required this.fullName,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "fullName": fullName,
    };
  }
}