import 'dart:async';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/core/service/realtime/realtime_socket_service.dart';
import 'package:chrisimhof/features/auth/session/session.dart';
import 'package:chrisimhof/features/nav_bar/screen/navbar_screen.dart';
import 'package:chrisimhof/features/settings/main/service/profile_service.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/foundation.dart';
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
        try {
          final profileService = ProfileService();
          final profileResp = await profileService.getProfile(accessToken: accessToken);
          final profile = profileResp.data;

          if (profile != null) {
            // Fetch and save the calculator session ID at startup
            await SessionService().fetchAndStoreSessionId();
            await RealtimeSocketService().connectSocket();

            if (profile.safetyAcknowledgedAt == null) {
              Get.offAllNamed(AppRoutes.safetyScreen);
            } else if (profile.sleepTargetMinutes == null || 
            profile.chronotype == null || 
            profile.caffeineSensitivity == null || 
            profile.sportProfile == null) 
            {
              Get.offAllNamed(AppRoutes.baselineSetupScreen);
            } else if (profile.connectedSources == null) {
              Get.offAllNamed(AppRoutes.connectedSourcesScreen);
            } else if (profile.consentSettings == null) {
              Get.offAllNamed(AppRoutes.consentSettingsScreen);
            } else {
              Get.offAll(() => const NavbarScreen());
            }
          } else {
            Get.offAll(() => const NavbarScreen());
          }
        } catch (e) {
          debugPrint('Error fetching profile on splash onboarding check: $e');
          Get.offAll(() => const NavbarScreen());
        }
      } else {
        Get.offNamed(AppRoutes.getWelcomeScreen());
      }
    });
  }
}
