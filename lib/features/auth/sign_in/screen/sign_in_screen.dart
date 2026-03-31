import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_text_form_field.dart';
import 'package:chrisimhof/core/common/widgets/language_toggle_widget.dart';
import 'package:chrisimhof/core/common/widgets/social_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/core/const/image_path.dart';
import 'package:chrisimhof/features/auth/sign_in/controller/sign_in_controller.dart';
import 'package:chrisimhof/core/common/widgets/divider_widget.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.only(top: 62, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: LanguageToggleWidget(),
                ),
                Image.asset(ImagePath.appLogo, width: 120, height: 72),
                SizedBox(height: 56),
                Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    'Welcome Back',
                    style: getTextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Sign In to continue optimizing your lifestyle and performance.',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextColor,
                  ),
                ),
                SizedBox(height: 56),
                CustomTextFormField(
                  label: 'Email',
                  hintText: 'Enter your email',
                  isRequired: true,
                  controller: controller.emailController,
                  validator: (value) => controller.validateEmail(value),
                ),
                SizedBox(height: 16),
                Obx(
                  () => CustomTextFormField(
                    label: 'Password',
                    isRequired: true,
                    hintText: 'Enter your password',
                    controller: controller.passwordController,
                    suffixIcon: IconButton(
                      onPressed: controller.togglePasswordVisibility,
                      icon: Icon(
                        controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                    obscureText: controller.isPasswordHidden.value,
                    textInputAction: TextInputAction.done,
                    validator: (value) => controller.validatePassword(value),
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryButtonColor,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primaryButtonColor,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Obx(
                  () => CustomButton(
                    text: 'Sign In',
                    onTap: controller.isLoading.value
                        ? null
                        : () {
                            if (formKey.currentState!.validate()) {
                              controller.login();
                            }
                          },
                  ),
                ),
                SizedBox(height: 32),
                DividerWidget(),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SocialButton(
                      imagePath: IconPath.google,
                      onTap: controller.signInWithGoogle,
                    ),
                    SizedBox(width: 16),
                    SocialButton(
                      imagePath: IconPath.apple,
                      backgroundColor: Colors.black,
                      onTap: controller.signInWithApple,
                    ),
                    SizedBox(width: 16),
                    SocialButton(
                      imagePath: IconPath.microsoft,
                      onTap: controller.signInWithMicrosoft,
                    ),
                  ],
                ),
                SizedBox(height: 32),
                RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: getTextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(AppRoutes.createAccountScreen);
                          },
                        text: 'Create Account',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryButtonColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
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
