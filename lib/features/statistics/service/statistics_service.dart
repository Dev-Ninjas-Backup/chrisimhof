import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/statistics/model/statistics_model.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class AnalyticsService {
  Future<DashboardAnalyticsModel?> getAnalytics({
    required String period,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      final response = await http.get(
        Uri.parse(
          '${Urls.baseUrl}/api/v1/analytics?period=$period',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        debugPrint("Analytics Data: $jsonData");
        return DashboardAnalyticsModel.fromJson(jsonData);
      }

      throw Exception(
        'Failed to load analytics: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}