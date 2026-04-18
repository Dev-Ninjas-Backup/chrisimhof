import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';

class CustomRangeSlider extends StatelessWidget {
  final String headerText;
  final double currentValue;
  final double min;
  final double max;
  final Function(double) onChanged;

  const CustomRangeSlider({
    super.key,
    required this.headerText,
    required this.currentValue,
    required this.onChanged,
    this.min = 1,
    this.max = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: headerText,
              style: getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              children: const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 24.0, 
              trackShape: const RoundedRectSliderTrackShape(),
              activeTrackColor: AppColors.primaryButtonColor,
              inactiveTrackColor: const Color(0xFFF3F4F6),
              
              thumbColor: const Color(0xFF1A1F26), 
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 10.0, 
                elevation: 0,
              ),
              
              overlayShape: SliderComponentShape.noOverlay,
              
              showValueIndicator: ShowValueIndicator.never,
            ),
            child: Column(
              children: [
                Slider(
                  value: currentValue,
                  min: min,
                  max: max,
                  divisions: (max - min).toInt(),
                  onChanged: onChanged,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      (max - min + 1).toInt(),
                      (index) {
                        double val = min + index;
                        bool isSelected = val == currentValue;
                        return Text(
                          val.toInt().toString(),
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected 
                                ? AppColors.primaryButtonColor 
                                : const Color(0xFF414651),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
