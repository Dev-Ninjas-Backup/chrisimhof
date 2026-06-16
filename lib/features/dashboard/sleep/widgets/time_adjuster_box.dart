import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';

class TimeAdjusterBox extends StatelessWidget {
  final String title;
  final String iconPath;
  final int hour;
  final int minute;
  final VoidCallback onHourUp;
  final VoidCallback onHourDown;
  final VoidCallback onMinuteUp;
  final VoidCallback onMinuteDown;

  const TimeAdjusterBox({
    super.key,
    required this.title,
    required this.iconPath,
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
              Image.asset(
                iconPath,
                height: 14,
                width: 14,
                color: AppColors.selectionGray,
              ),
              const SizedBox(width: 6),
              Text(
                title.toUpperCase(),
                style: getTextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
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
              _buildDigitColumn(
                value: hour.toString().padLeft(2, '0'),
                onIncrement: onHourUp,
                onDecrement: onHourDown,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  ':',
                  style: getTextStyle2(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),
              _buildDigitColumn(
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

  Widget _buildDigitColumn({
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
        const SizedBox(height: 2),
        Text(
          value,
          style: getTextStyle2(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 2),
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
