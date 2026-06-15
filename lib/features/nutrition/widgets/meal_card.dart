import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.type,
    required this.iconPath,
    required this.subtext,
    required this.isSelected,
    required this.activeColor,
    required this.bgColor,
    required this.textColor,
    required this.subtextColor,
    required this.onTap,
  });

  final String type;
  final String iconPath;
  final String subtext;
  final bool isSelected;
  final Color activeColor;
  final Color bgColor;
  final Color textColor;
  final Color subtextColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? activeColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                iconPath,
                height: 24,
                width: 24,
              ),
              const SizedBox(height: 8),
              Text(
                type,
                style: getTextStyle2(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtext,
                textAlign: TextAlign.center,
                style: getTextStyle2(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: subtextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}