import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/auth/forget_password/controller/forget_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VerifyCodeScreen extends StatelessWidget {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());

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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => Container(
                  width: 79,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xff6CB485),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: controller.otpControllers[index],
                    focusNode: controller.otpFocusNodes[index],
                    keyboardType: TextInputType.number,
                    textInputAction: index == 3
                        ? TextInputAction.done
                        : TextInputAction.next,
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    style: getTextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryButtonColor,
                    ),
                    cursorColor: AppColors.primaryTextColor,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                      isCollapsed: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                    onChanged: (value) {
                      controller.onOtpChanged(value, index);
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 60),
            CustomButton(text: 'Verify', onTap: controller.verifyCode),
          ],
        ),
      ),
    );
  }
}
