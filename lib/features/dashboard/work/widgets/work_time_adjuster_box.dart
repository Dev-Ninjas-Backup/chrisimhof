import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';

class WorkTimeAdjusterBox extends StatelessWidget {
  final String title;
  final IconData icon;
  final int hour;
  final int minute;
  final VoidCallback onHourUp;
  final VoidCallback onHourDown;
  final VoidCallback onMinuteUp;
  final VoidCallback onMinuteDown;

  const WorkTimeAdjusterBox({
    super.key,
    required this.title,
    required this.icon,
    required this.hour,
    required this.minute,
    required this.onHourUp,
    required this.onHourDown,
    required this.onMinuteUp,
    required this.onMinuteDown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.10),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: AppColors.selectionGray,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: getTextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.selectionGray,
                ).copyWith(letterSpacing: 1.1),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildDigitSelector(
                value: hour.toString().padLeft(2, '0'),
                onIncrement: onHourUp,
                onDecrement: onHourDown,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  ':',
                  style: getTextStyle2(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),
              _buildDigitSelector(
                value: minute.toString().padLeft(2, '0'),
                onIncrement: onMinuteUp,
                onDecrement: onMinuteDown,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDigitSelector({
    required String value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onIncrement,
          behavior: HitTestBehavior.opaque,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Icon(
              Icons.keyboard_arrow_up_rounded,
              color: AppColors.selectionGray,
              size: 20,
            ),
          ),
        ),
        Text(
          value,
          style: getTextStyle2(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
        GestureDetector(
          onTap: onDecrement,
          behavior: HitTestBehavior.opaque,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.selectionGray,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
