import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/recomendations/model/recomendation_api_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class RecommendationService {
  Future<RecommendationResponse> getRecommendations({
    required String sessionId,
    String locale = 'en',
  }) async {
    final uri = Uri.parse(
      '${Urls.baseUrl}/api/v1/calculator/session/$sessionId/recommendations',
    ).replace(
      queryParameters: {
        'locale': locale,
      },
    );

    final accessToken = await SharedPreferencesHelper.getAccessToken();

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    debugPrint("Response status code: ${response.statusCode}");
    debugPrint("Response body: ${response.body}");

    if (response.statusCode == 200||response.statusCode==201) {
      return RecommendationResponse.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception(
        'Failed to load recommendations (${response.statusCode})',
      );
    }
  }
}