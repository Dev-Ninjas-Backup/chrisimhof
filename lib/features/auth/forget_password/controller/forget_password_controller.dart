import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
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
  final password = ''.obs;

  final VerifyOtpService _verifyOtpService = VerifyOtpService();

  String? _email;
  String? _purpose;
  String? userId;

  @override
  void onInit() {
    super.onInit();
    newPasswordController.addListener(() {
      password.value = newPasswordController.text;
    });
  }

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
      await _verifyOtpService.sendOtp(
        email: emailController.text.trim(),
      );

      Get.toNamed(
        AppRoutes.verifyCodeScreen,
        arguments: {
          'email': emailController.text.trim(),
          'purpose': 'reset_pass',
        },
      );
      EasyLoading.showSuccess('Code sent successfully'.tr);
    } catch (e) {
      print('Error sending OTP: $e');
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

        if (response.data != null) {
          final accessToken = response.data!.accessToken;
          final refreshToken = response.data!.refreshToken;
          if (accessToken != null && accessToken.isNotEmpty) {
            await SharedPreferencesHelper.saveAccessToken(accessToken);
            if (refreshToken != null) {
              await SharedPreferencesHelper.saveRefreshToken(refreshToken);
            }
            await SharedPreferencesHelper.setLoginStatus(true);
            debugPrint('Auto-logged in on OTP verify. Access Token saved: $accessToken');
          }
        }

        // Clear OTP fields
        otpController.clear();

        // Navigate based on purpose
        if (_purpose == 'register') {
          // Navigate to login with clearStack to prevent going back to registration
          Future.delayed(const Duration(milliseconds: 500), () {
            Get.offAllNamed(AppRoutes.signInScreen);
          });
        } else if (_purpose == 'reset_pass') {
          // Navigate to reset password screen
          userId = response.data?.user?.id;
          Get.offNamed(AppRoutes.forgetPasswordScreen, arguments: {'userId': userId});
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
    final val = value.trim();
    if (val.length < 8) {
      return 'Password must be at least 8 characters'.tr;
    }
    if (!RegExp(r'\d').hasMatch(val)) {
      return 'Password must contain at least one number'.tr;
    }
    if (!RegExp(r'[A-Z]').hasMatch(val)) {
      return 'Password must contain at least one uppercase letter'.tr;
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

    if (userId == null || userId!.isEmpty) {
      EasyLoading.showError('User identification not found. Please try verifying OTP again.'.tr);
      return;
    }

    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Updating password...'.tr);

      final success = await _verifyOtpService.resetPassword(
        userId: userId!,
        newPassword: newPasswordController.text.trim(),
      );

      if (success) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess('Update password successfully'.tr);
        // Clear password fields
        newPasswordController.clear();
        confirmPasswordController.clear();
        password.value = '';
        
        Get.toNamed(AppRoutes.successScreen);
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError('Failed to update password'.tr);
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('${'Update password failed'.tr}: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
