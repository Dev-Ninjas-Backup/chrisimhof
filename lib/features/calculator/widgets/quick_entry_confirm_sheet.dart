import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/time_widget.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:chrisimhof/features/calculator/models/caffeine_preset_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickEntryConfirmSheet extends StatelessWidget {
  final CaffeinePreset preset;
  final VoidCallback onConfirm;

  const QuickEntryConfirmSheet({super.key, 
    required this.preset,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.find<CalculatorController>();
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 24, 16, viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confirm Caffeine Entry'.tr,
                      style: getTextStyle(
                        color: AppColors.primaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            preset.label,
                            style: getTextStyle(
                              color: AppColors.primaryTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          '${preset.defaultMg} mg',
                          style: getTextStyle(
                            color: const Color(0xFF6B7280),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TimeWidget(
                topTitle: 'Time of Intake'.tr,
                controller: controller.caffeineIntakeTimeController,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Cancel'.tr),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(text: 'Add Entry'.tr, onTap: onConfirm),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
