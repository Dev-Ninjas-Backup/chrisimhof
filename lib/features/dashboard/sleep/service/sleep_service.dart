import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SleepService {
  // POST /api/v1/calculator/session/{sessionId}/sleep
  Future<Map<String, dynamic>> saveSleep({
    required String sessionId,
    required String sleepStartTime,
    required String wakeTime,
  }) async {
    final uri = Uri.parse(Urls.sleepCalculator(sessionId));
    final accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';

    final response = await http.post(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'sleepStartTime': sleepStartTime,
        'wakeTime': wakeTime,
      }),
    );

    debugPrint('Sleep Log POST Status: ${response.statusCode}');
    debugPrint('Sleep Log POST Body: ${response.body}');

    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonData;
    } else {
      throw Exception(jsonData['message'] ?? 'Failed to log sleep');
    }
  }
}
