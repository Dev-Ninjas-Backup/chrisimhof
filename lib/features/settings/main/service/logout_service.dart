import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LogoutService {
  Future<bool> logoutUser({
    required String accessToken,
    required String refreshToken,
  }) async {
    final uri = Uri.parse(Urls.logout);

    final response = await http.post(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    debugPrint('Logout status code: ${response.statusCode}');
    debugPrint('Logout response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      String errorMessage = 'Logout failed';

      try {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        errorMessage = jsonData['message'] ?? errorMessage;
      } catch (_) {
        if (response.body.isNotEmpty) {
          errorMessage = response.body;
        }
      }

      throw Exception(errorMessage);
    }
  }
}
