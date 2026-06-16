import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';

class DayBubble extends StatelessWidget {
  final int index;
  final String dayLabel;
  final String shift;
  final bool isToday;
  final VoidCallback onTap;

  const DayBubble({
    super.key,
    required this.index,
    required this.dayLabel,
    required this.shift,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textCol;
    if (shift == 'N') {
      bg = AppColors.indigoSoft;
      textCol = AppColors.indigo;
    } else if (shift == 'Off') {
      bg = AppColors.mintSoft2;
      textCol = AppColors.secondaryButtonColor;
    } else if (shift == 'D') {
      bg = AppColors.amberSoft3;
      textCol = AppColors.orangeAccent2;
    } else {
      // Evening 'E'
      bg = AppColors.lavenderSoft;
      textCol = AppColors.violet;
    }

    return Expanded(
      child: Column(
        children: [
          Text(
            dayLabel,
            style: getTextStyle(
              fontSize: 11,
              fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
              color: isToday
                  ? AppColors.primaryTextColor
                  : AppColors.selectionGray,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: bg,
                border: isToday
                    ? Border.all(color: textCol, width: 2)
                    : Border.all(color: AppColors.transparent),
              ),
              child: Center(
                child: Text(
                  shift,
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: textCol,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
