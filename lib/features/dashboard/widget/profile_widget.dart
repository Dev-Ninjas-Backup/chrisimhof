import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/image_path.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String name;
  const ProfileWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(ImagePath.profile),
        ),
        SizedBox(width: 16),
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
              name,
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
  }
}
