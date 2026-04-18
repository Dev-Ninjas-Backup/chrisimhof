import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/features/settings/edit_profile/model/update_profile_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class EditProfileService {
  Future<UpdateProfileResponseModel> updateProfile({
    required String accessToken,
    required String firstName,
    required String bio,
    required String avatarUrl,
  }) async {
    final uri = Uri.parse(Urls.updateProfile);

    final response = await http.patch(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'firstName': firstName.trim(),
        'bio': bio.trim(),
        'avatarUrl': avatarUrl.trim(),
      }),
    );

    debugPrint('Update profile status code: ${response.statusCode}');
    debugPrint('Update profile response body: ${response.body}');

    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return UpdateProfileResponseModel.fromJson(jsonData);
    } else {
      throw Exception(jsonData['message'] ?? 'Failed to update profile');
    }
  }
}
