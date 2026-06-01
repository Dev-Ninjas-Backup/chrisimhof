import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/auth/widgets/icon_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTopBar extends StatelessWidget {
  const CustomTopBar({
    super.key,
    required this.title,
    this.showBackButton = true,
  });

  final String title;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 36,
          child: showBackButton
              ? IconTile(
                  icon: Icons.chevron_left_rounded,
                  onTap: () => Get.back(),
                )
              : null,
        ),
        Expanded(
          child: Text(
            title.tr,
            textAlign: TextAlign.center,
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ),
        ),
        IconTile(icon: Icons.settings_outlined, onTap: () {}),
      ],
    );
  }
}
