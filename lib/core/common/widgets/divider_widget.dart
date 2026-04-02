import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Color(0xFFD5D7DA), thickness: 1)),
        const SizedBox(width: 8),
        Text(
          'Or',
          style: getTextStyle(
            fontSize: 14,
            color: AppColors.secondaryTextColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Divider(color: Color(0xFFD5D7DA), thickness: 1)),
      ],
    );
  }
}
