import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/history/model/history_model.dart';
import 'package:chrisimhof/features/history_details/screen/history_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryWidget extends StatelessWidget {
  final HistoryModel historyItem;

  const HistoryWidget({super.key, required this.historyItem});

  String _formatDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      // Will be handled by locale
      // Simple formatting: Apr 20, 2026 · 9:09 PM
      final months = [
        'Jan'.tr,
        'Feb'.tr,
        'Mar'.tr,
        'Apr'.tr,
        'May'.tr,
        'Jun'.tr,
        'Jul'.tr,
        'Aug'.tr,
        'Sep'.tr,
        'Oct'.tr,
        'Nov'.tr,
        'Dec'.tr,
      ];
      final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
      final period = dateTime.hour >= 12 ? 'PM'.tr : 'AM'.tr;
      final minute = dateTime.minute.toString().padLeft(2, '0');

      return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year} · $hour:$minute $period';
    } catch (e) {
      return dateTimeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.to(() => HistoryDetailsScreen(), arguments: historyItem.id),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatDate(historyItem.createdAt),
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    historyItem.summary,
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${historyItem.overallScore}%',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${historyItem.sleepScore}% ${'Sleep'.tr} • ${historyItem.activityScore}% ${'Activity'.tr}',
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryTextColor,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
