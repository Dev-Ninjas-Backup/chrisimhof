import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsTopBar extends StatelessWidget {
  const SettingsTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Row(
        children: [
          const SizedBox(width: 36),
          Expanded(
            child: Text(
              'Settings'.tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: AppColors.primaryTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.subtle,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.more_horiz_rounded,
              color: AppColors.primaryTextColor,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
