import 'package:chrisimhof/features/auth/forget_password/screen/verify_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;

  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> otpFocusNodes = List.generate(4, (_) => FocusNode());

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  Future<void> sendCode() async {
    isLoading.value = true;

    try {
      await Future.delayed(const Duration(seconds: 1));
      Get.offAll(VerifyCodeScreen());
      EasyLoading.showSuccess('Code sent successfully');
    } catch (e) {
      EasyLoading.showError('Failed to send code: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < otpFocusNodes.length - 1) {
        otpFocusNodes[index + 1].requestFocus();
      } else {
        otpFocusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        otpFocusNodes[index - 1].requestFocus();
      }
    }
  }

  String get otpCode => otpControllers.map((e) => e.text).join();

  Future<void> verifyCode() async {
    if (otpCode.length != 4) {
      EasyLoading.showError('Please enter the 4-digit code');
      return;
    }

    isLoading.value = true;

    try {
      await Future.delayed(const Duration(seconds: 1));
      // Get.offAll(VerifyCodeScreen());
      EasyLoading.showSuccess('Code verified successfully');
    } catch (e) {
      EasyLoading.showError('Verification failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
