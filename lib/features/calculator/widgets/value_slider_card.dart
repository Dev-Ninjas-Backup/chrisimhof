import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:get/get.dart';

class CaffeineTrackerCard extends StatelessWidget {
  final double current24hValue;
  final double maxValue;

  const CaffeineTrackerCard({
    super.key,
    required this.current24hValue,
    this.maxValue = 600.0,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CalculatorController>();

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
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "last 8 hours".tr,
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    color: AppColors.primaryTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${controller.caffeineRolling8hMgValue.value.toInt()}mg",
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    color: AppColors.primaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE5E7EB), thickness: 1),
          const SizedBox(height: 20),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Caffeine (last 24 hours)".tr,
                    style: getTextStyle(
                      color: AppColors.primaryTextColor,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${controller.caffeine24hValue.toInt()}",
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
          ),
          const SizedBox(height: 20),
          Obx(
            () => SliderTheme(
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
                value: math.min(controller.caffeine24hValue.value, maxValue),
                min: 0,
                max: maxValue,
                onChanged: (val) {
                  controller.caffeine24hValue.value = math.min(val, maxValue);
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabel("0 mg"),
                _buildLabel("200 mg"),
                _buildLabel("400 mg"),
                //_buildLabel("${maxValue.toInt()} mg"),
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
        color: const Color(0xFF414651),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
