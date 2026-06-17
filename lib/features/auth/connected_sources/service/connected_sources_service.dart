import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/auth/connected_sources/model/connected_sources_model.dart';
import 'package:http/http.dart' as http;

class ConnectedSourcesService {
  // GET /api/v1/onboarding/sources?locale=$locale
  Future<ConnectedSourcesResponseModel> getConnectedSources({required String locale}) async {
    final uri = Uri.parse(Urls.getConnectedSources(locale));
    final accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';

    final response = await http.get(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ConnectedSourcesResponseModel.fromJson(jsonData);
    } else {
      throw Exception(jsonData['message'] ?? 'Failed to load connected sources data');
    }
  }

  // POST /api/v1/onboarding/sources
  Future<ConnectSourcesPostResponseModel> saveConnectedSources({
    required bool appleHealth,
    required bool googleHealthConnect,
  }) async {
    final uri = Uri.parse(Urls.connectSource);
    final accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';

    final response = await http.post(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'appleHealth': appleHealth,
        'googleHealthConnect': googleHealthConnect,
      }),
    );

    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ConnectSourcesPostResponseModel.fromJson(jsonData);
    } else {
      throw Exception(jsonData['message'] ?? 'Failed to save connected sources');
    }
  }
}
