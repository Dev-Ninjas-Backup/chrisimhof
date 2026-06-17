import 'package:chrisimhof/core/common/controller/language_controller.dart';
import 'package:chrisimhof/features/auth/connected_sources/model/connected_sources_model.dart';
import 'package:chrisimhof/features/auth/connected_sources/service/connected_sources_service.dart';
import 'package:chrisimhof/features/nav_bar/screen/navbar_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ConnectedSourcesController extends GetxController {
  final ConnectedSourcesService _service = ConnectedSourcesService();

  final RxBool isLoading = true.obs;
  final Rxn<ConnectedSourcesData> sourcesData = Rxn<ConnectedSourcesData>();

  // Toggle states for Apple Health and Google Health Connect
  final RxBool isAppleHealthConnected = false.obs;
  final RxBool isGoogleHealthConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchConnectedSources();
  }

  // Fetch connected sources onboarding configs
  Future<void> fetchConnectedSources() async {
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

      final response = await _service.getConnectedSources(locale: locale);
      if (response.success) {
        sourcesData.value = response.data;

        // Initialize states based on the response status values
        for (var src in response.data.sources) {
          if (src.key == 'apple') {
            isAppleHealthConnected.value = src.status == 'enabled' || src.status == 'linked';
          } else if (src.key == 'google') {
            isGoogleHealthConnected.value = src.status == 'enabled' || src.status == 'linked';
          }
        }
      }
    } catch (e) {
      EasyLoading.showError('Failed to load connected sources: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle Apple Health status
  void toggleAppleHealth() {
    isAppleHealthConnected.value = !isAppleHealthConnected.value;
  }

  // Toggle Google Health Connect status
  void toggleGoogleHealthConnect() {
    isGoogleHealthConnected.value = !isGoogleHealthConnected.value;
  }

  // Submit states to backend and navigate to Navbar screen
  Future<void> handleSaveSources() async {
    try {
      EasyLoading.show(status: 'Saving...'.tr);

      final response = await _service.saveConnectedSources(
        appleHealth: isAppleHealthConnected.value,
        googleHealthConnect: isGoogleHealthConnected.value,
      );

      if (response.success && response.data.saved) {
        EasyLoading.dismiss();
        Get.offAll(() => const NavbarScreen());
      } else {
        EasyLoading.showError('Could not save connected sources.');
      }
    } catch (e) {
      EasyLoading.showError('Failed to save connected sources: $e');
    }
  }
}
