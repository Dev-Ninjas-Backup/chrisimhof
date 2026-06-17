import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/routes/app_routes.dart';

class LanguageController extends GetxController {
  // Use uppercase codes to match backend values (EN / FR)
  final RxString selectedLanguage = 'EN'.obs;

  @override
  void onInit() {
    super.onInit();
    final currentLocale = Get.locale?.languageCode ?? 'en';
    selectedLanguage.value = currentLocale == 'fr' ? 'FR' : 'EN';
  }

  Future<void> changeLanguage(String langCode, {bool force = false}) async {
    // Normalize to uppercase
    langCode = langCode.toUpperCase();
    if (selectedLanguage.value == langCode && !force) return;

    // Save current value so we can revert on failure
    final prev = selectedLanguage.value;

    // Optimistically set selection
    selectedLanguage.value = langCode;

    try {
      final uri = Uri.parse(Urls.selectlanguage);
      final accessToken = await SharedPreferencesHelper.getAccessToken();

      final response = await http
          .patch(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode({'language': langCode}),
          )
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update locale in app
        if (langCode == 'EN') {
          Get.updateLocale(const Locale('en', 'US'));
        } else if (langCode == 'FR') {
          Get.updateLocale(const Locale('fr', 'FR'));
        }

        // Navigate to NavbarScreen (replace all)
        Get.offAllNamed(AppRoutes.navbarScreen);
      } else {
        // Revert selection on failure
        selectedLanguage.value = prev;
        throw Exception(jsonData['message'] ?? 'Failed to update language');
      }
    } catch (e) {
      // revert optimistic change if any error
      selectedLanguage.value = prev;
      rethrow;
    }
  }

  bool isSelected(String langCode) =>
      selectedLanguage.value == langCode.toUpperCase();
}
