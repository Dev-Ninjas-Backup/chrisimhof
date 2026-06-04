import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/settings/change_password/controller/change_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(title: 'Change password'.tr, showBackButton: true),
                const SizedBox(height: 32),
                // Header
                Text(
                  'Protect your account',
                  style: getTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Use a unique password with at least 8\ncharacters.',
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSoft,
                  ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      // Old Password Field
                      Obx(
                        () => _buildPasswordField(
                          label: 'OLD PASSWORD',
                          controller: controller.oldPasswordController,
                          isHidden: controller.isOldPasswordHidden.value,
                          onToggle: controller.toggleOldPasswordVisibility,
                          validator: (value) =>
                              controller.validateOldPassword(value),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // New Password Field
                      Obx(
                        () => _buildPasswordField(
                          label: 'NEW PASSWORD',
                          controller: controller.newPasswordController,
                          isHidden: controller.isNewPasswordHidden.value,
                          onToggle: controller.toggleNewPasswordVisibility,
                          validator: (value) =>
                              controller.validateNewPassword(value),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Confirm Password Field
                      Obx(
                        () => _buildPasswordField(
                          label: 'CONFIRM PASSWORD',
                          controller: controller.confirmPasswordController,
                          isHidden: controller.isConfirmPasswordHidden.value,
                          onToggle: controller.toggleConfirmPasswordVisibility,
                          validator: (value) =>
                              controller.validateConfirmPassword(value),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                CustomButton(
                  text: 'Update password'.tr,
                  onTap: controller.isLoading.value
                      ? null
                      : controller.updatePassword,
                  width: double.infinity,
                  backgroundColor: controller.isLoading.value
                      ? AppColors.primaryButtonColor.withValues(alpha: 0.5)
                      : AppColors.primaryButtonColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isHidden,
    required VoidCallback onToggle,
    required String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Text(
          label,
          style: getTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSoft,
          ),
        ),
        const SizedBox(height: 8),
        // Input Field
        TextFormField(
          controller: controller,
          obscureText: isHidden,
          textInputAction: TextInputAction.done,
          validator: validator,
          cursorColor: AppColors.primaryTextColor,
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryTextColor,
          ),
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Icon(
                Icons.lock_outline_rounded,
                size: 20,
                color: AppColors.textSoft,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 0,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.borderSoft, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.borderSoft, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: AppColors.primaryButtonColor,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.red, width: 1.5),
            ),
            filled: false,
            suffixIcon: GestureDetector(
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Icon(
                  isHidden ? Icons.visibility_off : Icons.visibility,
                  size: 22,
                  color: AppColors.textSoft,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
