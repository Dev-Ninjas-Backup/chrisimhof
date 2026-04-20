import 'package:flutter/material.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';

class IntensitySlider extends StatelessWidget {
  final double value; 
  final ValueChanged<double> onChanged;

  const IntensitySlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Intensity",
          style: getTextStyle(
            color: AppColors.primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 24.0,
            activeTrackColor: AppColors.primaryButtonColor,
            inactiveTrackColor: const Color(0xFFF1F3F5),
            thumbColor: const Color(0xFF1A1F26),
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 10.0,
              elevation: 0,
            ),
            overlayShape: SliderComponentShape.noOverlay,
            trackShape: const RoundedRectSliderTrackShape(),
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 2,
            divisions: 2,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel("Low", value == 0),
            _buildLabel("Moderate", value == 1),
            _buildLabel("High", value == 2),
          ],
        ),
      ],
    );
  }

  Widget _buildLabel(String text, bool isSelected) {
    return Text(
      text,
      style: getTextStyle(
        color: isSelected ? AppColors.primaryButtonColor : const Color(0xFF6B7280),
        fontSize: 14,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }
}