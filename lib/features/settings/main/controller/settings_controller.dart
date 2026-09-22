import 'package:chrisimhof/features/auth/baseline_setup/service/baseline_setup_service.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/settings/main/model/profile_response_model.dart';
import 'package:chrisimhof/features/settings/main/service/logout_service.dart';
import 'package:chrisimhof/features/settings/main/service/profile_service.dart';
import 'package:chrisimhof/routes/app_routes.dart';
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

  // Baseline variables
  final sleepTargetMinutes = 465.obs;
  final chronotype = ''.obs;
  final caffeineSensitivity = ''.obs;
  final sportProfile = ''.obs;
  final defaultDailyMealTarget = 3.obs;
  final timeFormat = '24h'.obs;

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

      final profileData = response.data;
      if (response.success && profileData != null) {
        fullName.value = profileData.fullName;
        email.value = profileData.email;
        avatarUrl.value = profileData.avatarUrl ?? '';
        bio.value = profileData.bio ?? '';
        userId.value = profileData.userId.isNotEmpty
            ? profileData.userId
            : profileData.id;
        
        sleepTargetMinutes.value = profileData.sleepTargetMinutes ?? 465;
        chronotype.value = profileData.chronotype ?? '';
        caffeineSensitivity.value = profileData.caffeineSensitivity ?? '';
        sportProfile.value = profileData.sportProfile ?? '';

        if (profileData.defaultDailyMealTarget != null) {
          defaultDailyMealTarget.value = profileData.defaultDailyMealTarget!;
        }

        if (profileData.timeFormat != null && profileData.timeFormat!.isNotEmpty) {
          timeFormat.value = profileData.timeFormat!;
        }
        // Apply language from profile if provided (EN / FR)
        try {
          final localLang = await SharedPreferencesHelper.getLanguage();
          final String? lang = localLang?.toUpperCase() ?? profileData.language?.toUpperCase();
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
        EasyLoading.showInfo('You are already logged out.'.tr);
        Get.offAllNamed(AppRoutes.signInScreen);
        return;
      }

      final bool isSuccess = await _logoutService.logoutUser(
        accessToken: accessToken, // CHANGE: pass accessToken
        refreshToken: refreshToken,
      );

      if (isSuccess) {
        await SharedPreferencesHelper.clearAuthData();
        EasyLoading.showSuccess('Logged out successfully'.tr);
        Get.offAllNamed(AppRoutes.signInScreen);
      }
    } catch (e) {
      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Logout error: $e');

      if (errorMessage.toLowerCase().contains('invalid or expired token') ||
          errorMessage.toLowerCase().contains('unauthorized')) {
        await SharedPreferencesHelper.clearAuthData();
        EasyLoading.showInfo('Session expired. Please sign in again.'.tr);
        Get.offAllNamed(AppRoutes.signInScreen);
        return;
      }

      EasyLoading.showError(
        errorMessage.isEmpty
            ? 'Logout failed. Please try again.'.tr
            : errorMessage,
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> updateDefaultMealTarget(int target) async {
    try {
      EasyLoading.show(status: 'Saving...'.tr);
      final service = BaselineSetupService();
      final res = await service.updateBaseline(defaultDailyMealTarget: target);
      if (res['success'] == true) {
        defaultDailyMealTarget.value = target;
        EasyLoading.showSuccess('Default meal target updated'.tr);
      }
    } catch (e) {
      debugPrint('Error updating default meal target: $e');
      EasyLoading.showError('Failed to update meal target'.tr);
    }
  }

  Future<void> updateTimeFormat(String format) async {
    try {
      EasyLoading.show(status: 'Saving...'.tr);
      final service = BaselineSetupService();
      final res = await service.updateBaseline(timeFormat: format);
      if (res['success'] == true) {
        timeFormat.value = format;
        EasyLoading.showSuccess('Time format updated'.tr);
      }
    } catch (e) {
      debugPrint('Error updating time format: $e');
      EasyLoading.showError('Failed to update time format'.tr);
    }
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }
}
