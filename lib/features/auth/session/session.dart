import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';

class SessionService {
  /// Hits the session API and stores the retrieved sessionId in SharedPreferences.
  Future<String?> fetchAndStoreSessionId() async {
    try {
      final uri = Uri.parse(Urls.createCalculatorSession).replace(
        queryParameters: {
          'locale': 'local',
        },
      );

      final accessToken = await SharedPreferencesHelper.getAccessToken();

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
      );

      debugPrint("Session API response status code: ${response.statusCode}");
      debugPrint("Session API response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          final sessionId = responseData['data']['sessionId'] as String?;
          if (sessionId != null && sessionId.isNotEmpty) {
            await SharedPreferencesHelper.saveSessionId(sessionId);
            debugPrint("Successfully saved sessionId to SharedPreferences: $sessionId");
            return sessionId;
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching and storing session ID: $e");
      return null;
    }
  }
}
