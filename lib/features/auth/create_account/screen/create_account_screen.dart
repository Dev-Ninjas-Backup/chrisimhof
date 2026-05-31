import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/auth/create_account/controller/create_account_controller.dart';
import 'package:chrisimhof/features/auth/sign_in/controller/sign_in_controller.dart';
import 'package:chrisimhof/features/auth/widgets/ryvenza_auth_widgets.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAccountScreen extends StatelessWidget {
  CreateAccountScreen({super.key});

  final CreateAccountController controller = Get.put(CreateAccountController());
  final SignInController signInController = Get.put(SignInController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return RyvenzaAuthScaffold(
      title: 'Create account',
      subtitle: 'Start with a private rhythm plan built around your day.',
      children: [
        const PrivacyByDesignCard(),
        Form(
          key: formKey,
          child: Column(
            children: [
              RyvenzaTextField(
                label: 'Name',
                hintText: 'Enter your full name',
                controller: controller.fullNameController,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.person_outline_rounded,
                validator: controller.validateFullName,
              ),
              RyvenzaTextField(
                label: 'Email',
                hintText: 'Enter your email',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.alternate_email_rounded,
                validator: controller.validateEmail,
              ),
              Obx(
                () => RyvenzaTextField(
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
                () => RyvenzaAuthButton(
                  text: 'Create account',
                  isMint: true,
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
              style: GoogleFonts.manrope(
                color: AppColors.textSoft,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const RyvenzaAuthDivider(),
        RyvenzaSocialButton(
          label: 'Continue with Google',
          imagePath: IconPath.google,
          onTap: signInController.signInWithGoogle,
        ),
        const SizedBox(height: 10),
        RyvenzaSocialButton(
          label: 'Continue with Apple',
          imagePath: IconPath.apple,
          onTap: signInController.signInWithApple,
          dark: true,
        ),
        const SizedBox(height: 10),
        RyvenzaSocialButton(
          label: 'Continue with Microsoft',
          imagePath: IconPath.microsoft,
          onTap: signInController.signInWithMicrosoft,
        ),
        const SizedBox(height: 20),
        Center(
          child: RichText(
            text: TextSpan(
              text: '${'Do you have an account?'.tr} ',
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: AppColors.textSoft,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.toNamed(AppRoutes.signInScreen);
                    },
                  text: 'Sign In'.tr,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: AppColors.secondaryButtonColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
