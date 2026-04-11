import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionPlanWidget extends StatelessWidget {
  final String planName;
  final String planPrice;
  final String buttonText;
  final Color buttonColor;
  final List<String> features;
  final VoidCallback onTap;
  final Color widgetColor;

  const SubscriptionPlanWidget({
    super.key,
    required this.planName,
    required this.planPrice,
    required this.buttonText,
    required this.buttonColor,
    required this.features,
    required this.onTap,
    required this.widgetColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: Get.width,
      decoration: BoxDecoration(
        color: widgetColor,
        border: Border.all(color: AppColors.borderColor, width: 1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            planName,
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            planPrice,
            style: getTextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 32),
          ...features.expand(
            (feature) => [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: AppColors.secondaryTextColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      feature,
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              if (feature != features.last) const SizedBox(height: 12),
            ],
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: buttonText,
            onTap: onTap,
            backgroundColor: buttonColor,
          ),
        ],
      ),
    );
  }
}
