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
          CustomButton(
            text: "Next",
            onTap: () {

            },
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: "Reset",
            onTap: () {

            },
            backgroundColor: Colors.grey[300],),  
        ],
      ),
    );
  }
}