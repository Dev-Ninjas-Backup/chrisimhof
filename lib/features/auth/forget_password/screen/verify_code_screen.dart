import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/auth/forget_password/controller/forget_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class VerifyCodeScreen extends StatelessWidget {
  final String? email;
  final String? purpose; // "register" or "forget_password"

  const VerifyCodeScreen({super.key, this.email, this.purpose = 'register'});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    // Store email and purpose in controller for verification
    controller.setEmailAndPurpose(email, purpose);

    final defaultPinTheme = PinTheme(
      width: 64,
      height: 64,
      textStyle: getTextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryButtonColor,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xff6CB485), width: 1),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primaryButtonColor, width: 2),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color(0xff6CB485), width: 1),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 176, left: 16, right: 16),
        child: Column(
          children: [
            Text(
              'Enter The Code',
              style: getTextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Check your e-mail and enter the code bellow.',
              style: getTextStyle(
                fontSize: 14,
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
              onCompleted: (pin) {
                debugPrint('OTP completed: $pin');
              },
              onChanged: (value) {
                debugPrint('OTP changed: $value');
              },
            ),
            const SizedBox(height: 60),
            Obx(
              () => CustomButton(
                text: 'Verify'.tr,
                onTap: controller.isLoading.value
                    ? null
                    : controller.verifyCode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
