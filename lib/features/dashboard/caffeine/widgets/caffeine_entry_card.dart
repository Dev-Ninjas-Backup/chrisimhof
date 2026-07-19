import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/caffeine/model/caffeine_entry.dart';
import 'package:flutter/material.dart';

class CaffeineEntryCard extends StatelessWidget {
  final CaffeineEntry entry;
  final VoidCallback onEdit;

  const CaffeineEntryCard({
    super.key,
    required this.entry,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(
                _getIconForEntry(entry.title),
                color: AppColors.amberDark,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  entry.timeFormatted,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSoft,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${entry.amountMg}',
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryTextColor,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                'mg',
                style: getTextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSoft,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // GestureDetector(
          //   onTap: onEdit,
          //   child: const Icon(
          //     Icons.edit_outlined,
          //     color: AppColors.textSoft,
          //     size: 18,
          //   ),
          // ),
        ],
      ),
    );
  }

  IconData _getIconForEntry(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('espresso') || lower.contains('coffee')) {
      return Icons.local_cafe_rounded;
    } else if (lower.contains('energy') || lower.contains('bolt')) {
      return Icons.flash_on_rounded;
    } else if (lower.contains('tea')) {
      return Icons.emoji_food_beverage_rounded;
    }
    return Icons.local_drink_rounded;
  }
}
