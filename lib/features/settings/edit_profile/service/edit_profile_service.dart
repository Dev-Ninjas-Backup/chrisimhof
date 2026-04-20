import 'dart:convert';
import 'dart:io';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/features/settings/edit_profile/model/update_profile_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class EditProfileService {
  Future<UpdateProfileResponseModel> updateProfile({
    required String accessToken,
    required String fullName,
    required String bio,
    File? imageFile,
  }) async {
    final uri = Uri.parse(Urls.updateProfile);

    final request = http.MultipartRequest('PATCH', uri);

    // Add headers
    request.headers.addAll({
      'accept': '*/*',
      'Authorization': 'Bearer $accessToken',
    });

    // Add fields
    request.fields['fullName'] = fullName.trim();
    request.fields['bio'] = bio.trim();

    // Add file if selected
    if (imageFile != null && await imageFile.exists()) {
      final mimeType = _getMimeType(imageFile.path);
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          contentType: http.MediaType.parse(mimeType),
        ),
      );
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('Update profile status code: ${response.statusCode}');
      debugPrint('Update profile response body: ${response.body}');

      if (response.statusCode == 200) {
        return UpdateProfileResponseModel.fromJson(jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
      rethrow;
    }
  }

  // Helper method to determine MIME type from file extension
  String _getMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    const mimeTypes = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'webp': 'image/webp',
      'bmp': 'image/bmp',
    };
    return mimeTypes[extension] ?? 'image/jpeg'; // Default to jpeg if unknown
  }
}
