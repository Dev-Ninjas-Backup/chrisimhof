import 'dart:convert';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/recomendations/model/recomendation_api_model.dart';
import 'package:http/http.dart' as http;

class RecommendationService {
  Future<RecommendationResponse> getRecommendations({
    required String sessionId,
    String locale = 'en',
  }) async {
    final uri = Uri.parse(
      'https://api.ryvenza.app/api/v1/calculator/session/$sessionId/recommendations',
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