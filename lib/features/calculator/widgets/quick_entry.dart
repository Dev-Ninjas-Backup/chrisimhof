import 'package:chrisimhof/features/calculator/widgets/quick_entry_confirm_sheet.dart';
import 'package:flutter/material.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:chrisimhof/features/calculator/models/caffeine_preset_model.dart';
import 'package:get/get.dart';

class QuickEntrySelector extends StatelessWidget {
  final void Function(CaffeinePreset preset, String consumedAt) onEntrySelected;

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
                  onTap: () => _showConfirmSheet(
                    context: context,
                    controller: controller,
                    preset: preset,
                  ),
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

  void _showConfirmSheet({
    required BuildContext context,
    required CalculatorController controller,
    required CaffeinePreset preset,
  }) {
    controller.caffeineIntakeTimeController.setFromDateTime(DateTime.now());

    Get.bottomSheet(
      QuickEntryConfirmSheet(
        preset: preset,
        onConfirm: () {
          if (preset.defaultMg <= 0) {
            Get.snackbar(
              'Missing Information'.tr,
              'Enter a valid caffeine amount'.tr,
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }

          onEntrySelected(
            preset,
            controller.caffeineIntakeTimeController.to24HourFormat,
          );
          Get.back();
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
