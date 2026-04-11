import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
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
      body: Padding(
        padding: const EdgeInsets.only(top: 78.0, left: 16, right: 16),
        child: Column(
          children: [
            CustomAppBar(title: 'Edit Profile', showBackButton: true),
            SizedBox(height: 24),
            Stack(
              children: [
                Obx(
                  () => CircleAvatar(
                    radius: 40,
                    backgroundImage: controller.selectedImage.value != null
                        ? FileImage(controller.selectedImage.value!)
                              as ImageProvider
                        : AssetImage(ImagePath.profile),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  top: 60,
                  child: IconButton(
                    onPressed: () => controller.pickImage(),
                    icon: Icon(
                      Icons.edit,
                      color: AppColors.primaryButtonColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            CustomTextFormField(
              label: 'Full Name',
              hintText: name,
              isRequired: true,
            ),
            SizedBox(height: 16),
            CustomTextFormField(
              label: 'Email',
              hintText: email,
              isRequired: true,
            ),
          ],
        ),
      ),
    );
  }
}
