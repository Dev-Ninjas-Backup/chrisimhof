import 'dart:async';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/core/service/realtime/realtime_socket_service.dart';
import 'package:chrisimhof/features/auth/session/session.dart';
import 'package:chrisimhof/features/auth/sign_in/service/sign_in_service.dart';
import 'package:chrisimhof/features/nav_bar/screen/navbar_screen.dart';
import 'package:chrisimhof/features/settings/main/model/profile_response_model.dart';
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
      final String? refreshToken =
          await SharedPreferencesHelper.getRefreshToken();
      print("refreshToken: $refreshToken");
      print("accessToken: $accessToken");
      if (accessToken != null &&
          accessToken.isNotEmpty &&
          refreshToken != null &&
          refreshToken.isNotEmpty) {
        final profileService = ProfileService();
        try {
          final profileResp = await profileService.getProfile(
            accessToken: accessToken,
          );
          final profile = profileResp.data;

          if (profile != null) {
            await _handleOnboardingCheckAndNavigation(profile);
          } else {
            Get.offAll(() => const NavbarScreen());
          }
        } on UnauthorizedException catch (e) {
          debugPrint('Profile API returned expired/unauthorized token error: $e. Attempting token refresh...');
          try {
            final signInService = SignInService();
            final refreshResponse = await signInService.refreshToken(
              refreshToken: refreshToken,
            );
            debugPrint('Refresh response: success=${refreshResponse.success}, data=${refreshResponse.data != null ? "exists" : "null"}');
            if (refreshResponse.success && refreshResponse.data != null) {
              final newAccessToken = refreshResponse.data!.accessToken;
              final newRefreshToken = refreshResponse.data!.refreshToken;

              // Save new tokens
              await SharedPreferencesHelper.saveAccessToken(newAccessToken);
              await SharedPreferencesHelper.saveRefreshToken(newRefreshToken);

              debugPrint('Token refreshed successfully. Fetching profile with new token...');
              final retryProfileResp = await profileService.getProfile(
                accessToken: newAccessToken,
              );
              final retryProfile = retryProfileResp.data;

              if (retryProfile != null) {
                await _handleOnboardingCheckAndNavigation(retryProfile);
              } else {
                Get.offAll(() => const NavbarScreen());
              }
            } else {
              debugPrint('Token refresh response was not successful. Redirecting to welcome screen.');
              await SharedPreferencesHelper.clearAuthData();
              Get.offNamed(AppRoutes.getWelcomeScreen());
            }
          } catch (refreshErr) {
            debugPrint('Failed to refresh token: $refreshErr. Redirecting to welcome screen.');
            await SharedPreferencesHelper.clearAuthData();
            Get.offNamed(AppRoutes.getWelcomeScreen());
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

  Future<void> _handleOnboardingCheckAndNavigation(ProfileData profile) async {
    // Fetch and save the calculator session ID at startup
    await SessionService().fetchAndStoreSessionId();
    await RealtimeSocketService().connectSocket();

    if (profile.safetyAcknowledgedAt == null) {
      Get.offAllNamed(AppRoutes.safetyScreen);
    } else if (profile.sleepTargetMinutes == null ||
        profile.chronotype == null ||
        profile.caffeineSensitivity == null ||
        profile.sportProfile == null) {
      Get.offAllNamed(AppRoutes.baselineSetupScreen);
    } else if (profile.connectedSources == null) {
      Get.offAllNamed(AppRoutes.connectedSourcesScreen);
    } else if (profile.consentSettings == null) {
      Get.offAllNamed(AppRoutes.consentSettingsScreen);
    } else {
      Get.offAll(() => const NavbarScreen());
    }
  }
}
