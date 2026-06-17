import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildMenuItem extends StatelessWidget {
  const BuildMenuItem({
    super.key,
    required this.iconPath,
    required this.iconBackgroundColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
    this.containerHeight,
    this.containerWidth,
    this.borderRadius,
    this.iconSize,
  });

  final String iconPath;
  final Color iconBackgroundColor;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final double? containerHeight;
  final double? containerWidth;
  final double? borderRadius;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          border: Border.all(color: AppColors.borderSoft, width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: containerWidth ?? 56.0,
              height: containerHeight ?? 56.0,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: iconSize ?? 24.0,
                  height: iconSize ?? 24.0,
                  color: iconColor,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.tr,
                    style: getTextStyle2(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  Text(
                    subtitle.tr,
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMid,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, color: AppColors.textSoft, size: 16),
          ],
        ),
      ),
    );
  }
}
