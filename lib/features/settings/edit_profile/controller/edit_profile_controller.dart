import 'dart:io';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/settings/edit_profile/model/update_profile_response_model.dart';
import 'package:chrisimhof/features/settings/edit_profile/service/edit_profile_service.dart';
import 'package:chrisimhof/features/settings/main/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  Rx<File?> selectedImage = Rx<File?>(null);
  final isLoading = false.obs;
  final currentAvatarUrl = ''.obs;

  final fullNameController = TextEditingController();
  final bioController = TextEditingController();

  final currentEmail = ''.obs;

  final EditProfileService _editProfileService = EditProfileService();

  UpdateProfileResponseModel? updateProfileResponse;

  @override
  void onInit() {
    super.onInit();

    // Load current profile data from SettingsController
    if (Get.isRegistered<SettingsController>()) {
      final settingsController = Get.find<SettingsController>();
      fullNameController.text = settingsController.fullName.value;
      currentEmail.value = settingsController.email.value;
      currentAvatarUrl.value = settingsController.avatarUrl.value;
      bioController.text = settingsController.bio.value;
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } on Exception catch (e) {
      if (e.toString().contains('channel-error')) {
        Get.snackbar(
          'Error',
          'Image picker channel error. Run: flutter clean && flutter pub get',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
      } else {
        Get.snackbar(
          'Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;

      final String? accessToken =
          await SharedPreferencesHelper.getAccessToken();

      if (accessToken == null || accessToken.trim().isEmpty) {
        EasyLoading.showError('Unauthorized. Please sign in again.');
        return;
      }

      final response = await _editProfileService.updateProfile(
        accessToken: accessToken,
        fullName: fullNameController.text,
        bio: bioController.text,
        imageFile: selectedImage.value,
      );

      updateProfileResponse = response;

      if (response.success && response.data != null) {
        EasyLoading.showSuccess(response.message);

        // Print response data
        debugPrint('=== UPDATE PROFILE RESPONSE ===');
        debugPrint('Full Name: ${response.data!.fullName}');
        debugPrint('Bio: ${response.data!.bio}');
        debugPrint('Avatar URL: ${response.data!.avatarUrl}');
        debugPrint('Email: ${response.data!.email}');
        debugPrint('Account Status: ${response.data!.accountStatus}');
        debugPrint('================================');

        if (Get.isRegistered<SettingsController>()) {
          final settingsController = Get.find<SettingsController>();

          settingsController.fullName.value = response.data!.fullName ?? '';
          settingsController.email.value = response.data!.email;
          settingsController.avatarUrl.value = response.data!.avatarUrl ?? '';
        }

        Get.back();
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      EasyLoading.showError(
        errorMessage.isEmpty ? 'Failed to update profile' : errorMessage,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    bioController.dispose();
    //avatarUrlController.dispose();
    super.onClose();
  }
}
