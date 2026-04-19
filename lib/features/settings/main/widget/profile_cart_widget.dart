import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/settings/edit_profile/screen/edit_profile_screen.dart';
import 'package:chrisimhof/features/settings/main/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileCartWidget extends StatelessWidget {
  ProfileCartWidget({super.key});

  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final String name = controller.userName.value.isNotEmpty
          ? controller.userName.value
          : 'User Name'.tr;

      final String userEmail = controller.email.value.isNotEmpty
          ? controller.email.value
          : 'Email Address'.tr;

      final String imageUrl = controller.avatarUrl.value;

      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 24),
        width: Get.width,
        height: 96,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            // CHANGE: if image null/empty then show avatar icon
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : null,
              child: imageUrl.isEmpty
                  ? const Icon(Icons.person, size: 32, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userEmail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      fontSize: 16,
                      color: AppColors.secondaryTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Get.to(
                  () => EditProfileScreen(name: name, email: userEmail),
                  arguments: {
                    'name': name,
                    'email': userEmail,
                    'bio': '',
                    'avatarUrl': imageUrl,
                  },
                );
              },
              icon: Icon(Icons.edit, color: AppColors.primaryButtonColor),
            ),
          ],
        ),
      );
    });
  }
}
