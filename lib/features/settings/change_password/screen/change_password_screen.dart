import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_text_form_field.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/settings/change_password/controller/change_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Form(
        key: controller.formKey,
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 78),
          child: Column(
            children: [
              CustomAppBar(title: 'Change Password'.tr, showBackButton: true),
              SizedBox(height: 28),
              Obx(
                () => CustomTextFormField(
                  label: 'New Password'.tr,
                  isRequired: true,
                  hintText: 'Enter your new password'.tr,
                  controller: controller.newPasswordController,
                  suffixIcon: IconButton(
                    onPressed: controller.toggleNewPasswordVisibility,
                    icon: Icon(
                      controller.isNewPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                  obscureText: controller.isNewPasswordHidden.value,
                  textInputAction: TextInputAction.done,
                  validator: (value) => controller.validateNewPassword(value),
                ),
              ),
              SizedBox(height: 16),
              Obx(
                () => CustomTextFormField(
                  label: 'Confirm Password'.tr,
                  isRequired: true,
                  hintText: 'Enter your confirm password'.tr,
                  controller: controller.confirmPasswordController,
                  suffixIcon: IconButton(
                    onPressed: controller.toggleConfirmPasswordVisibility,
                    icon: Icon(
                      controller.isConfirmPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                  obscureText: controller.isConfirmPasswordHidden.value,
                  textInputAction: TextInputAction.done,
                  validator: (value) =>
                      controller.validateConfirmPassword(value),
                ),
              ),
              Spacer(),
              CustomButton(
                text: 'Update Password'.tr,
                onTap: controller.updatePassword, // 👈 call updatePassword
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
