import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/auth/sign_in/screen/sign_in_screen.dart';
import 'package:chrisimhof/features/settings/main/service/logout_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final isLoading = false.obs;

  final LogoutService _logoutService = LogoutService();

  Future<void> logout() async {
    try {
      isLoading.value = true;

      final String? accessToken =
          await SharedPreferencesHelper.getAccessToken();

      final String? refreshToken =
          await SharedPreferencesHelper.getRefreshToken();

      debugPrint('Saved access token: $accessToken');
      debugPrint('Saved refresh token: $refreshToken');

      if (accessToken == null ||
          accessToken.trim().isEmpty ||
          refreshToken == null ||
          refreshToken.trim().isEmpty) {
        await SharedPreferencesHelper.clearAuthData();
        EasyLoading.showInfo('You are already logged out.');
        Get.offAllNamed('/signInScreen');
        return;
      }

      final bool isSuccess = await _logoutService.logoutUser(
        accessToken: accessToken, // CHANGE: pass accessToken
        refreshToken: refreshToken,
      );

      if (isSuccess) {
        await SharedPreferencesHelper.clearAuthData();
        EasyLoading.showSuccess('Logged out successfully');
        Get.offAll(SignInScreen());
      }
    } catch (e) {
      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Logout error: $e');

      if (errorMessage.toLowerCase().contains('invalid or expired token') ||
          errorMessage.toLowerCase().contains('unauthorized')) {
        await SharedPreferencesHelper.clearAuthData();
        EasyLoading.showInfo('Session expired. Please sign in again.');
        Get.offAllNamed('/signInScreen');
        return;
      }

      EasyLoading.showError(
        errorMessage.isEmpty
            ? 'Logout failed. Please try again.'
            : errorMessage,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
