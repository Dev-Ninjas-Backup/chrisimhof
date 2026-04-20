import 'package:chrisimhof/features/settings/change_password/service/change_password_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';

class ChangePasswordController extends GetxController {
  final ChangePasswordService _service = ChangePasswordService();

  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isOldPasswordHidden = true.obs;
  final isNewPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  void toggleOldPasswordVisibility() {
    isOldPasswordHidden.value = !isOldPasswordHidden.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  String? validateOldPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Old password is required';
    }
    return null;
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

  Future<void> updatePassword() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Updating password...');

      await _service.changePassword(
        currentPassword: oldPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
      );

      EasyLoading.dismiss();
      EasyLoading.showSuccess('Password updated successfully');

      // Clear fields and go back
      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      Future.delayed(const Duration(milliseconds: 500), () {
        Get.back();
      });
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
