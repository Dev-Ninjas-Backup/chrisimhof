import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/auth/widgets/custom_text_field.dart';
import 'package:chrisimhof/features/settings/edit_profile/controller/edit_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditProfileController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 78.0, left: 16, right: 16),
          child: Column(
            children: [
              const CustomAppBar(title: 'Edit Profile', showBackButton: true),
              const SizedBox(height: 24),
              Stack(
                children: [
                  Obx(
                    () => CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.greyShade200,
                      backgroundImage: controller.selectedImage.value != null
                          ? FileImage(controller.selectedImage.value!)
                                as ImageProvider
                          : (controller.currentAvatarUrl.value.isNotEmpty
                                ? NetworkImage(
                                    controller.currentAvatarUrl.value,
                                  )
                                : null),
                      child:
                          controller.selectedImage.value == null &&
                              controller.currentAvatarUrl.value.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 28,
                              color: AppColors.grey,
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: -15,
                    right: 0,
                    left: 0,
                    child: IconButton(
                      onPressed: controller.pickImage,
                      icon: const Icon(
                        Icons.edit,
                        color: AppColors.primaryButtonColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              CustomTextField(
                label: 'Full Name'.tr,
                hintText: 'Enter your full name'.tr,
                isRequired: true,
                controller: controller.fullNameController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Bio'.tr,
                hintText: 'Write something about yourself'.tr,
                isRequired: false,
                controller: controller.bioController,
              ),
              const SizedBox(height: 32),
              Obx(
                () => CustomButton(
                  text: controller.isLoading.value
                      ? 'Updating...'.tr
                      : 'Update Profile'.tr,
                      icon: null,
                  onTap: controller.isLoading.value
                      ? null
                      : controller.updateProfile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
