import 'package:chrisimhof/features/auth/forget_password/screen/forget_password_screen.dart';
import 'package:chrisimhof/features/auth/forget_password/screen/success_screen.dart';
import 'package:chrisimhof/features/auth/forget_password/screen/verify_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isNewPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  void toggleNewPasswordVisibility() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

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
      Get.to(VerifyCodeScreen());
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
      Get.to(ForgetPasswordScreen());
      EasyLoading.showSuccess('Code verified successfully');
    } catch (e) {
      EasyLoading.showError('Verification failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'New password is required';
    }
    if (value.trim().length < 6) {
      return 'New password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirm password is required';
    }
    if (value.trim() != newPasswordController.text.trim()) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> savePassword() async {
    if (!formKey.currentState!.validate()) return;

    try {
      await Future.delayed(const Duration(seconds: 1));
      Get.to(SuccessScreen());
      EasyLoading.showSuccess('Update password successfully');
    } catch (e) {
      EasyLoading.showError('Update password failed: ${e.toString()}');
    } finally {}
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
