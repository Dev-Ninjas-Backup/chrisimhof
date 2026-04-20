import 'dart:ui';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  final RxString selectedLanguage = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    final currentLocale = Get.locale?.languageCode ?? 'en';
    selectedLanguage.value = currentLocale == 'fr' ? 'fr' : 'en';
  }

  void changeLanguage(String langCode) {
    if (selectedLanguage.value == langCode) return;

    selectedLanguage.value = langCode;

    if (langCode == 'en') {
      Get.updateLocale(const Locale('en', 'US'));
    } else if (langCode == 'fr') {
      Get.updateLocale(const Locale('fr', 'FR'));
    }
  }

  bool isSelected(String langCode) => selectedLanguage.value == langCode;
}
