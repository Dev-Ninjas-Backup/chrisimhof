import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';

class CaffeineCutOffCard extends StatelessWidget {
  const CaffeineCutOffCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.amber, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: AppColors.amber, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryTextColor,
                ),
                children: [
                  TextSpan(
                    text: 'Cut-off 16:30',
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.amberDark,
                    ),
                  ),
                  TextSpan(
                    text: ' — protect\ntonight\'s sleep window.',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
