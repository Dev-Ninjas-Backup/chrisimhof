import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';

class SourceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final Color iconBackgroundColor;
  final Color? iconColor;
  final String badgeText;
  final Color badgeBackgroundColor;
  final Color badgeTextColor;
  final VoidCallback? onTap;

  const SourceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.iconBackgroundColor,
    this.iconColor,
    required this.badgeText,
    required this.badgeBackgroundColor,
    required this.badgeTextColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.gray200, width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 32,
                  height: 32,
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
                    title,
                    style: getTextStyle2(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMid,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: badgeBackgroundColor,
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Text(
                badgeText,
                style: getTextStyle2(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: badgeTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
