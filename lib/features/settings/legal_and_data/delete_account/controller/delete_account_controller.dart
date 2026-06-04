import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/auth/sign_in/screen/sign_in_screen.dart';
import 'package:chrisimhof/features/settings/main/model/profile_response_model.dart';
import 'package:chrisimhof/features/settings/legal_and_data/delete_account/service/delete_account_service.dart';
import 'package:chrisimhof/features/settings/main/service/profile_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class DeleteAccountController extends GetxController {
  final RxBool understandCannotBeUndone = false.obs;
  final RxBool removePersonalProfile = false.obs;
  final isDeleteLoading = false.obs;

  final DeleteAccountService _deleteAccountService = DeleteAccountService();
  final ProfileService _profileService = ProfileService();

  final userId = ''.obs;

  bool get canDelete =>
      understandCannotBeUndone.value && removePersonalProfile.value;

  void toggleUnderstand(bool v) => understandCannotBeUndone.value = v;
  void toggleRemove(bool v) => removePersonalProfile.value = v;

  Future<void> deleteAccount() async {
    try {
      if (!canDelete) return;
      isDeleteLoading.value = true;

      final String? accessToken =
          await SharedPreferencesHelper.getAccessToken();

      if (accessToken == null || accessToken.trim().isEmpty) {
        await SharedPreferencesHelper.clearAuthData();
        EasyLoading.showInfo('Session expired. Please sign in again.');
        Get.offAllNamed('/signInScreen');
        return;
      }

      String currentUserId = userId.value;

      if (currentUserId.trim().isEmpty) {
        final ProfileResponseModel response = await _profileService.getProfile(
          accessToken: accessToken,
        );

        currentUserId = response.data?.userId.isNotEmpty == true
            ? response.data!.userId
            : response.data?.id ?? '';
        userId.value = currentUserId;
      }

      if (currentUserId.trim().isEmpty) {
        throw Exception('Unable to find user account.');
      }

      final bool isSuccess = await _deleteAccountService.deleteAccount(
        accessToken: accessToken,
        userId: currentUserId,
      );

      if (isSuccess) {
        await SharedPreferencesHelper.clearAuthData();
        EasyLoading.showSuccess('Account deleted successfully');
        Get.offAll(SignInScreen());
      }
    } catch (e) {
      final String errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Delete account error: $e');

      if (errorMessage.toLowerCase().contains('invalid or expired token') ||
          errorMessage.toLowerCase().contains('unauthorized')) {
        await SharedPreferencesHelper.clearAuthData();
        EasyLoading.showInfo('Session expired. Please sign in again.');
        Get.offAllNamed('/signInScreen');
        return;
      }

      EasyLoading.showError(
        errorMessage.isEmpty
            ? 'Delete account failed. Please try again.'
            : errorMessage,
      );
    } finally {
      isDeleteLoading.value = false;
    }
  }
}
