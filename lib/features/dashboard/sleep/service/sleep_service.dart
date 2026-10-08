import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SleepService {
  // POST /api/v1/calculator/session/{sessionId}/sleep
  Future<Map<String, dynamic>> saveSleep({
    required String sessionId,
    required String sleepStartedAt,
    required String wakeRecordedAt,
    bool? isNewMainWake,
    String? note,
  }) async {
    final uri = Uri.parse(Urls.sleepCalculator(sessionId));
    final accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';

    final Map<String, dynamic> bodyMap = {
      'sleepStartedAt': sleepStartedAt,
      'wakeRecordedAt': wakeRecordedAt,
    };

    if (isNewMainWake != null) {
      bodyMap['isNewMainWake'] = isNewMainWake;
    }
    if (note != null && note.isNotEmpty) {
      bodyMap['note'] = note;
    }

    debugPrint('=== SLEEP LOG REQUEST ===');
    debugPrint('URL: $uri');
    debugPrint('Headers: Authorization: Bearer $accessToken');
    debugPrint('Request Body: ${jsonEncode(bodyMap)}');

    final response = await http.post(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(bodyMap),
    );

    debugPrint('=== SLEEP LOG RESPONSE ===');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonData['success'] == false) {
        if (jsonData.containsKey('conflicts') ||
            (jsonData['data'] is Map && (jsonData['data'] as Map).containsKey('conflicts'))) {
          return jsonData;
        }
        throw Exception(jsonData['message'] ?? 'Failed to log sleep');
      }
      return jsonData;
    } else {
      if (jsonData.containsKey('conflicts') ||
          (jsonData['data'] is Map && (jsonData['data'] as Map).containsKey('conflicts'))) {
        return jsonData;
      }
      throw Exception(jsonData['message'] ?? 'Failed to log sleep');
    }
  }

  // PATCH /api/v1/calculator/sessions/{sessionId}/naps/{entryId}
  Future<Map<String, dynamic>> updateNap({
    required String sessionId,
    required String entryId,
    required int durationMinutes,
    String? quality,
    String? notes,
  }) async {
    final uri = Uri.parse(Urls.updateNap(sessionId, entryId));
    final accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';

    final Map<String, dynamic> bodyMap = {
      'durationMinutes': durationMinutes,
    };
    if (quality != null && quality.isNotEmpty) bodyMap['quality'] = quality;
    if (notes != null && notes.isNotEmpty) bodyMap['notes'] = notes;

    final response = await http.patch(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(bodyMap),
    );

    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonData;
    } else {
      throw Exception(jsonData['message'] ?? 'Failed to update nap');
    }
  }

  // DELETE /api/v1/calculator/sessions/{sessionId}/naps/{entryId}
  Future<Map<String, dynamic>> deleteNap({
    required String sessionId,
    required String entryId,
  }) async {
    final uri = Uri.parse(Urls.deleteNap(sessionId, entryId));
    final accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';

    final response = await http.delete(
      uri,
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $accessToken',
      },
    );

    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 204) {
      return jsonData;
    } else {
      throw Exception(jsonData['message'] ?? 'Failed to delete nap');
    }
  }
}
