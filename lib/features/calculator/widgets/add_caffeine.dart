import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_text_form_field.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                child: CustomTextFormField(
                  label: 'Drink Type'.tr,
                  controller: controller.caffeineDrinkTypeController,
                  hintText: 'Enter Type'.tr,
                  textInputAction: TextInputAction.next,
                ),
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
                onTap: () {
                  final bool isSubmitted = controller.submitAddCaffeineForm();
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
            'Consumed Time'.tr,
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _TimePartColumn(
                  onUpTap: controller.caffeineIntakeTimeController.increaseHour,
                  onDownTap:
                      controller.caffeineIntakeTimeController.decreaseHour,
                  child: Obx(
                    () => Text(
                      controller.caffeineIntakeTimeController.formattedHour,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  ':',
                  style: getTextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ),
              Expanded(
                child: _TimePartColumn(
                  onUpTap:
                      controller.caffeineIntakeTimeController.increaseMinute,
                  onDownTap:
                      controller.caffeineIntakeTimeController.decreaseMinute,
                  child: Obx(
                    () => Text(
                      controller.caffeineIntakeTimeController.formattedMinute,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _TimePartColumn(
                  onUpTap: controller.caffeineIntakeTimeController.togglePeriod,
                  onDownTap:
                      controller.caffeineIntakeTimeController.togglePeriod,
                  child: Obx(
                    () => Text(
                      controller.caffeineIntakeTimeController.period.value,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimePartColumn extends StatelessWidget {
  final VoidCallback onUpTap;
  final VoidCallback onDownTap;
  final Widget child;

  const _TimePartColumn({
    required this.onUpTap,
    required this.onDownTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ArrowButton(icon: Icons.keyboard_arrow_up_rounded, onTap: onUpTap),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 8),
        _ArrowButton(icon: Icons.keyboard_arrow_down_rounded, onTap: onDownTap),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: Icon(icon, size: 28, color: AppColors.secondaryTextColor),
    );
  }
}
