import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/service/helper/shift_display_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DayBubble extends StatelessWidget {
  final int index;
  final String dayLabel;
  final String shift;
  final bool isToday;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const DayBubble({
    super.key,
    required this.index,
    required this.dayLabel,
    required this.shift,
    required this.isToday,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final displayCode = ShiftDisplayHelper.getDisplayCode(shift);
      final bg = ShiftDisplayHelper.getBackgroundColor(shift);
      final textCol = ShiftDisplayHelper.getTextColor(shift);

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
              onLongPress: onLongPress,
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
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text(
                        displayCode,
                        style: getTextStyle(
                          fontSize: displayCode.length > 2 ? 10 : 12,
                          fontWeight: FontWeight.w800,
                          color: textCol,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
