import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';

class TimeWidget extends StatelessWidget {
  final String title;
  final String? iconPath;
  final IconData? icon;
  final int hour;
  final int minute;
  final VoidCallback onHourUp;
  final VoidCallback onHourDown;
  final VoidCallback onMinuteUp;
  final VoidCallback onMinuteDown;
  final void Function(int hour, int minute)? onTimeSelected;

  const TimeWidget({
    super.key,
    required this.title,
    this.iconPath,
    this.icon,
    required this.hour,
    required this.minute,
    required this.onHourUp,
    required this.onHourDown,
    required this.onMinuteUp,
    required this.onMinuteDown,
    this.onTimeSelected,
  });

  Future<void> _pickTime(BuildContext context) async {
    if (onTimeSelected == null) return;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
      builder: (context, child) {
        return Theme(data: Theme.of(context).copyWith(), child: child!);
      },
    );

    if (picked != null) {
      onTimeSelected!(picked.hour, picked.minute);
    }
  }

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
          GestureDetector(
            onTap: onTimeSelected != null ? () => _pickTime(context) : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (iconPath != null)
                  Image.asset(
                    iconPath!,
                    height: 14,
                    width: 14,
                    color: AppColors.selectionGray,
                  )
                else if (icon != null)
                  Icon(icon!, size: 14, color: AppColors.selectionGray),
                const SizedBox(width: 6),
                Text(
                  title.toUpperCase(),
                  style: getTextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.selectionGray,
                  ).copyWith(letterSpacing: 1.1),
                ),
                if (onTimeSelected != null) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.edit_calendar_rounded,
                    size: 12,
                    color: AppColors.selectionGray,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _SwipeDigitColumn(
                value: hour.toString().padLeft(2, '0'),
                onIncrement: onHourUp,
                onDecrement: onHourDown,
                onTapText: onTimeSelected != null
                    ? () => _pickTime(context)
                    : null,
              ),
              GestureDetector(
                onTap: onTimeSelected != null ? () => _pickTime(context) : null,
                child: Padding(
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
              ),
              _SwipeDigitColumn(
                value: minute.toString().padLeft(2, '0'),
                onIncrement: onMinuteUp,
                onDecrement: onMinuteDown,
                onTapText: onTimeSelected != null
                    ? () => _pickTime(context)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SwipeDigitColumn extends StatefulWidget {
  final String value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback? onTapText;

  const _SwipeDigitColumn({
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
    this.onTapText,
  });

  @override
  State<_SwipeDigitColumn> createState() => _SwipeDigitColumnState();
}

class _SwipeDigitColumnState extends State<_SwipeDigitColumn> {
  double _dragAccumulator = 0.0;
  static const double _dragThreshold = 18.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: (details) {
        _dragAccumulator += details.delta.dy;
        if (_dragAccumulator.abs() >= _dragThreshold) {
          if (_dragAccumulator < 0) {
            widget.onIncrement();
          } else {
            widget.onDecrement();
          }
          _dragAccumulator = 0.0;
        }
      },
      onVerticalDragEnd: (_) {
        _dragAccumulator = 0.0;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: widget.onIncrement,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                color: AppColors.selectionGray,
                size: 20,
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.onTapText,
            behavior: HitTestBehavior.opaque,
            child: Text(
              widget.value,
              style: getTextStyle2(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.onDecrement,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.selectionGray,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
