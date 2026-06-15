// ignore_for_file: deprecated_member_use

import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/settings/legal_and_data/consent_settings/widgets/custom_switch.dart';
import 'package:flutter/material.dart';

class ConsentToggleItem extends StatelessWidget {
  final String iconPath;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const ConsentToggleItem({
    super.key,
    required this.iconPath,
    required this.iconBackgroundColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSoft, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: getTextStyle2(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ),
                    CustomSwitch(value: value, onChanged: onChanged),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSoft,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
