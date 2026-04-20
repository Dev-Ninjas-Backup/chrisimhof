import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:http/http.dart' as http;

class ChangePasswordService {
  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final uri = Uri.parse(Urls.changePassword);
    final accessToken = await SharedPreferencesHelper.getAccessToken();

    try {
      final response = await http
          .patch(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode({
              'currentPassword': currentPassword,
              'newPassword': newPassword,
              'confirmPassword': confirmPassword,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return jsonData['message'] ?? 'Password updated successfully';
      } else {
        throw Exception(jsonData['message'] ?? 'Failed to update password');
      }
    } catch (e) {
      throw Exception('Error updating password: $e');
    }
  }
}
