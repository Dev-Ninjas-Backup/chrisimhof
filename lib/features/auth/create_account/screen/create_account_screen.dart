import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/auth/create_account/controller/create_account_controller.dart';
import 'package:chrisimhof/features/auth/sign_in/controller/sign_in_controller.dart';
import 'package:chrisimhof/features/auth/widgets/custom_text_field.dart';
import 'package:chrisimhof/features/auth/widgets/privacy_by_design_card.dart';

import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAccountScreen extends StatelessWidget {
  CreateAccountScreen({super.key});

  final CreateAccountController controller = Get.put(CreateAccountController());
  final SignInController signInController = Get.put(SignInController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String title = 'Create account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
            child: Column(
              children: [
                CustomAppBar(title: title, showBackButton: true, showSettingsButton: true),
                const SizedBox(height: 30),
                const PrivacyByDesignCard(),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        label: 'Name',
                        hintText: 'Enter your full name',
                        controller: controller.fullNameController,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icons.person_outline_rounded,
                        validator: controller.validateFullName,
                      ),
                      CustomTextField(
                        label: 'Email',
                        hintText: 'Enter your email',
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icons.alternate_email_rounded,
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
                      const SizedBox(height: 10),

                      Obx(
                        () => CustomButton(
                          text: 'Create account',
                          onTap: controller.isLoading.value
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    controller.createAccount();
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'By continuing, you accept Terms and Privacy.'.tr,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        color: AppColors.textSoft,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(color: AppColors.borderSoft),
                      ),
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
                      const Expanded(
                        child: Divider(color: AppColors.borderSoft),
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  text: 'Continue with Google',
                  onTap: signInController.signInWithGoogle,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  iconColor: Colors.black,
                  borderWidth: 1,
                  icon: null,
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Continue with Apple',
                  onTap: signInController.signInWithApple,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  iconColor: Colors.black,
                  borderWidth: 1,
                  icon: null,
                ),

                const SizedBox(height: 10),
                CustomButton(
                  text: 'Continue with Microsoft',
                  onTap: signInController.signInWithMicrosoft,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  iconColor: Colors.black,
                  borderWidth: 1,
                  icon: null,
                ),
                const SizedBox(height: 20),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: '${'Do you have an account?'.tr} ',
                      style: getTextStyle(
                        fontSize: 13,
                        color: AppColors.textSoft,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed(AppRoutes.signInScreen);
                            },
                          text: 'Sign In'.tr,
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
      ),
    );
  }
}
