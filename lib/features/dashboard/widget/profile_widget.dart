import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/settings/main/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileWidget extends StatelessWidget {
  final String? name;
  final String? imageUrl;

  const ProfileWidget({super.key, this.name, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());

    return Obx(() {
      final String displayName = name?.isNotEmpty == true
          ? name!
          : controller.fullName.value;
      final String displayImage = imageUrl?.isNotEmpty == true
          ? imageUrl!
          : controller.avatarUrl.value;

      return Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: displayImage.isNotEmpty
                ? NetworkImage(displayImage)
                : null,
            child: displayImage.isEmpty
                ? const Icon(Icons.person, size: 20, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello!',
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              Text(
                displayName.isNotEmpty ? displayName : 'User',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryTextColor,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
