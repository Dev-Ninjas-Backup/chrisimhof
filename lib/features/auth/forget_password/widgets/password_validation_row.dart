import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordValidationRow extends StatelessWidget {
  final String text;
  final bool isMet;

  const PasswordValidationRow({
    super.key,
    required this.text,
    required this.isMet,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isMet) ...[
          Icon(Icons.check, color: AppColors.primaryButtonColor),
          const SizedBox(width: 10),
        ],
        Text(
          text.tr,
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryTextColor,
          ),
        ),
      ],
    );
  }
}
