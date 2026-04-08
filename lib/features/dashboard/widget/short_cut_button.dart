import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:flutter/material.dart';

class ShortCutButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const ShortCutButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Color(0xFFF3F4F6),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 30, color: AppColors.primaryButtonColor),
      ),
    );
  }
}
