import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class RyvenzaAuthButton extends StatelessWidget {
  const RyvenzaAuthButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isMint = false,
    this.icon = Icons.chevron_right_rounded,
  });

  final String text;
  final VoidCallback? onTap;
  final bool isMint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final Color background = isMint
        ? AppColors.primaryButtonColor
        : AppColors.primaryTextColor;
    final Color foreground = isMint ? const Color(0xFF0A1410) : Colors.white;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          disabledBackgroundColor: background.withValues(alpha: 0.55),
          disabledForegroundColor: foreground.withValues(alpha: 0.65),
          elevation: 0,
          shadowColor: background.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text.tr,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 6),
            Icon(icon, size: 18),
          ],
        ),
      ),
    );
  }
}

class RyvenzaSecondaryButton extends StatelessWidget {
  const RyvenzaSecondaryButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryTextColor,
          backgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.borderSoft),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text.tr,
          style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
