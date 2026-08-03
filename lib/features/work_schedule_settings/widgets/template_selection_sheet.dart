import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/work_schedule_settings/controller/work_schedule_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TemplateSelectionSheet extends StatelessWidget {
  final WorkScheduleSettingsController controller;

  const TemplateSelectionSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Start your rotation'.tr,
            style: getTextStyle2(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pick a template to pre-fill everything below, or build your own from scratch.'
                .tr,
            style: getTextStyle(
              fontSize: 14,
              color: AppColors.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 20),

          // Template Cards list from REST API
          Obx(() {
            if (controller.isLoadingPresets.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.secondaryButtonColor,
                  ),
                ),
              );
            }

            final presets = controller.apiPresets;
            if (presets.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Text(
                    'No presets available'.tr,
                    style: getTextStyle(
                      fontSize: 14,
                      color: AppColors.textSoft,
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: List.generate(presets.length, (index) {
                final tmpl = presets[index];
                final isSelected =
                    controller.selectedTemplateIndex.value == index;

                return GestureDetector(
                  onTap: () {
                    controller.selectedTemplateIndex.value = index;
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.mintSoft3 : AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.secondaryButtonColor
                            : AppColors.borderSoft,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left accent bar
                        Container(
                          width: 4,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.secondaryButtonColor
                                : AppColors.gray300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      tmpl.label.tr,
                                      style: getTextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.mintSoft
                                          : AppColors.gray100,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${tmpl.cycleWeeks} ${'wk'.tr}',
                                      style: getTextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? AppColors.secondaryButtonColor
                                            : AppColors.textSoft,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tmpl.description.tr,
                                style: getTextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSoft,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          }),

          const SizedBox(height: 8),

          // "Start from scratch instead ->"
          Center(
            child: TextButton(
              onPressed: () {
                controller.selectedTemplateKey.value = '';
                Get.back();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Start from scratch instead'.tr,
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSoft,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: AppColors.textSoft,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Use this template button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                final presets = controller.apiPresets;
                final idx = controller.selectedTemplateIndex.value;
                if (presets.isNotEmpty && idx >= 0 && idx < presets.length) {
                  controller.applyPreset(presets[idx]);
                }
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButtonColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Use this template'.tr,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
