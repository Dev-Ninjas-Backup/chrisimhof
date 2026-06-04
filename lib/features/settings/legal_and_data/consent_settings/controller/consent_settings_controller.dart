import 'package:get/get.dart';

class ConsentSettingsController extends GetxController {
  final RxBool lifestyleRecommendations = true.obs;
  final RxBool reminders = true.obs;
  final RxBool connectedSources = false.obs;
  final RxBool companyPilotInsights = true.obs;
  final RxBool usageAnalytics = false.obs;

  void saveSettings() {
    // TODO: Hook this up to real persistence / backend when available.
    Get.snackbar(
      'Saved',
      'Consent settings saved',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
