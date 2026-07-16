import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/features/settings/main/model/profile_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);

  @override
  String toString() => message;
}

class ProfileService {
  // GET /api/v1/auth/me
  Future<ProfileResponseModel> getProfile({required String accessToken}) async {
    final uri = Uri.parse(Urls.userMe);

    final response = await http.get(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    debugPrint('Profile status code: ${response.statusCode}');
    debugPrint('Profile response body: ${response.body}');

    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return ProfileResponseModel.fromJson(jsonData);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException(jsonData['message'] ?? 'Invalid or expired token');
    } else {
      throw Exception(jsonData['message'] ?? 'Failed to load profile');
    }
  }


}
