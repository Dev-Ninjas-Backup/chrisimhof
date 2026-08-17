import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpcomingScheduleDayRow extends StatelessWidget {
  final DateTime date;
  final String currentShift;
  final String timeRangeStr;
  final bool isToday;
  final bool isOverride;
  final bool isEditing;
  final VoidCallback onTap;

  const UpcomingScheduleDayRow({
    super.key,
    required this.date,
    required this.currentShift,
    required this.timeRangeStr,
    required this.isToday,
    required this.isOverride,
    required this.isEditing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dayName = DateFormat('EEE').format(date).toUpperCase();
    final dayNum = date.day.toString();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            // Date column (MON 4)
            SizedBox(
              width: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayName,
                    style: getTextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSoft,
                    ),
                  ),
                  Text(
                    dayNum,
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Shift Dot & Shift Name
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getShiftDotColor(currentShift),
              ),
            ),
            const SizedBox(width: 8),

            Text(
              _getShiftFullName(currentShift),
              style: getTextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(width: 8),

            // Time range text if not Off
            if (currentShift != 'Off' && timeRangeStr.isNotEmpty)
              Text(
                timeRangeStr,
                style: getTextStyle(
                  fontSize: 12,
                  color: AppColors.textSoft,
                ),
              ),

            const Spacer(),

            // Badge: TODAY or EDITED
            if (isToday)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mintSoft,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'TODAY'.tr,
                  style: getTextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.secondaryButtonColor,
                  ),
                ),
              )
            else if (isOverride)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'EDITED'.tr,
                  style: getTextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSoft,
                  ),
                ),
              )
            else
              Icon(
                isEditing
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.chevron_right_rounded,
                color: AppColors.grey,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  Color _getShiftDotColor(String code) {
    final lower = code.toLowerCase();
    if (lower == 'day' || lower == 'd') return AppColors.orangeAccent2;
    if (lower == 'evening' || lower == 'e') return AppColors.violet;
    if (lower == 'night' || lower == 'n') return AppColors.indigo;
    if (lower == 'off') return AppColors.grey;

    if (lower.contains('morning') || lower.contains('day')) {
      return AppColors.orangeAccent2;
    }
    if (lower.contains('evening') || lower.contains('afternoon')) {
      return AppColors.violet;
    }
    if (lower.contains('night')) {
      return AppColors.indigo;
    }
    return AppColors.secondaryButtonColor;
  }

  String _getShiftFullName(String code) {
    final lower = code.toLowerCase();
    if (lower == 'day' || lower == 'd') return 'Day'.tr;
    if (lower == 'evening' || lower == 'e') return 'Evening'.tr;
    if (lower == 'night' || lower == 'n') return 'Night'.tr;
    if (lower == 'off') return 'Off'.tr;

    return code.split('_').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}
