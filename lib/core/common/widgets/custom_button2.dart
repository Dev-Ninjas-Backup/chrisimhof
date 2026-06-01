import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAuthButton extends StatelessWidget {
  const CustomAuthButton({
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
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: foreground,
              ),
            ),
            const SizedBox(width: 6),
            Icon(icon, size: 20),
          ],
        ),
      ),
    );
  }
}

class CustomSecondaryButton extends StatelessWidget {
  const CustomSecondaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.side = const BorderSide(color: AppColors.borderSoft),
    this.foregroundColor = AppColors.primaryTextColor,
  });

  final String text;
  final VoidCallback? onTap;
  final BorderSide side;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: Colors.white,
          side: side,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text.tr,
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: foregroundColor,
          ),
        ),
      ),
    );
  }
}
