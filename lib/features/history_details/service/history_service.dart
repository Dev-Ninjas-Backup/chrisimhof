import 'dart:convert';

import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/features/history_details/model/history_details_model.dart';
import 'package:http/http.dart' as http;

class HistoryDetailsService {
  Future<HistoryDetailsResponse> fetchHistoryDetails(String historyId) async {
    final uri = Uri.parse(Urls.historyDetails(historyId));

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;
      return HistoryDetailsResponse.fromJson(json);
    } else {
      throw Exception(
        'Failed to load history details. '
        'Status: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }
}