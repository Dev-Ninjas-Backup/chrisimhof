import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Get.back,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFF3F4F6),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryButtonColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}
