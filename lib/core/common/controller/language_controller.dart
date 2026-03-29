import 'package:get/get.dart';

class LanguageController extends GetxController {
  final RxString selectedLanguage = 'en'.obs;

  void changeLanguage(String languageCode) {
    selectedLanguage.value = languageCode;
  }

  bool isSelected(String languageCode) {
    return selectedLanguage.value == languageCode;
  }
}
