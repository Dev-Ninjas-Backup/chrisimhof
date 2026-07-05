import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/auth/sign_in/controller/sign_in_controller.dart';
import 'package:chrisimhof/features/auth/widgets/custom_text_field.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final SignInController controller = Get.put(SignInController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String title = 'Log in';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
          child: Column(
            children: [
              CustomAppBar(
                title: title,
                showBackButton: true,
                showSettingsButton: true,
              ),
              const SizedBox(height: 45),
              Text(
                "Welcome Back".tr,
                style: getTextStyle2(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Continue your rhythm plan from today.'.tr,
                style: getTextStyle(
                  fontSize: 16,
                  color: AppColors.textSoft,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Email',
                      hintText: 'Enter your email',
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.person_outline_rounded,
                      validator: controller.validateEmail,
                    ),
                    Obx(
                      () => CustomTextField(
                        label: 'Password',
                        hintText: 'Enter your password',
                        controller: controller.passwordController,
                        obscureText: controller.isPasswordHidden.value,
                        textInputAction: TextInputAction.done,
                        prefixIcon: Icons.lock_outline_rounded,
                        validator: controller.validatePassword,
                        suffixIcon: IconButton(
                          onPressed: controller.togglePasswordVisibility,
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSoft,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.forgetPasswordEmailScreen);
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(bottom: 12),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Forgot password?'.tr,
                          style: getTextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondaryButtonColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),

                    Obx(
                      () => CustomButton(
                        text: 'Log in',
                        textColor: AppColors.white,
                        onTap: controller.isLoading.value
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  controller.login();
                                }
                              },
                        iconColor: AppColors.white,
                        backgroundColor: AppColors.primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.borderSoft)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'OR'.tr,
                        style: getTextStyle(
                          color: AppColors.textSoft,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.borderSoft)),
                  ],
                ),
              ),
              CustomButton(
                text: 'Continue with Google'.tr,
                onTap: controller.signInWithGoogle,
                backgroundColor: AppColors.white,
                textColor: AppColors.black,
                iconColor: AppColors.black,
                borderWidth: 1,
                icon: null,
              ),
              const SizedBox(height: 10),
              CustomButton(
                text: 'Continue with Apple'.tr,
                onTap: controller.signInWithApple,
                backgroundColor: AppColors.white,
                textColor: AppColors.black,
                iconColor: AppColors.black,
                borderWidth: 1,
                icon: null,
              ),

              const SizedBox(height: 10),
              CustomButton(
                text: 'Continue with Microsoft'.tr,
                onTap: controller.signInWithMicrosoft,
                backgroundColor: AppColors.white,
                textColor: AppColors.black,
                iconColor: AppColors.black,
                borderWidth: 1,
                icon: null,
              ),

              const SizedBox(height: 20),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: '${'No account?'.tr} ',
                    style: getTextStyle(
                      fontSize: 13,
                      color: AppColors.textSoft,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(AppRoutes.createAccountScreen);
                          },
                        text: 'Create one'.tr,
                        style: getTextStyle(
                          fontSize: 13,
                          color: AppColors.secondaryButtonColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
