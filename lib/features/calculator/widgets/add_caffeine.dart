import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_text_form_field.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chrisimhof/core/common/widgets/time_widget.dart';

class AddCaffeineBottomSheet extends StatelessWidget {
  const AddCaffeineBottomSheet({super.key});

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
            children: [
              _InputCard(
                child: CustomTextFormField(
                  label: 'Drink Name'.tr,
                  controller: controller.caffeineDrinkNameController,
                  hintText: 'Enter Type'.tr,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(height: 24),
              _InputCard(
                child: Obx(() {
                  const options = [
                    'ESPRESSO',
                    'COFFEE',
                    'ENERGY_DRINK',
                    'TEA',
                    'GREEN_TEA',
                    'PRE_WORKOUT',
                  ];

                  final display = {
                    'ESPRESSO': 'Espresso'.tr,
                    'COFFEE': 'Coffee'.tr,
                    'ENERGY_DRINK': 'Energy Drink'.tr,
                    'TEA': 'Tea'.tr,
                    'GREEN_TEA': 'Green Tea'.tr,
                    'PRE_WORKOUT': 'Pre-workout'.tr,
                  };

                  final selected = controller.selectedCaffeineDrinkType.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Drink Type'.tr, style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: options.contains(selected) ? selected : 'COFFEE',
                        items: options
                            .map((o) => DropdownMenuItem<String>(value: o, child: Text(display[o] ?? o)))
                            .toList(),
                        onChanged: (v) {
                          if (v == null) return;
                          controller.selectedCaffeineDrinkType.value = v;
                          controller.caffeineDrinkTypeController.text = v;
                        },
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 24),
              _InputCard(
                child: CustomTextFormField(
                  label: 'Amount (mg)'.tr,
                  controller: controller.caffeineAmountController,
                  hintText: 'Enter Amount'.tr,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(height: 24),
              _ConsumedTimeCard(controller: controller),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Add Now'.tr,
                onTap: () async {
                  final bool isSubmitted = controller.submitAddCaffeineForm();
                  await controller.submitCaffeineIntake();

                  if (!isSubmitted) {
                    Get.snackbar(
                      'Missing Information'.tr,
                      'Please enter drink name, type, amount, and time.'.tr,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final Widget child;

  const _InputCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }
}

class _ConsumedTimeCard extends StatelessWidget {
  final CalculatorController controller;

  const _ConsumedTimeCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TimeWidget(
      topTitle: 'Consumed Time',
      controller: controller.caffeineIntakeTimeController,
    );
  }
}

// Replaced local time part UI with shared `TimeWidget` from core widgets.
