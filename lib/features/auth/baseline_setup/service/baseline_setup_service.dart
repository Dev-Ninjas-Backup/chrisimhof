import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:http/http.dart' as http;

class BaselineSetupService {
  // GET /api/v1/profile/baseline
  Future<Map<String, dynamic>> getBaseline() async {
    final uri = Uri.parse(Urls.baseline);
    final accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';

    final response = await http.get(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonData;
    } else {
      throw Exception(jsonData['message'] ?? 'Failed to retrieve baseline profile');
    }
  }

  // PATCH /api/v1/profile/baseline
  Future<Map<String, dynamic>> updateBaseline({
    int? sleepTargetMinutes,
    String? chronotype,
    String? caffeineSensitivity,
    String? sportProfile,
    int? defaultDailyMealTarget,
    String? timeFormat,
  }) async {
    final uri = Uri.parse(Urls.baseline);
    final accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';

    final Map<String, dynamic> body = {};
    if (sleepTargetMinutes != null) {
      body['sleepTargetMinutes'] = sleepTargetMinutes;
    }
    if (chronotype != null) {
      body['chronotype'] = chronotype;
    }
    if (caffeineSensitivity != null) {
      body['caffeineSensitivity'] = caffeineSensitivity;
    }
    if (sportProfile != null) {
      body['sportProfile'] = sportProfile;
    }
    if (defaultDailyMealTarget != null) {
      body['defaultDailyMealTarget'] = defaultDailyMealTarget;
    }
    if (timeFormat != null) {
      body['timeFormat'] = timeFormat;
    }

    final response = await http.patch(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonData;
    } else {
      throw Exception(jsonData['message'] ?? 'Failed to update baseline profile');
    }
  }
}
