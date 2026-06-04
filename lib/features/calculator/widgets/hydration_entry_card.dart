import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_text_form_field.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class HydrationEntryCard extends StatelessWidget {
  final CalculatorController controller;

  const HydrationEntryCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    const quickAmounts = [0.25, 0.5, 0.75, 1.0];

    return Container(
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
            'Add Water'.tr,
            style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: quickAmounts
                .map(
                  (amount) => OutlinedButton(
                    onPressed: () => controller.addHydrationIntake(amount),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('+${_formatLiters(amount)} L'),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            label: 'Custom Amount (L)'.tr,
            controller: controller.hydrationAmountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            hintText: '0.5',
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Add Water'.tr,
            onTap: () {
              final added = controller.submitHydrationEntryForm();
              if (!added) {
                EasyLoading.showError('Enter a valid hydration amount'.tr);
              }
            },

          ),
        ],
      ),
    );
  }
}

String _formatLiters(double value) {
  final fixed = value.toStringAsFixed(2);
  return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
}
