import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/history/model/history_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class HistoryService {
  static Future<List<HistoryModel>> fetchHistory({
    int page = 1,
    int limit = 10,
    String filter = 'recent',
  }) async {
    try {
      final String url = '${Urls.history}?page=$page&limit=$limit&filter=$filter';

      // Get the access token
      final token = await SharedPreferencesHelper.getAccessToken();

      if (kDebugMode) {
        print('🔗 Fetching history from: $url');
        print(
            '🔑 Token: ${token?.isNotEmpty == true ? token!.substring(0, 20) + '...' : 'No token found'}');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      if (kDebugMode) {
        print('📡 Response status: ${response.statusCode}');
        print('📝 Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];

        if (kDebugMode) {
          print('✅ Successfully parsed ${data.length} history items');
        }

        return data
            .map((item) => HistoryModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load history: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error fetching history: $e');
      }
      throw Exception('Error fetching history: $e');
    }
  }
}

