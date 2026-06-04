import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/auth/sign_in/screen/sign_in_screen.dart';
import 'package:chrisimhof/features/settings/main/model/profile_response_model.dart';
import 'package:chrisimhof/features/settings/main/service/logout_service.dart';
import 'package:chrisimhof/features/settings/main/service/profile_service.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:chrisimhof/core/common/controller/language_controller.dart';

class SettingsController extends GetxController {
  final isLoading = false.obs;
  final isProfileLoading = false.obs;
  final isDeleteLoading = false.obs;

  final LogoutService _logoutService = LogoutService();
  final ProfileService _profileService = ProfileService();

  final fullName = ''.obs;
  final email = ''.obs;
  final avatarUrl = ''.obs;
  final bio = ''.obs;
  final userId = ''.obs;

  Future<void> getProfile() async {
    try {
      isProfileLoading.value = true;

      final String? accessToken =
          await SharedPreferencesHelper.getAccessToken();

      debugPrint('Profile access token: $accessToken');

      if (accessToken == null || accessToken.trim().isEmpty) {
        fullName.value = '';
        email.value = '';
        avatarUrl.value = '';
        userId.value = '';
        return;
      }

      final ProfileResponseModel response = await _profileService.getProfile(
        accessToken: accessToken,
      );

      if (response.success && response.data != null) {
        fullName.value = response.data!.fullName;
        email.value = response.data!.email;
        avatarUrl.value = response.data!.avatarUrl ?? '';
        bio.value = response.data!.bio ?? '';
        userId.value = response.data!.userId.isNotEmpty
            ? response.data!.userId
            : response.data!.id;
        // Apply language from profile if provided (EN / FR)
        try {
          final String? lang = response.data!.language?.toUpperCase();
          if (lang != null && (lang == 'FR' || lang == 'EN')) {
            // Update app locale without calling the backend
            if (lang == 'FR') {
              Get.updateLocale(const Locale('fr', 'FR'));
            } else {
              Get.updateLocale(const Locale('en', 'US'));
            }

            // Update LanguageController selection if available
            try {
              final lc = Get.find<LanguageController>();
              lc.selectedLanguage.value = lang;
            } catch (_) {
              // ignore if controller not found
            }
          }
        } catch (e) {
          // ignore language update errors
        }
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
