import 'package:chrisimhof/features/auth/create_account/controller/create_account_controller.dart';
import 'package:chrisimhof/features/auth/forget_password/screen/verify_code_screen.dart';
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

    String email = "";
    if (Get.isRegistered<CreateAccountController>()) {
      email = Get.find<CreateAccountController>().emailController.text.trim();
    }

    Get.to(() => VerifyCodeScreen(
          email: email,
          purpose: 'register',
        ));
  }
}
