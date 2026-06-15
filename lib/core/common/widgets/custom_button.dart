import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final Color? borderColor;
  final int? borderWidth;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.borderColor,
    this.borderWidth,
    this.icon = Icons.chevron_right_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryButtonColor,
          foregroundColor: textColor ?? AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: borderWidth != null
                ? BorderSide(
                    width: borderWidth!.toDouble(),
                    color: borderColor ?? AppColors.greyBorderAlt,
                  )
                : BorderSide.none,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text.tr,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? AppColors.black,
                ),
              ),
              if (icon != null) const SizedBox(width: 4),
              if (icon != null)
                Icon(icon, size: 20, color: iconColor ?? AppColors.black),
            ],
          ),
        ),
      ),
    );
  }
}
