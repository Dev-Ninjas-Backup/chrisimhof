import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/auth/widgets/icon_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  final bool showBackButton;
  final bool? showMoreButton;
  final bool? showSettingsButton;
  final bool? showLogo;
  const CustomAppBar({
    super.key,
    this.title,
    required this.showBackButton,
    this.showMoreButton,
    this.showSettingsButton,
    this.showLogo,
  });
  @override
  Widget build(BuildContext context) {
    final showCenter =
        showLogo == true || (title != null && title!.trim().isNotEmpty);
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                showMoreButton == true
                    ? GestureDetector(
                        onTap: () {},
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: IconTile(icon: Icons.more_horiz, onTap: () {}),
                        ),
                      )
                    : showSettingsButton == true
                    ? GestureDetector(
                        onTap: () {},
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: IconTile(
                            icon: Icons.settings_outlined,
                            onTap: () {},
                          ),
                        ),
                      )
                    : const SizedBox(width: 36, height: 36),
              ],
            ),
          ],
        ),
        if (showCenter) _buildCenter(),
      ],
    );
  }

  Widget _buildCenter() {
    if (showLogo == true) {
      return const Image(
        image: AssetImage(IconPath.dashboardAppLogo),
        width: 50,
        height: 30,
      );
    }

    if (title != null && title!.trim().isNotEmpty) {
      return Text(
        title!,
        style: getTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
