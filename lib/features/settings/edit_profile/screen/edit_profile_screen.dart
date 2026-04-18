import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_text_form_field.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/image_path.dart';
import 'package:chrisimhof/features/settings/edit_profile/controller/edit_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  final String name;
  final String email;

  const EditProfileScreen({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

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
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: controller.selectedImage.value != null
                          ? FileImage(controller.selectedImage.value!)
                                as ImageProvider
                          : (controller.currentAvatarUrl.value.isNotEmpty
                                ? NetworkImage(
                                    controller.currentAvatarUrl.value,
                                  )
                                : const AssetImage(ImagePath.profile)
                                      as ImageProvider),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    top: 60,
                    child: IconButton(
                      onPressed: controller.pickImage,
                      icon: Icon(
                        Icons.edit,
                        color: AppColors.primaryButtonColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  email,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                label: 'Full Name',
                hintText: 'Enter your full name',
                isRequired: true,
                controller: controller.fullNameController,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                label: 'Bio',
                hintText: 'Write something about yourself',
                isRequired: true,
                controller: controller.bioController,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                label: 'Avatar Url',
                hintText: 'Enter avatar url',
                isRequired: false,
                controller: controller.avatarUrlController,
              ),
              const SizedBox(height: 32),
              Obx(
                () => CustomButton(
                  text: controller.isLoading.value
                      ? 'Updating...'
                      : 'Update Profile',
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
