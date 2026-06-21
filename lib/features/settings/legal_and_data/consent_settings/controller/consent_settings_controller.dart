import 'package:chrisimhof/core/common/controller/language_controller.dart';
import 'package:chrisimhof/features/settings/legal_and_data/consent_settings/model/consent_settings_model.dart';
import 'package:chrisimhof/features/settings/legal_and_data/consent_settings/service/consent_settings_service.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ConsentSettingsController extends GetxController {
  final ConsentSettingsService _service = ConsentSettingsService();

  final RxBool isLoading = true.obs;
  final Rxn<ConsentSettingsData> consentSettingsData =
      Rxn<ConsentSettingsData>();

  final RxBool lifestyleRecommendations = true.obs;
  final RxBool reminders = true.obs;
  final RxBool connectedSources = false.obs;
  final RxBool companyPilotInsights = true.obs;
  final RxBool usageAnalytics = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchConsentSettings();
  }

  // Fetch current consent configurations from backend
  Future<void> fetchConsentSettings() async {
    try {
      isLoading.value = true;

      // Determine the locale, default to 'en'
      String locale = 'en';
      try {
        final langController = Get.find<LanguageController>();
        locale = langController.selectedLanguage.value.toLowerCase();
      } catch (_) {
        locale = Get.locale?.languageCode ?? 'en';
      }

      final response = await _service.getConsentSettings(locale: locale);
      if (response.success) {
        consentSettingsData.value = response.data;

        // Initialize checkbox/toggle states from backend
        for (var setting in response.data.settings) {
          switch (setting.key) {
            case 'lifestyleRecommendations':
              lifestyleRecommendations.value = setting.enabled;
              break;
            case 'reminders':
              reminders.value = setting.enabled;
              break;
            case 'connectedSources':
              connectedSources.value = setting.enabled;
              break;
            case 'companyPilotInsights':
              companyPilotInsights.value = setting.enabled;
              break;
            case 'usageAnalytics':
              usageAnalytics.value = setting.enabled;
              break;
          }
        }
      }
    } catch (e) {
      EasyLoading.showError('Failed to load consent settings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Save current consent preferences to backend
  Future<void> saveSettings() async {
    try {
      EasyLoading.show(status: 'Saving...'.tr);

      final response = await _service.saveConsentSettings(
        lifestyleRecommendations: lifestyleRecommendations.value,
        reminders: reminders.value,
        connectedSources: connectedSources.value,
        companyPilotInsights: companyPilotInsights.value,
        usageAnalytics: usageAnalytics.value,
      );

      if (response.success && response.data.saved) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess('Consent settings saved successfully'.tr);
        Get.offAllNamed(AppRoutes.navbarScreen);
      } else {
        EasyLoading.showError('Could not save consent settings.');
      }
    } catch (e) {
      EasyLoading.showError('Failed to save consent settings: $e');
    }
  }
}
