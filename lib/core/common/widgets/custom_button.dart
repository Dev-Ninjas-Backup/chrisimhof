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
  final bool? plusIcon;
  final IconData? showIcon;

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
    this.plusIcon,
    this.showIcon ,
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
          foregroundColor: textColor ?? Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: borderWidth != null
                ? BorderSide(
                    width: borderWidth!.toDouble(),
                    color: borderColor ?? Color(0xFFE5E5E5),
                  )
                : BorderSide.none,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (plusIcon == true) const SizedBox(width: 4),
              if (plusIcon == true)
                Icon(showIcon, size: 20, color: iconColor ?? Colors.black),
              Text(
                text.tr,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? Colors.black,
                ),
              ),
              if (icon != null) const SizedBox(width: 4),
              if (icon != null)
                Icon(icon, size: 20, color: iconColor ?? Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
