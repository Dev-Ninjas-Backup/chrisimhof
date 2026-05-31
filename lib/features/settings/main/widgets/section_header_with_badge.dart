import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeaderWithBadge extends StatelessWidget {
  const SectionHeaderWithBadge({required this.label, required this.badge});

  final String label;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 7),
      child: Row(
        children: [
          Text(
            label.tr.toUpperCase(),
            style: GoogleFonts.manrope(
              color: AppColors.textSoft,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.indigoSoft,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge.tr.toUpperCase(),
              style: GoogleFonts.manrope(
                color: AppColors.indigo,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
