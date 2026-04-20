import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_range_slider.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculatorHydrationTab extends StatelessWidget {
  const CalculatorHydrationTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CalculatorController>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE9EAEB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Recommended hydration 2.5L perday",
              textAlign: TextAlign.center,
              style: getTextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),
          CustomRangeSlider(
            required: false,
            headerText: "Already Consumed (L)",
            controller: controller.hydrationConsumedController,
          ),
          const SizedBox(height: 26),
          CustomRangeSlider(
            required: false,
            headerText: "Daily Goal (L)",
            controller: controller.hydrationDailyGoalController,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE9EAEB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Hydration recomendation may adjust automatically based on sport activity",
              style: getTextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 130),
          Obx(
            () => CustomButton(
              text: controller.isHydrationSubmitting.value
                  ? 'Submitting...'
                  : 'Next',
              onTap: controller.isHydrationSubmitting.value
                  ? null
                  : () {
                      controller.submitHydrationData();
                    },
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => controller.hydrationSubmitError.value.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: Text(
                      controller.hydrationSubmitError.value,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          CustomButton(
            text: "Reset",
            onTap: () {
              controller.hydrationConsumedController.updateValue(1.0);
              controller.hydrationDailyGoalController.updateValue(2.5);
              controller.hydrationSubmitError.value = '';
            },
            backgroundColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
