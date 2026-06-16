import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';

class ShiftTypePill extends StatelessWidget {
  final String shift;
  final String duration;

  const ShiftTypePill({
    super.key,
    required this.shift,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color pillBg;

    if (shift == 'Day') {
      icon = Icons.wb_sunny_rounded;
      pillBg = AppColors.orangeAccent.withValues(alpha: 0.2);
    } else if (shift == 'Evening') {
      icon = Icons.auto_awesome_rounded;
      pillBg = AppColors.violet.withValues(alpha: 0.2);
    } else if (shift == 'Off') {
      icon = Icons.favorite_rounded;
      pillBg = AppColors.secondaryButtonColor.withValues(alpha: 0.2);
    } else {
      // Night
      icon = Icons.nightlight_round;
      pillBg = AppColors.indigo.withValues(alpha: 0.2);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: pillBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.white),
          const SizedBox(width: 6),
          Text(
            shift == 'Off' ? 'Off' : '$shift · $duration',
            style: getTextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
