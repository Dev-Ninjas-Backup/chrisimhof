import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/dashboard/model/dashboard_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardService {
  Future<DashboardModel> fetchDashboard() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      final response = await http.get(
        Uri.parse(Urls.dashboard),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (kDebugMode) {
        debugPrint('Response Statusdashboard: ${response.statusCode}');
        debugPrint('Response Bodydashboard: ${response.body}');
      }

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final dashboard = DashboardModel.fromJson(jsonResponse);
        return dashboard;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token');
      } else {
        throw Exception('Failed to fetch dashboard: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> fetchOptimalBedtime() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      final response = await http.get(
        Uri.parse(Urls.optimalBedtime),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (kDebugMode) {
        debugPrint('Optimal bedtime status: ${response.statusCode}');
        debugPrint('Optimal bedtime body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // Expecting response like: { "time": "02:00", ... }
        if (jsonResponse is Map && jsonResponse['time'] != null) {
          return jsonResponse['time'] as String;
        }
        return null;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token');
      } else {
        throw Exception(
          'Failed to fetch optimal bedtime: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
