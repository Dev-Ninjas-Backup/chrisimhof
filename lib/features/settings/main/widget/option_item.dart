import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool showPremiumBadge;
  const OptionItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.showPremiumBadge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      width: Get.width,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black, size: 24),
          SizedBox(width: 16),
          Text(
            title,
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryTextColor,
            ),
          ),
          Spacer(),
          if (showPremiumBadge)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryButtonColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Premium'.tr,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextColor,
                ),
              ),
            ),
          SizedBox(width: 16),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF3F4F6),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryTextColor,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
