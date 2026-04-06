import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/image_path.dart';
import 'package:chrisimhof/features/settings/edit_profile/screen/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileCartWidget extends StatelessWidget {
  const ProfileCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String name = 'Avijit Das';
    String email = 'avijitavi338895@gmail.com';
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
          CircleAvatar(
            radius: 32,
            backgroundImage: AssetImage(ImagePath.profile),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                email,
                style: getTextStyle(
                  fontSize: 16,
                  color: AppColors.secondaryTextColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              Get.to(EditProfileScreen(name: name, email: email));
            },
            icon: Icon(Icons.edit, color: AppColors.primaryButtonColor),
          ),
        ],
      ),
    );
  }
}
