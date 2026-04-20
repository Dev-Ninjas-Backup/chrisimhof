import 'package:chrisimhof/features/auth/forget_password/screen/forget_password_screen.dart';
import 'package:chrisimhof/features/auth/forget_password/screen/success_screen.dart';
import 'package:chrisimhof/features/auth/forget_password/screen/verify_code_screen.dart';
import 'package:chrisimhof/features/auth/forget_password/service/verify_otp_service.dart';
import 'package:chrisimhof/routes/app_routes.dart';
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

  final VerifyOtpService _verifyOtpService = VerifyOtpService();

  String? _email;
  String? _purpose;

  void toggleNewPasswordVisibility() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  final TextEditingController otpController = TextEditingController();

  void setEmailAndPurpose(String? email, String? purpose) {
    _email = email;
    _purpose = purpose;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required'.tr;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Please enter a valid email'.tr;
    }
    return null;
  }

  Future<void> sendCode() async {
    isLoading.value = true;

    try {
      await Future.delayed(const Duration(seconds: 1));
      Get.to(VerifyCodeScreen());
      EasyLoading.showSuccess('Code sent successfully'.tr);
    } catch (e) {
      EasyLoading.showError('${'Failed to send code'.tr}: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  String get otpCode => otpController.text;

  Future<void> verifyCode() async {
    if (otpCode.length != 6) {
      EasyLoading.showError('Please enter the 6-digit code'.tr);
      return;
    }

    if (_email == null || _email!.isEmpty) {
      EasyLoading.showError('Email not found. Please try again.'.tr);
      return;
    }

    if (_purpose == null || _purpose!.isEmpty) {
      EasyLoading.showError('Invalid purpose. Please try again.'.tr);
      return;
    }

    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Verifying OTP...');

      final response = await _verifyOtpService.verifyOtp(
        email: _email!,
        otp: otpCode,
        purpose: _purpose!,
      );

      // Print OTP verification response
      debugPrint('=== OTP VERIFICATION RESPONSE ===');
      debugPrint('Success: ${response.success}');
      debugPrint('Message: ${response.message}');
      if (response.data != null) {
        debugPrint('User ID: ${response.data?.user?.id}');
        debugPrint('User Email: ${response.data?.user?.email}');
        debugPrint('Email Verified: ${response.data?.user?.emailVerified}');
        debugPrint('Account Status: ${response.data?.user?.accountStatus}');
        debugPrint('Plan: ${response.data?.user?.plan}');
        debugPrint('Verification Message: ${response.data?.message}');
      }
      debugPrint('=================================');

      if (response.success) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess('Code verified successfully'.tr);

        // Clear OTP fields
        otpController.clear();

        // Navigate based on purpose
        if (_purpose == 'register') {
          // Navigate to login with clearStack to prevent going back to registration
          Future.delayed(const Duration(milliseconds: 500), () {
            Get.offAllNamed(AppRoutes.signInScreen);
          });
        } else if (_purpose == 'forget_password') {
          // Navigate to reset password screen
          Get.off(ForgetPasswordScreen());
        }
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('${'Verification failed'.tr}: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'New password is required'.tr;
    }
    if (value.trim().length < 6) {
      return 'New password must be at least 6 characters'.tr;
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirm password is required'.tr;
    }
    if (value.trim() != newPasswordController.text.trim()) {
      return 'Passwords do not match'.tr;
    }
    return null;
  }

  Future<void> savePassword() async {
    if (!formKey.currentState!.validate()) return;

    try {
      await Future.delayed(const Duration(seconds: 1));
      Get.to(SuccessScreen());
      EasyLoading.showSuccess('Update password successfully'.tr);
    } catch (e) {
      EasyLoading.showError('${'Update password failed'.tr}: ${e.toString()}');
    } finally {}
  }

  @override
  void onClose() {
    emailController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
