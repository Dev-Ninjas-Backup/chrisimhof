import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/image_path.dart';
import 'package:chrisimhof/features/nav_bar/screen/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicalDisclaimerScreen extends StatelessWidget {
  const MedicalDisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 34),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset(ImagePath.disclaimer, height: 106, width: 106),
            SizedBox(height: 40),
            Text(
              'Medical Disclaimer'.tr,
              style: getTextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
              ),
            ),
            SizedBox(height: 32),
            Text(
              'RYVENZA provides lifestyle and performance recommendations based on user inputs.  It is not a medical device and does not provide medical advice, diagnosis, or treatment.  The information provided by the application is for informational and educational  purposes only.  Users should always consult a qualified healthcare professional for medical concerns.  Use of the application is at your own risk.'
                  .tr,
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            CustomButton(
              text: 'Continue'.tr,
              onTap: () {
                Get.offAll(NavbarScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
