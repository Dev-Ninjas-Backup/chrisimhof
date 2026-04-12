import 'package:chrisimhof/features/auth/create_account/model/register_response_model.dart';
import 'package:chrisimhof/features/auth/create_account/service/create_account_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class CreateAccountController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

  final CreateAccountService _createAccountService = CreateAccountService();

  RegisterResponseModel? registerResponse;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }

    if (value.trim().length < 3) {
      return 'Full name must be at least 3 characters';
    }

    // Only letters and spaces allowed
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Full name can only contain letters';
    }

    return null;
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
    if (value.trim().length < 8) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> createAccount() async {
    try {
      isLoading.value = true;

      final response = await _createAccountService.registerUser(
        name: fullNameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      registerResponse = response;

      if (response.success) {
        EasyLoading.showSuccess("Registration Successful");
        debugPrint('User ID: ${response.data?.user?.id}');
        debugPrint('User Email: ${response.data?.user?.email}');
        Get.back();
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('Failed to create account: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      EasyLoading.showSuccess(
        'Google Sign-In Clicked',
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      EasyLoading.showError(
        'Google Sign-In Error: ${e.toString()}',
        duration: Duration(seconds: 2),
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
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      EasyLoading.showError(
        'Apple Sign-In Error: ${e.toString()}',
        duration: Duration(seconds: 2),
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
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      EasyLoading.showError(
        'Microsoft Sign-In Error: ${e.toString()}',
        duration: Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
