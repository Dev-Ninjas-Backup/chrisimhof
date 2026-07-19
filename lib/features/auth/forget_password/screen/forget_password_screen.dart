import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/auth/forget_password/controller/forget_password_controller.dart';
import 'package:chrisimhof/features/auth/widgets/custom_text_field.dart';
import 'package:chrisimhof/features/auth/forget_password/widgets/password_validation_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgetPasswordController>();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('userId')) {
      controller.userId = args['userId'];
    }
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsetsGeometry.only(left: 16, right: 16, bottom: 32),
        child: SafeArea(
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  title: 'New Password'.tr,
                  showBackButton: true,
                  showSettingsButton: true,
                ),
                SizedBox(height: 66),
                Text(
                  'Choose a new password'.tr,
                  style: getTextStyle2(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Use something unique so your rhythm history stays protected.'
                      .tr,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextColor,
                  ),
                ),
                SizedBox(height: 30),
                Obx(
                  () => CustomTextField(
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
                SizedBox(height: 24),
                Obx(
                  () => CustomTextField(
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
                SizedBox(height: 20),
                Obx(() {
                  final password = controller.password.value;
                  final hasMinLength = password.length >= 8;
                  final hasNumber = RegExp(r'\d').hasMatch(password);
                  final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PasswordValidationRow(
                        text: '8+ characters',
                        isMet: hasMinLength,
                      ),
                      SizedBox(height: 6),
                      PasswordValidationRow(
                        text: 'One number',
                        isMet: hasNumber,
                      ),
                      SizedBox(height: 6),
                      PasswordValidationRow(
                        text: 'One uppercase letter',
                        isMet: hasUppercase,
                      ),
                    ],
                  );
                }),
                SizedBox(height: 30),
                Obx(
                  () => CustomButton(
                    text: 'Save Password'.tr,
                    onTap: controller.isLoading.value
                        ? null
                        : controller.savePassword,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
