import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/auth/sign_in/screen/sign_in_screen.dart';
import 'package:chrisimhof/features/settings/main/model/profile_response_model.dart';
import 'package:chrisimhof/features/settings/main/service/logout_service.dart';
import 'package:chrisimhof/features/settings/main/service/profile_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final isLoading = false.obs;
  final isProfileLoading = false.obs;

  final LogoutService _logoutService = LogoutService();
  final ProfileService _profileService = ProfileService();

  final userName = ''.obs;
  final email = ''.obs;
  final avatarUrl = ''.obs;

  Future<void> getProfile() async {
    try {
      isProfileLoading.value = true;

      final String? accessToken =
          await SharedPreferencesHelper.getAccessToken();

      debugPrint('Profile access token: $accessToken');

      if (accessToken == null || accessToken.trim().isEmpty) {
        userName.value = '';
        email.value = '';
        avatarUrl.value = '';
        return;
      }

      final ProfileResponseModel response = await _profileService.getProfile(
        accessToken: accessToken,
      );

      if (response.success && response.data != null) {
        userName.value = response.data!.userName;
        email.value = response.data!.email;
        avatarUrl.value = response.data!.avatarUrl ?? '';
      }
    } catch (e) {
      debugPrint('Profile error: $e');
    } finally {
      isProfileLoading.value = false;
    }
  }

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

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }
}
