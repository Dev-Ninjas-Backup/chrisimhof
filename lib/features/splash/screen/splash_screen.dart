import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/image_path.dart';
import 'package:chrisimhof/features/splash/controller/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashScreenController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Image.asset(ImagePath.appLogo, width: 190, height: 114),
      ),
    );
  }
}
