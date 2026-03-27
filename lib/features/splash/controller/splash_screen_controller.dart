import 'dart:async';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() {
    Timer(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.getSignInScreen());
    });
  }
}
