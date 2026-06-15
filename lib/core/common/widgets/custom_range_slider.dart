import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/common/controller/range_slider_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomRangeSlider extends StatelessWidget {
  final String headerText;
  final RangeSliderController controller;
  final bool required;
  final int? divisions;

  const CustomRangeSlider({
    super.key,
    required this.headerText,
    required this.controller,
    this.required = true,
    this.divisions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: headerText.tr,
              style: getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
              children: [
                TextSpan(
                  text: required ? ' *' : '',
                  style: const TextStyle(color: AppColors.red),
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
              inactiveTrackColor: AppColors.gray100,

              thumbColor: AppColors.darkCharcoal,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 10.0,
                elevation: 0,
              ),

              overlayShape: SliderComponentShape.noOverlay,

              showValueIndicator: ShowValueIndicator.never,
            ),
            child: Column(
              children: [
                Obx(
                  () => Slider(
                    value: controller.value.value,
                    min: controller.min,
                    max: controller.max,
                    divisions:
                        divisions ?? (controller.max - controller.min).toInt(),
                    onChanged: controller.updateValue,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: divisions != null
                        ? List.generate(
                            (controller.max - controller.min).toInt() + 1,
                            (index) {
                              final double val =
                                  controller.min + index.toDouble();
                              final String label = val.toInt().toString();
                              return Obx(() {
                                final bool isSelected =
                                    (controller.value.value - val).abs() <
                                    (0.5 + 1e-9);
                                return Text(
                                  label,
                                  style: getTextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? AppColors.primaryButtonColor
                                        : AppColors.secondaryTextColor,
                                  ),
                                );
                              });
                            },
                          )
                        : List.generate(
                            (controller.max - controller.min).toInt() + 1,
                            (index) {
                              final int divs = (controller.max - controller.min)
                                  .toInt();
                              final double step =
                                  (controller.max - controller.min) / divs;
                              final double val =
                                  controller.min + (step * index);

                              // Determine decimal places to display based on step precision
                              int decimals = 0;
                              double tmp = step;
                              while ((tmp - tmp.floor()).abs() > 1e-9 &&
                                  decimals < 4) {
                                tmp *= 10;
                                decimals += 1;
                              }

                              String label = val.toStringAsFixed(decimals);
                              if (label.contains('.')) {
                                label = label.replaceAll(RegExp(r'0+\$'), '');
                                label = label.replaceAll(RegExp(r'\.\$'), '');
                              }

                              return Obx(() {
                                final bool isSelected =
                                    (controller.value.value - val).abs() <
                                    (step / 2 + 1e-9);
                                return Text(
                                  label,
                                  style: getTextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? AppColors.primaryButtonColor
                                        : AppColors.secondaryTextColor,
                                  ),
                                );
                              });
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
