import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';

class DeleteCheckboxItem extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool> onChanged;

  const DeleteCheckboxItem({
    super.key,
    required this.text,
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
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: value ? AppColors.white : AppColors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.rose, width: 2),
              ),
              child: value
                  ? Center(
                      child: Icon(Icons.check, size: 18, color: AppColors.rose),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: getTextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
