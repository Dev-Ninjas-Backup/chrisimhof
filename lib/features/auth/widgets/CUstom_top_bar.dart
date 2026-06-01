import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/auth/widgets/icon_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
      child: Row(
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
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
              ),
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }
}
