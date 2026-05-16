import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/dashboard/model/dashboard_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardService {
  String? _calculatorSessionId;

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

  Future<String> fetchCalculatorSessionId({bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _calculatorSessionId != null &&
        _calculatorSessionId!.isNotEmpty) {
      return _calculatorSessionId!;
    }

    final token = await SharedPreferencesHelper.getAccessToken();
    final response = await http.get(
      Uri.parse(Urls.createCalculatorSession),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch calculator session');
    }

    final jsonResponse = jsonDecode(response.body);
    String? sessionId;

    if (jsonResponse is Map<String, dynamic>) {
      final data = jsonResponse['data'];
      if (data is Map<String, dynamic>) {
        sessionId = data['sessionId']?.toString();
      }
      sessionId ??= jsonResponse['sessionId']?.toString();
    }

    if (sessionId == null || sessionId.isEmpty) {
      throw Exception('Calculator session id was not returned');
    }

    _calculatorSessionId = sessionId;
    return sessionId;
  }

  Future<void> updateCalculatorSession(Map<String, dynamic> payload) async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final sessionId = await fetchCalculatorSessionId();

    final response = await http.patch(
      Uri.parse(Urls.updateCalculatorSession(sessionId)),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      if (response.body.isNotEmpty) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse['message'] != null) {
          throw Exception(jsonResponse['message'].toString());
        }
      }

      throw Exception('Failed to update calculator session');
    }
  }
}
