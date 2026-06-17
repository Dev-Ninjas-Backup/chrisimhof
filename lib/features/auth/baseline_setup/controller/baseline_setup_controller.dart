import 'package:chrisimhof/features/auth/baseline_setup/service/baseline_enums.dart';
import 'package:chrisimhof/features/auth/baseline_setup/service/baseline_setup_service.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:chrisimhof/features/settings/main/controller/settings_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class BaselineSetupController extends GetxController {
  final _service = BaselineSetupService();
  bool isFromSettings = false;

  final sleepHours = 7.obs;
  final sleepMinutes = 45.obs;
  final sleepTargetDisplay = '7h 45m'.obs;

  final chronotype = BaselineEnums.defaultChronotype.obs;
  final caffeineSensitivity = BaselineEnums.defaultCaffeineSensitivity.obs;
  final sportProfile = BaselineEnums.defaultSportProfile.obs;

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
        final totalMinutes = _parseSleepTargetMinutes(
          data['sleepTargetMinutes'],
        );
        sleepHours.value = totalMinutes ~/ 60;
        sleepMinutes.value = totalMinutes % 60;
        sleepTargetDisplay.value = _formatSleepTarget(totalMinutes);

        chronotype.value = BaselineEnums.normalizeChronotype(
          data['chronotype'],
        );
        caffeineSensitivity.value = BaselineEnums.normalizeCaffeineSensitivity(
          data['caffeineSensitivity'],
        );
        sportProfile.value = BaselineEnums.normalizeSportProfile(
          data['sportProfile'],
        );
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
      final totalMinutes = _normalizedSleepTargetMinutes;

      final response = await _service.updateBaseline(
        sleepTargetMinutes: totalMinutes,
        chronotype: BaselineEnums.normalizeChronotype(chronotype.value),
        caffeineSensitivity: BaselineEnums.normalizeCaffeineSensitivity(
          caffeineSensitivity.value,
        ),
        sportProfile: BaselineEnums.normalizeSportProfile(sportProfile.value),
      );

      if (response['success'] == true) {
        EasyLoading.showSuccess('Baseline saved successfully');
        if (isFromSettings) {
          if (Get.isRegistered<SettingsController>()) {
            Get.find<SettingsController>().getProfile();
          }
        } else {
          Get.toNamed(AppRoutes.connectedSourcesScreen);
        }
      }
    } catch (e) {
      EasyLoading.showError('Failed to save baseline: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void setSleepTarget({required int hours, required int minutes}) {
    final totalMinutes = (hours * 60 + minutes).clamp(1, 23 * 60 + 59).toInt();
    sleepHours.value = totalMinutes ~/ 60;
    sleepMinutes.value = totalMinutes % 60;
    sleepTargetDisplay.value = _formatSleepTarget(totalMinutes);
  }

  int get _normalizedSleepTargetMinutes {
    final totalMinutes = sleepHours.value * 60 + sleepMinutes.value;
    return totalMinutes.clamp(1, 23 * 60 + 59).toInt();
  }

  int _parseSleepTargetMinutes(dynamic value) {
    if (value is int) {
      return value.clamp(1, 23 * 60 + 59).toInt();
    }

    final parsedValue = int.tryParse(value?.toString() ?? '');
    return (parsedValue ?? 7 * 60 + 45).clamp(1, 23 * 60 + 59).toInt();
  }

  String _formatSleepTarget(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (minutes == 0) {
      return '${hours}h';
    }

    return '${hours}h ${minutes}m';
  }

  // Display helpers for screen subtitle rendering
  String getChronotypeDisplay(String val) {
    final enumValue = BaselineEnums.normalizeChronotype(val);
    return BaselineEnums.chronotype[enumValue]!;
  }

  String getCaffeineDisplay(String val) {
    final enumValue = BaselineEnums.normalizeCaffeineSensitivity(val);
    return BaselineEnums.caffeineSensitivity[enumValue]!;
  }

  String getSportProfileDisplay(String val) {
    final enumValue = BaselineEnums.normalizeSportProfile(val);
    return BaselineEnums.sportProfile[enumValue]!;
  }
}
