import 'dart:convert';

import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/history_details/model/history_details_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HistoryDetailsService {
  Future<HistoryDetailsResponse> fetchHistoryDetails(String historyId) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      final uri = Uri.parse(Urls.historyDetails(historyId));

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (kDebugMode) {
        debugPrint('========== HISTORY DETAILS API RESPONSE ==========');
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> json =
            jsonDecode(response.body) as Map<String, dynamic>;
        return HistoryDetailsResponse.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token');
      } else {
        throw Exception(
          'Failed to load history details. '
          'Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
