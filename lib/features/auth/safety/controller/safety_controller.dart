import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SafetyController extends GetxController {
  final isLimit1Checked = false.obs;
  final isLimit2Checked = false.obs;
  final isLimit3Checked = false.obs;
  final isLimit4Checked = false.obs;

  void toggleLimit1() => isLimit1Checked.value = !isLimit1Checked.value;
  void toggleLimit2() => isLimit2Checked.value = !isLimit2Checked.value;
  void toggleLimit3() => isLimit3Checked.value = !isLimit3Checked.value;
  void toggleLimit4() => isLimit4Checked.value = !isLimit4Checked.value;

  bool get isAllChecked =>
      isLimit1Checked.value &&
      isLimit2Checked.value &&
      isLimit3Checked.value &&
      isLimit4Checked.value;

  void handleContinue() {
    if (!isAllChecked) {
      EasyLoading.showInfo(
        'Please confirm all safety limits before continuing.'.tr,
      );
      return;
    }

    Get.toNamed(AppRoutes.baselineSetupScreen);
  }
}
