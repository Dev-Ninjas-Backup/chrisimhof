import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DashboardService {
  // GET /api/v1/dashboard
  Future<Map<String, dynamic>> getDashboard() async {
    final uri = Uri.parse(Urls.dashboard);
    final accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';

    final response = await http.get(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    debugPrint('Dashboard GET Status: ${response.statusCode}');
    debugPrint('Dashboard GET Body: ${response.body}');

    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonData;
    } else {
      throw Exception(jsonData['message'] ?? 'Failed to retrieve dashboard data');
    }
  }

  // POST /api/v1/calculator/session/{sessionId}/calculate
  Future<Map<String, dynamic>> calculateResult({required String sessionId}) async {
    final uri = Uri.parse(Urls.calculateResult(sessionId));
    final accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';

    final response = await http.post(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({}),
    );

    debugPrint('Calculate Session POST Status: ${response.statusCode}');
    debugPrint('Calculate Session POST Body: ${response.body}');

    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonData;
    } else {
      throw Exception(jsonData['message'] ?? 'Failed to run calculation');
    }
  }

  // POST /api/v1/calculator/session/{sessionId}/reset
  Future<Map<String, dynamic>> resetSession({required String sessionId}) async {
    final uri = Uri.parse(Urls.sessionReset(sessionId));
    final accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';

    final response = await http.post(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    debugPrint('Reset Session POST Status: ${response.statusCode}');
    debugPrint('Reset Session POST Body: ${response.body}');

    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonData;
    } else {
      throw Exception(jsonData['message'] ?? 'Failed to reset calculator session');
    }
  }

  // PATCH /api/v1/calculator/session/{sessionId}/log
  Future<Map<String, dynamic>> patchQuickAddLog({
    required String sessionId,
    List<Map<String, dynamic>>? newWaterLogs,
    List<Map<String, dynamic>>? newCaffeineLogs,
    List<Map<String, dynamic>>? newMealLogs,
    List<Map<String, dynamic>>? newSportSessions,
    int? dailyMealTarget,
    String? fatigueLevel,
  }) async {
    final uri = Uri.parse(Urls.quickAdd(sessionId));
    final accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';

    final Map<String, dynamic> body = {};
    if (newWaterLogs != null) body['newWaterLogs'] = newWaterLogs;
    if (newCaffeineLogs != null) body['newCaffeineLogs'] = newCaffeineLogs;
    if (newMealLogs != null) body['newMealLogs'] = newMealLogs;
    if (newSportSessions != null) body['newSportSessions'] = newSportSessions;
    if (dailyMealTarget != null) body['dailyMealTarget'] = dailyMealTarget;
    if (fatigueLevel != null) body['fatigueLevel'] = fatigueLevel;

    final response = await http.patch(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    debugPrint('Quick Add PATCH Status: ${response.statusCode}');
    debugPrint('Quick Add PATCH Body: ${response.body}');

    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonData;
    } else {
      throw Exception(jsonData['message'] ?? 'Failed to log quick add data');
    }
  }
}
