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
}
