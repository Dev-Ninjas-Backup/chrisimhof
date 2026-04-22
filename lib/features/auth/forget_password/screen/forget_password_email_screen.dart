import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_text_form_field.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
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
      body: Padding(
        padding: EdgeInsets.only(top: 176, left: 16, right: 16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Forget Password'.tr,
                style: getTextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Don’t worry it happens. Please enter the e-mail address.'.tr,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48),
              CustomTextFormField(
                label: 'Email'.tr,
                hintText: 'Enter your email'.tr,
                isRequired: true,
                controller: controller.emailController,
                validator: (value) => controller.validateEmail(value),
              ),
              SizedBox(height: 60),
              Obx(
                () => CustomButton(
                  text: 'Sign In'.tr,
                  onTap: controller.isLoading.value
                      ? null
                      : () {
                          if (formKey.currentState!.validate()) {
                            controller.sendCode();
                          }
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
