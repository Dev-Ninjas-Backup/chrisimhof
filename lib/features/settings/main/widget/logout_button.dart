import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.offAllNamed('/signInScreen'),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.only(bottom: 24, top: 24),
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10000),
          border: Border.all(width: 1, color: AppColors.logoutBorderColor),
        ),
        child: Text(
          'Logout',
          textAlign: TextAlign.center,
          style: getTextStyle(
            color: AppColors.logoutBorderColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
