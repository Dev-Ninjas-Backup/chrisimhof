import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/auth/sign_in/controller/sign_in_controller.dart';
import 'package:chrisimhof/features/auth/widgets/ryvenza_auth_widgets.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final SignInController controller = Get.put(SignInController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return RyvenzaAuthScaffold(
      title: 'Log in',
      subtitle: 'Continue your rhythm plan from today.',
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              RyvenzaTextField(
                label: 'Email',
                hintText: 'Enter your email',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.person_outline_rounded,
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.forgetPasswordEmailScreen);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.secondaryButtonColor,
                    padding: const EdgeInsets.only(bottom: 12),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot password?'.tr,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => RyvenzaAuthButton(
                  text: 'Log in',
                  onTap: controller.isLoading.value
                      ? null
                      : () {
                          if (formKey.currentState!.validate()) {
                            controller.login();
                          }
                        },
                ),
              ),
            ],
          ),
        ),
        const RyvenzaAuthDivider(),
        RyvenzaSocialButton(
          label: 'Continue with Google',
          imagePath: IconPath.google,
          onTap: controller.signInWithGoogle,
        ),
        const SizedBox(height: 10),
        RyvenzaSocialButton(
          label: 'Continue with Apple',
          imagePath: IconPath.apple,
          onTap: controller.signInWithApple,
          dark: true,
        ),
        const SizedBox(height: 10),
        RyvenzaSocialButton(
          label: 'Continue with Microsoft',
          imagePath: IconPath.microsoft,
          onTap: controller.signInWithMicrosoft,
        ),
        const SizedBox(height: 20),
        Center(
          child: RichText(
            text: TextSpan(
              text: '${'No account?'.tr} ',
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: AppColors.textSoft,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.toNamed(AppRoutes.createAccountScreen);
                    },
                  text: 'Create one'.tr,
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
