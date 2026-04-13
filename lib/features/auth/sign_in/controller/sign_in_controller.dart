import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/auth/sign_in/model/login_response_model.dart';
import 'package:chrisimhof/features/auth/sign_in/service/sign_in_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

  final SignInService _signInService = SignInService();

  LoginResponseModel? loginResponse;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.trim().length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> login() async {
    try {
      isLoading.value = true;

      final response = await _signInService.loginUser(
        email: emailController.text,
        password: passwordController.text,
      );

      loginResponse = response;

      if (response.success) {
        final accessToken = response.data?.tokens?.accessToken ?? '';
        final refreshToken = response.data?.tokens?.refreshToken ?? '';

        await SharedPreferencesHelper.saveAccessToken(accessToken);
        await SharedPreferencesHelper.saveRefreshToken(refreshToken);
        await SharedPreferencesHelper.setLoginStatus(true);

        debugPrint('Access Token: $accessToken');
        debugPrint('Refresh Token: $refreshToken');

        EasyLoading.showSuccess(response.message);
        Get.offAllNamed('/medicalDisclaimerScreen');
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('Login failed. Please try again.');
      debugPrint('Login error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      EasyLoading.showSuccess(
        'Google Sign-In Clicked',
        duration: Duration(seconds: 1),
      );
    } catch (e) {
      EasyLoading.showError(
        'Google Sign-In Error: ${e.toString()}',
        duration: Duration(seconds: 1),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithApple() async {
    try {
      isLoading.value = true;
      EasyLoading.showSuccess(
        'Apple Sign-In Clicked',
        duration: Duration(seconds: 1),
      );
    } catch (e) {
      EasyLoading.showError(
        'Apple Sign-In Error: ${e.toString()}',
        duration: Duration(seconds: 1),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithMicrosoft() async {
    try {
      isLoading.value = true;
      EasyLoading.showSuccess(
        'Microsoft Sign-In Clicked',
        duration: Duration(seconds: 1),
      );
    } catch (e) {
      EasyLoading.showError(
        'Microsoft Sign-In Error: ${e.toString()}',
        duration: Duration(seconds: 1),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
