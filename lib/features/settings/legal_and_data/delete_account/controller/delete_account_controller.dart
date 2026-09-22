import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/settings/main/model/profile_response_model.dart';
import 'package:chrisimhof/features/settings/legal_and_data/delete_account/service/delete_account_service.dart';
import 'package:chrisimhof/features/settings/legal_and_data/delete_account/widgets/delete_account_otp_bottom_sheet.dart';
import 'package:chrisimhof/features/settings/main/service/profile_service.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/material.dart';
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

  Future<String?> _resolveUserId(String accessToken) async {
    if (userId.value.trim().isNotEmpty) return userId.value;

    final ProfileResponseModel response = await _profileService.getProfile(
      accessToken: accessToken,
    );

    final currentUserId = response.data?.userId.isNotEmpty == true
        ? response.data!.userId
        : response.data?.id ?? '';
    userId.value = currentUserId;
    return currentUserId;
  }

  Future<void> requestOtpAndShowModal(BuildContext context) async {
    if (!canDelete) return;

    try {
      EasyLoading.show(status: 'Requesting verification code...'.tr);
      final String? accessToken = await SharedPreferencesHelper.getAccessToken();

      if (accessToken == null || accessToken.trim().isEmpty) {
        await SharedPreferencesHelper.clearAuthData();
        EasyLoading.showInfo('Session expired. Please sign in again.'.tr);
        Get.offAllNamed(AppRoutes.signInScreen);
        return;
      }

      await _resolveUserId(accessToken);

      final success = await _deleteAccountService.requestDeletionOtp(
        accessToken: accessToken,
      );

      EasyLoading.dismiss();

      if (success && context.mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) => DeleteAccountOtpBottomSheet(controller: this),
        );
      }
    } catch (e) {
      debugPrint('requestOtpAndShowModal error: $e');
      final String errorMessage = e.toString().replaceFirst('Exception: ', '');
      EasyLoading.showError(
        errorMessage.isEmpty
            ? 'Failed to request verification code. Please try again.'.tr
            : errorMessage,
      );
    }
  }

  Future<void> resendOtp() async {
    try {
      EasyLoading.show(status: 'Resending code...'.tr);
      final String? accessToken = await SharedPreferencesHelper.getAccessToken();

      if (accessToken == null || accessToken.trim().isEmpty) {
        EasyLoading.showError('Session expired. Please sign in again.'.tr);
        return;
      }

      await _deleteAccountService.requestDeletionOtp(accessToken: accessToken);
      EasyLoading.showSuccess('A new verification code has been sent.'.tr);
    } catch (e) {
      debugPrint('resendOtp error: $e');
      EasyLoading.showError('Failed to resend code. Please try again.'.tr);
    }
  }

  Future<void> confirmDeletionWithOtp(String otp) async {
    try {
      isDeleteLoading.value = true;
      EasyLoading.show(status: 'Deleting account...'.tr);

      final String? accessToken = await SharedPreferencesHelper.getAccessToken();

      if (accessToken == null || accessToken.trim().isEmpty) {
        await SharedPreferencesHelper.clearAuthData();
        EasyLoading.showInfo('Session expired. Please sign in again.'.tr);
        Get.offAllNamed(AppRoutes.signInScreen);
        return;
      }

      final currentUserId = await _resolveUserId(accessToken);
      if (currentUserId == null || currentUserId.trim().isEmpty) {
        throw Exception('Unable to find user account.');
      }

      final bool isSuccess = await _deleteAccountService.deleteAccount(
        accessToken: accessToken,
        userId: currentUserId,
        otp: otp,
      );

      if (isSuccess) {
        await SharedPreferencesHelper.clearAuthData();
        EasyLoading.showSuccess('Account deleted successfully'.tr);
        Get.offAllNamed(AppRoutes.signInScreen);
      }
    } catch (e) {
      final String errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Confirm deletion error: $e');

      if (errorMessage.toLowerCase().contains('invalid or expired token') ||
          errorMessage.toLowerCase().contains('unauthorized')) {
        await SharedPreferencesHelper.clearAuthData();
        EasyLoading.showInfo('Session expired. Please sign in again.'.tr);
        Get.offAllNamed(AppRoutes.signInScreen);
        return;
      }

      EasyLoading.showError(
        errorMessage.isEmpty
            ? 'Delete account failed. Please try again.'.tr
            : errorMessage,
      );
    } finally {
      isDeleteLoading.value = false;
    }
  }
}
