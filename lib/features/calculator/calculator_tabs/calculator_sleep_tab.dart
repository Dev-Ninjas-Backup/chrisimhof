import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_range_slider.dart';
import 'package:chrisimhof/core/common/widgets/custom_text_form_field.dart';
import 'package:chrisimhof/core/common/widgets/time_widget.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculatorSleepTab extends StatelessWidget {
  const CalculatorSleepTab({super.key});

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.find<CalculatorController>();

    return Column(
      children: [
        TimeWidget(topTitle: 'Wake-up-Time', controller: controller.wakeUpController),
        const SizedBox(height: 16),
        CustomRangeSlider(
          headerText: 'Sleep Last Night (h)',
          controller: controller.sleepLastNightController,
        ),
        const SizedBox(height: 16),
        CustomRangeSlider(
          headerText: 'Sleep Goal (h)',
          controller: controller.sleepGoalController,
        ),
        const SizedBox(height: 24),
        TimeWidget(
          topTitle: 'Desired Sleep Start',
          controller: controller.desiredSleepStartController,
        ),
        const SizedBox(height: 16),
        TimeWidget(
          topTitle: 'Desired  Wake Time',
          controller: controller.desiredSleepEndController,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Text("Nap 1#",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                )),

          ],
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          label: "Desired Nap Duration (min)",
          hintText: "Enter Duration",
          isRequired: true,
          controller: controller.durationController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        TimeWidget(
          topTitle: 'Preferred Time',
          controller: controller.preferredTimeController,
        ),
        const SizedBox(height: 32),
        CustomButton(
          text: "+Add Nap",
          onTap: () {},
          width: double.infinity,
        ),

        const SizedBox(height: 117),
        CustomButton(
          text: "Next",
          onTap: () {},
          width: double.infinity,
        ),
        const SizedBox(height: 16),
        CustomButton(
          text: "Reset",
          onTap: () {},
          width: double.infinity,
          backgroundColor: const Color(0xFFF3F4F6),
        ),
      ],
    );
  }
}
