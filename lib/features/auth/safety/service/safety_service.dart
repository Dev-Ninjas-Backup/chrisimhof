import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/auth/safety/model/safety_model.dart';
import 'package:http/http.dart' as http;

class SafetyService {
  // GET /api/v1/onboarding/safety?locale=$locale
  Future<SafetyResponseModel> getSafetyData({required String locale}) async {
    final uri = Uri.parse(Urls.getSafety(locale));
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
      return SafetyResponseModel.fromJson(jsonData);
    } else {
      throw Exception(jsonData['message'] ?? 'Failed to load safety onboarding data');
    }
  }

  // POST /api/v1/onboarding/safety/acknowledge
  Future<SafetyAcknowledgeResponseModel> acknowledgeSafety({
    required List<int> acknowledgedItems,
  }) async {
    final uri = Uri.parse(Urls.acceptSafety);
    final accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';

    final response = await http.post(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'acknowledgedItems': acknowledgedItems,
      }),
    );

    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SafetyAcknowledgeResponseModel.fromJson(jsonData);
    } else {
      throw Exception(jsonData['message'] ?? 'Failed to acknowledge safety items');
    }
  }
}
