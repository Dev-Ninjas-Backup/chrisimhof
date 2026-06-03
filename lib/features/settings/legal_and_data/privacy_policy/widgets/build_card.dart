import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';

class BuildCard extends StatelessWidget {
  const BuildCard({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSoft, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getTextStyle2(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            body,
            style: getTextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.textMid,
            ),
          ),
        ],
      ),
    );
  }
}
