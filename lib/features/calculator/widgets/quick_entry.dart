import 'package:flutter/material.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:get/get.dart';

class QuickEntrySelector extends StatelessWidget {
  final Function(String, int) onEntrySelected;

  const QuickEntrySelector({super.key, required this.onEntrySelected});

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.find<CalculatorController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Entry".tr,
          style: getTextStyle(
            color: AppColors.primaryTextColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isCaffeinePresetsLoading.value) {
            return const SizedBox(
              height: 140,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (controller.caffeinePresetsError.value.isNotEmpty) {
            return SizedBox(
              height: 140,
              child: Center(
                child: Text(
                  'Failed to load presets'.tr,
                  style: getTextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }

          for (int i = 0; i < controller.caffeinePresets.length; i++) {}

          if (controller.caffeinePresets.isEmpty) {
            return SizedBox(
              height: 140,
              child: Center(
                child: Text(
                  'No presets available'.tr,
                  style: getTextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: controller.caffeinePresets.map((preset) {
                return GestureDetector(
                  onTap: () => onEntrySelected(preset.label, preset.defaultMg),
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          preset.label,
                          style: getTextStyle(
                            color: AppColors.primaryTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${preset.defaultMg} mg",
                          style: getTextStyle(
                            color: const Color(0xFF6B7280),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }
}
