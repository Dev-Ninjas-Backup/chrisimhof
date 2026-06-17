import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class WorkService {
  // POST /api/v1/calculator/session/{sessionId}/work
  Future<Map<String, dynamic>> saveWork({
    required String sessionId,
    required String shiftType, // 'day', 'evening', 'night', 'off'
    String? shiftStartTime,
    String? shiftEndTime,
  }) async {
    final uri = Uri.parse(Urls.workCalculator(sessionId));
    final accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';

    final bodyMap = {
      'shiftType': shiftType.toLowerCase(),
      if (shiftStartTime != null) 'shiftStartTime': shiftStartTime,
      if (shiftEndTime != null) 'shiftEndTime': shiftEndTime,
    };

    final response = await http.post(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(bodyMap),
    );

    debugPrint('Work Log POST Status: ${response.statusCode}');
    debugPrint('Work Log POST Body: ${response.body}');

    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonData;
    } else {
      throw Exception(jsonData['message'] ?? 'Failed to log work shift');
    }
  }
}
