import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/auth/widgets/icon_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final bool? showMoreButton;
  const CustomAppBar({
    super.key,
    required this.title,
    required this.showBackButton,
    this.showMoreButton,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        showBackButton == true
            ? GestureDetector(
                onTap: Get.back,
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: IconTile(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => Get.back(),
                  ),
                ),
              )
            : const SizedBox(width: 36, height: 36),
        Text(
          title,
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
          ),
        ),
        showMoreButton == true
            ? GestureDetector(
                onTap: () {},
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: IconTile(icon: Icons.more_horiz, onTap: () {}),
                ),
              )
            : const SizedBox(width: 36, height: 36),
      ],
    );
  }
}
