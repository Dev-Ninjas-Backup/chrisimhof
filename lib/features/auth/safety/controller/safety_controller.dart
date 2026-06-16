import 'package:chrisimhof/core/common/controller/language_controller.dart';
import 'package:chrisimhof/features/auth/safety/model/safety_model.dart';
import 'package:chrisimhof/features/auth/safety/service/safety_service.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SafetyController extends GetxController {
  final SafetyService _safetyService = SafetyService();

  final RxBool isLoading = true.obs;
  final Rxn<SafetyData> safetyData = Rxn<SafetyData>();
  
  // Stores indices of checked safety items
  final RxList<int> checkedIndices = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSafetyData();
  }

  // Fetch onboarding safety configurations
  Future<void> fetchSafetyData() async {
    try {
      isLoading.value = true;
      
      // Determine the locale, default to EN
      String locale = 'en';
      try {
        final langController = Get.find<LanguageController>();
        locale = langController.selectedLanguage.value.toLowerCase();
      } catch (_) {
        locale = Get.locale?.languageCode ?? 'en';
      }

      final response = await _safetyService.getSafetyData(locale: locale);
      if (response.success) {
        safetyData.value = response.data;
        checkedIndices.clear();
      }
    } catch (e) {
      EasyLoading.showError('Failed to load safety requirements: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle checkout status of an item by its index
  void toggleItem(int index) {
    if (checkedIndices.contains(index)) {
      checkedIndices.remove(index);
    } else {
      checkedIndices.add(index);
    }
  }

  // Check if an item index is checked
  bool isItemChecked(int index) => checkedIndices.contains(index);

  // User can proceed only if all items marked 'required: true' in response are checked
  bool get canProceed {
    if (safetyData.value == null) return false;
    final requiredItems = safetyData.value!.items.where((item) => item.required);
    return requiredItems.every((item) => checkedIndices.contains(item.index));
  }

  // Submit acknowledgments and navigate
  Future<void> handleContinue() async {
    if (!canProceed) {
      EasyLoading.showInfo(
        'Please confirm all required safety limits before continuing.'.tr,
      );
      return;
    }

    try {
      EasyLoading.show(status: 'Saving...'.tr);
      
      final response = await _safetyService.acknowledgeSafety(
        acknowledgedItems: checkedIndices.toList(),
      );

      if (response.success && response.data.canProceed) {
        EasyLoading.dismiss();
        Get.toNamed(AppRoutes.baselineSetupScreen);
      } else {
        EasyLoading.showError('Could not proceed with safety acknowledgment.');
      }
    } catch (e) {
      EasyLoading.showError('Failed to acknowledge safety requirements: $e');
    }
  }
}
