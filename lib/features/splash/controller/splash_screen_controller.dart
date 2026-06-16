import 'dart:async';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() {
    Timer(const Duration(seconds: 3), () async {
      final String? accessToken =
          await SharedPreferencesHelper.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        Get.offAllNamed(AppRoutes.navbarScreen);
      } else {
        Get.offNamed(AppRoutes.getWelcomeScreen());
      }
    });
  }
}
