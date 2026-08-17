import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShiftTypePill extends StatelessWidget {
  final String shift;
  final String duration;

  const ShiftTypePill({super.key, required this.shift, required this.duration});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color pillBg;
    Color borderColor;

    final lower = shift.toLowerCase();
    if (lower == 'day' || lower.contains('day') || lower.contains('morning')) {
      icon = Icons.wb_sunny_rounded;
      pillBg = AppColors.orangeAccent.withValues(alpha: 0.15);
      borderColor = AppColors.orangeAccent.withValues(alpha: 0.35);
    } else if (lower == 'evening' ||
        lower.contains('evening') ||
        lower.contains('afternoon')) {
      icon = Icons.auto_awesome_rounded;
      pillBg = AppColors.violet.withValues(alpha: 0.15);
      borderColor = AppColors.violet.withValues(alpha: 0.35);
    } else if (lower == 'off') {
      icon = Icons.favorite_rounded;
      pillBg = AppColors.secondaryButtonColor.withValues(alpha: 0.15);
      borderColor = AppColors.secondaryButtonColor.withValues(alpha: 0.35);
    } else {
      icon = lower.contains('night')
          ? Icons.nightlight_round
          : Icons.work_rounded;
      pillBg = AppColors.indigo.withValues(alpha: 0.15);
      borderColor = AppColors.indigo.withValues(alpha: 0.35);
    }

    final formattedShiftName = _formatShiftName(shift);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: pillBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.white),
          const SizedBox(width: 6),
          Text(
            formattedShiftName == 'Off'
                ? 'Off'.tr
                : '$formattedShiftName · $duration',
            style: getTextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ).copyWith(letterSpacing: 0.2),
          ),
        ],
      ),
    );
  }

  String _formatShiftName(String key) {
    final lower = key.toLowerCase();
    if (lower == 'day') return 'Day';
    if (lower == 'evening') return 'Evening';
    if (lower == 'night') return 'Night';
    if (lower == 'off') return 'Off';
    return key
        .split('_')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }
}
