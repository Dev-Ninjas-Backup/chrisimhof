import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/statistics/model/statistics_model.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class AnalyticsService {
  Future<DashboardAnalyticsModel?> getAnalytics({
    required String period,
    String? endDate,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      final url = Urls.analyticsWithRange(period, endDate);

      final response = await http.get(
        Uri.parse(url),
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

  Future<Map<String, dynamic>?> getDailyTimeline({
    required String date,
    String? timezone,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      final url = Urls.dailyTimeline(date, timezone);

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        debugPrint("Daily Timeline Data: $jsonData");
        return jsonData['data'] as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      debugPrint("Failed to load daily timeline: $e");
      return null;
    }
  }
}