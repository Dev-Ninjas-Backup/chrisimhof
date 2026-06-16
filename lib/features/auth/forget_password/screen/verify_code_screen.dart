import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/auth/forget_password/controller/forget_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class VerifyCodeScreen extends StatelessWidget {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    final args = Get.arguments as Map<String, dynamic>?;

    if (args != null) {
      controller.setEmailAndPurpose(args['email'], args['purpose']);
    }

    final defaultPinTheme = PinTheme(
      width: 64,
      height: 64,
      textStyle: getTextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryButtonColor,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.mintMedium, width: 1),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primaryButtonColor, width: 2),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.mintMedium, width: 1),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(title: 'Verify OTP', showBackButton: true),

              const SizedBox(height: 28),

              Text(
                'Enter The Code',
                style: getTextStyle2(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Check your e-mail and enter the code below.',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              Pinput(
                length: 6,
                controller: controller.otpController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                showCursor: true,
              ),

              const SizedBox(height: 60),

              Obx(
                () => CustomButton(
                  text: 'Verify'.tr,
                  onTap: controller.isLoading.value
                      ? null
                      : controller.verifyCode,
                  icon: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
