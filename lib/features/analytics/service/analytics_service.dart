import 'dart:convert';

import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/analytics/model/analytics_response_model.dart';
import 'package:http/http.dart' as http;

class AnalyticsService {
  Future<AnalyticsResponseModel> getAnalytics(String period) async {
    final uri = Uri.parse(Urls.analytics(period));
    final accessToken = await SharedPreferencesHelper.getAccessToken();

    try {
      final response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AnalyticsResponseModel.fromJson(jsonData);
      } else {
        throw Exception(jsonData['message'] ?? 'Failed to load analytics');
      }
    } catch (e) {
      throw Exception('Error loading analytics: $e');
    }
  }
}
