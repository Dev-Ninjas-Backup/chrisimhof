import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:flutter/material.dart';

class SubscriptionPlanWidget extends StatelessWidget {
  final String planName;
  final String planPrice;
  final List<String> features;
  final bool isSelected;
  final String description;
  final VoidCallback? onTap;

  const SubscriptionPlanWidget({
    super.key,
    required this.planName,
    required this.planPrice,
    required this.features,
    required this.isSelected,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(32),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryButtonColor : AppColors.white,
          border: Border.all(
            color: isSelected
                ? AppColors.primaryButtonColor
                : AppColors.borderSoft,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan name
            Text(
              planName,
              style: getTextStyle2(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.black : AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 4),
            // Plan price
            Text(
              planPrice,
              style: getTextStyle2(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.black : AppColors.primaryButtonColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: getTextStyle2(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: isSelected ? AppColors.black : AppColors.textMid,
              ),
            ),
            const SizedBox(height: 20),
            if (isSelected)
              ...features.map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(IconPath.rectangle, width: 10, height: 10),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          feature,
                          style: getTextStyle2(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppColors.black
                                : AppColors.primaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
