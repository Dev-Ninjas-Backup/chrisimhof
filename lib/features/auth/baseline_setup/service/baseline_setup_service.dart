import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:http/http.dart' as http;
import 'package:chrisimhof/features/auth/baseline_setup/service/baseline_enums.dart';

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
    int? weeklySportGoal,
  }) async {
    final uri = Uri.parse(Urls.baseline);
    final accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';

    final Map<String, dynamic> body = {};
    if (sleepTargetMinutes != null) {
      body['sleepTargetMinutes'] = sleepTargetMinutes;
    }
    if (chronotype != null) {
      body['chronotype'] = BaselineEnums.normalizeChronotype(chronotype);
    }
    if (caffeineSensitivity != null) {
      body['caffeineSensitivity'] = BaselineEnums.normalizeCaffeineSensitivity(caffeineSensitivity);
    }
    if (sportProfile != null) {
      body['sportProfile'] = BaselineEnums.normalizeSportProfile(sportProfile);
    }
    if (defaultDailyMealTarget != null) {
      body['defaultDailyMealTarget'] = defaultDailyMealTarget;
    }
    if (timeFormat != null) {
      body['timeFormat'] = timeFormat;
    }
    if (weeklySportGoal != null) {
      body['weeklySportGoal'] = weeklySportGoal;
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
