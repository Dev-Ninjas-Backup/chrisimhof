import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';

class CalculatorTabButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const CalculatorTabButton({
    super.key,
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryButtonColor : Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10000),
        ),
        child: Text(
          title,
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.white : AppColors.primaryTextColor,
          ),
        ),
      ),
    );
  }
}
