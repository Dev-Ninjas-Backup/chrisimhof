import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/image_path.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImagePath.successImage, height: 164, width: 164),
            SizedBox(height: 12),
            Text(
              'Success!',
              style: getTextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your password has been changed successfully',
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor,
              ),
            ),
            SizedBox(height: 70),
            CustomButton(
              text: 'Continue',
              onTap: () {
                Get.offNamed('/signInScreen');
              },
            ),
          ],
        ),
      ),
    );
  }
}
