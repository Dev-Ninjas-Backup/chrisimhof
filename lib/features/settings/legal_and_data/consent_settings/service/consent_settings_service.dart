import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/settings/legal_and_data/consent_settings/model/consent_settings_model.dart';
import 'package:http/http.dart' as http;

class ConsentSettingsService {
  // GET /api/v1/onboarding/consent?locale=$locale
  Future<ConsentSettingsResponseModel> getConsentSettings({
    required String locale,
  }) async {
    final uri = Uri.parse(Urls.getConsentSettings(locale));
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
    print('consent settings: $jsonData');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ConsentSettingsResponseModel.fromJson(jsonData);
    } else {
      throw Exception(jsonData['message'] ?? 'Failed to load consent settings');
    }
  }

  // POST /api/v1/onboarding/consent
  Future<ConsentSettingsPostResponseModel> saveConsentSettings({
    required bool lifestyleRecommendations,
    required bool reminders,
    required bool connectedSources,
    required bool companyPilotInsights,
    required bool usageAnalytics,
  }) async {
    final uri = Uri.parse(Urls.updateConsentSettings);
    final accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';

    final response = await http.post(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'lifestyleRecommendations': lifestyleRecommendations,
        'reminders': reminders,
        'connectedSources': connectedSources,
        'companyPilotInsights': companyPilotInsights,
        'usageAnalytics': usageAnalytics,
      }),
    );

    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ConsentSettingsPostResponseModel.fromJson(jsonData);
    } else {
      throw Exception(jsonData['message'] ?? 'Failed to save consent settings');
    }
  }
}
