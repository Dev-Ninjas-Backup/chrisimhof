import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/auth/forget_password/controller/forget_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordEmailScreen extends StatelessWidget {
  const ForgetPasswordEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 50),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(
                    title: 'Reset password'.tr,
                    showBackButton: true,
                    showSettingsButton: true,
                  ),
                  const SizedBox(height: 78),
                  Container(
                    width: 75,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.mintSoft,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Image.asset(
                      IconPath.privacy,
                      width: 34,
                      height: 34,
                      color: AppColors.secondaryButtonColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Forgot your password?'.tr,
                    style: getTextStyle2(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Enter your email and RYVENZA sends a secure reset link.'
                        .tr,
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'EMAIL'.tr,
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.emailController,
                    validator: (value) => controller.validateEmail(value),
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.black,
                    style: getTextStyle(
                      color: AppColors.secondaryTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: 'you@example.com'.tr,
                      hintStyle: getTextStyle(
                        color: AppColors.textSoft,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: AppColors.textSoft,
                        size: 20,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.borderColor,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.borderColor,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.red,
                          width: 1.2,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.red,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Obx(
                    () => CustomButton(
                      text: 'Send reset link'.tr,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      icon: null,
                      onTap: controller.isLoading.value
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                controller.sendCode();
                              }
                            },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.subtle,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Check your inbox and spam folder. The link expires after 20 minutes.'
                          .tr,
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
