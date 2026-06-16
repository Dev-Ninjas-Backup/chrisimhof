import 'package:chrisimhof/features/auth/baseline_setup/service/baseline_setup_service.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class BaselineSetupController extends GetxController {
  final _service = BaselineSetupService();

  final sleepHours = 7.obs;
  final sleepMinutes = 45.obs;

  // Store the exact enums as reactive variables
  final chronotype = 'intermediate'.obs;
  final caffeineSensitivity = 'medium'.obs;
  final sportProfile = 'light'.obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBaselineData();
  }

  Future<void> fetchBaselineData() async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Loading...');
      final response = await _service.getBaseline();
      if (response['success'] == true) {
        final data = response['data'];
        final totalMinutes = data['sleepTargetMinutes'] as int;
        sleepHours.value = totalMinutes ~/ 60;
        sleepMinutes.value = totalMinutes % 60;

        chronotype.value = data['chronotype'] ?? 'intermediate';
        caffeineSensitivity.value = data['caffeineSensitivity'] ?? 'medium';
        sportProfile.value = data['sportProfile'] ?? 'light';
      }
    } catch (e) {
      EasyLoading.showError('Failed to load baseline data: $e');
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  Future<void> saveBaselineData() async {
    try {
      EasyLoading.show(status: 'Saving...');
      final totalMinutes = sleepHours.value * 60 + sleepMinutes.value;

      final response = await _service.updateBaseline(
        sleepTargetMinutes: totalMinutes,
        chronotype: chronotype.value,
        caffeineSensitivity: caffeineSensitivity.value,
        sportProfile: sportProfile.value,
      );

      if (response['success'] == true) {
        EasyLoading.showSuccess('Baseline saved successfully');
        Get.toNamed(AppRoutes.connectedSourcesScreen);
      }
    } catch (e) {
      EasyLoading.showError('Failed to save baseline: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Display helpers for screen subtitle rendering
  String getChronotypeDisplay(String val) {
    switch (val) {
      case 'morning':
        return 'Morning leaning';
      case 'intermediate':
        return 'Balanced';
      case 'evening':
        return 'Evening leaning';
      default:
        return 'Balanced';
    }
  }

  String getCaffeineDisplay(String val) {
    switch (val) {
      case 'low':
        return 'Low';
      case 'medium':
        return 'Medium';
      case 'high':
        return 'High';
      default:
        return 'Medium';
    }
  }

  String getSportProfileDisplay(String val) {
    switch (val) {
      case 'sedentary':
        return 'Sedentary';
      case 'light':
        return 'Light activity';
      case 'cardio':
        return 'Moderately active';
      case 'strength':
        return 'Very active';
      case 'mixed':
        return 'Mixed';
      case 'endurance':
        return 'Athlete';
      default:
        return 'Light activity';
    }
  }
}
