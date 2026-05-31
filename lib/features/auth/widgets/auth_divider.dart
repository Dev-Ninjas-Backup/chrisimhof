import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class RyvenzaAuthDivider extends StatelessWidget {
  const RyvenzaAuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          const Expanded(child: Divider(color: AppColors.borderSoft)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'OR'.tr,
              style: GoogleFonts.manrope(
                color: AppColors.textSoft,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Expanded(child: Divider(color: AppColors.borderSoft)),
        ],
      ),
    );
  }
}
