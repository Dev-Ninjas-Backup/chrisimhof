import 'package:flutter/material.dart';
import 'package:chrisimhof/core/const/app_colors.dart';

class SocialButton extends StatelessWidget {
  final Color borderColor;
  final Color backgroundColor;
  final String imagePath;
  final VoidCallback? onTap;

  const SocialButton({
    super.key,
    this.borderColor = AppColors.borderColor,
    this.backgroundColor = AppColors.white,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
