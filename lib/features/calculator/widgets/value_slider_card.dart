import 'package:flutter/material.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';

class CaffeineTrackerCard extends StatelessWidget {
  final double current24hValue;
  final double maxValue;

  const CaffeineTrackerCard({
    super.key,
    required this.current24hValue,
    this.maxValue = 400.0,
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Caffeine (last 8 hours)",
                style: getTextStyle(
                  color: AppColors.primaryTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "180mg",
                style: getTextStyle(
                  color: AppColors.primaryTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE5E7EB), thickness: 1),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Use Expanded for the title to prevent it from pushing the value off-screen
              Expanded(
                child: Text(
                  "Caffeine (last 24 hours)",
                  style: getTextStyle(
                    color: AppColors.primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${current24hValue.toInt()}",
                      style: getTextStyle(
                        color: AppColors.primaryTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "/${maxValue.toInt()}mg",
                      style: getTextStyle(
                        color: const Color(0xFF6B7280),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
              value: current24hValue,
              min: 0,
              max: maxValue,
              onChanged: (val) {},
            ),
          ),
          const SizedBox(height: 12),
          // Added Padding to the label row to prevent the 1.3px overflow
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabel("0 mg"),
                _buildLabel("200 mg"),
                _buildLabel("${maxValue.toInt()} mg"),
                // Removed the duplicate 400mg label if it causes crowding
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: getTextStyle(
        color: const Color(0xFF6B7280),
        fontSize: 12, // Slightly smaller font helps with tight spaces
        fontWeight: FontWeight.w400,
      ),
    );
  }
}