import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_range_slider.dart';
import 'package:chrisimhof/core/common/widgets/selectble_tab_button.dart';
import 'package:chrisimhof/core/common/widgets/time_widget.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculatorNutritionTab extends StatelessWidget {
  const CalculatorNutritionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CalculatorController>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CustomRangeSlider(
            required: false,
            headerText: "Desired Number of Meals".tr,
            controller: controller.desiredNumberOfMealsController,
          ),
          const SizedBox(height: 24),
          CustomRangeSlider(
            required: false,
            headerText: "Meals Per Day".tr,
            controller: controller.desiredNumberOfMealsController,
          ),
          const SizedBox(height: 24),
          TimeWidget(
            topTitle: 'First Meal Time'.tr,
            controller: controller.firstMealTimeController,
          ),
          const SizedBox(height: 24),
          TimeWidget(
            topTitle: 'Last Meal Time'.tr,
            controller: controller.lastMealTimeController,
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Already had a meal today?".tr,
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
                    child: Obx(
                      () => SelectableTabButton(
                        text: 'Yes'.tr,
                        isSelected:
                            controller.hasMealTodaySelection.value == 'Yes',
                        onTap: () =>
                            controller.hasMealTodaySelection.value = 'Yes',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Obx(
                      () => SelectableTabButton(
                        text: 'No'.tr,
                        isSelected:
                            controller.hasMealTodaySelection.value == 'No',
                        onTap: () =>
                            controller.hasMealTodaySelection.value = 'No',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 130),
          Obx(
            () => CustomButton(
              text: controller.isNutritionSubmitting.value
                  ? 'Submitting...'.tr
                  : 'Next'.tr,
              onTap: controller.isNutritionSubmitting.value
                  ? null
                  : () {
                      controller.submitNutritionData();
                    },
              width: double.infinity,
            ),
          ),
          if (controller.nutritionSubmitError.value.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Text(
                controller.nutritionSubmitError.value.tr,
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
