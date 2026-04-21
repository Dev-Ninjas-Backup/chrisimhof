import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_range_slider.dart';
import 'package:chrisimhof/core/common/widgets/custom_text_form_field.dart';
import 'package:chrisimhof/core/common/widgets/time_widget.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:chrisimhof/features/calculator/widgets/fatigue_level.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculatorSleepTab extends StatelessWidget {
  const CalculatorSleepTab({super.key});

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.find<CalculatorController>();

    return Column(
      children: [
        TimeWidget(
          topTitle: 'Wake-up-Time',
          controller: controller.wakeUpController,
        ),
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
        const SizedBox(height: 16),
        FatigueLevel(
          headerText: 'Fatigue Level',
          selectedOption: controller.fatigueLevel,
          options: ['Low', 'Medium', 'High'],
          onSelect: (option) => controller.fatigueLevel.value = option,
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
        Obx(() {
          return Column(
            children: [
              // Display all added naps
              if (controller.naps.isNotEmpty)
                Column(
                  children: List.generate(controller.naps.length, (index) {
                    final nap = controller.naps[index];
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Nap ${nap['napNumber']}#",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => controller.removeNap(index),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Duration: ${nap['duration']} min",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Time: ${nap['preferredTime']}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  }),
                ),
              // Current nap input section
              Row(
                children: [
                  Text(
                    "Nap ${controller.naps.length + 1}#",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                label: "Desired Nap Duration (min)",
                hintText: "Enter Duration",
                isRequired: true,
                controller: controller.currentNapDurationController,
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
                onTap: () {
                  controller.addNap(
                    controller.currentNapDurationController.text,
                    controller.preferredTimeController.to24HourFormat,
                  );
                },
                width: double.infinity,
              ),
            ],
          );
        }),
        const SizedBox(height: 32),
        Obx(
          () => CustomButton(
            text: controller.isSleepSubmitting.value ? "Submitting..." : "Next",
            onTap: controller.isSleepSubmitting.value
                ? null
                : () {
                    controller.submitSleepData();
                  },
            width: double.infinity,
          ),
        ),
        const SizedBox(height: 16),
        if (controller.sleepSubmitError.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              controller.sleepSubmitError.value,
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        CustomButton(
          text: "Reset",
          onTap: () {
            controller.clearAllNaps();
            controller.wakeUpController.reset();
            controller.sleepLastNightController.updateValue(8);
            controller.sleepGoalController.updateValue(8);
            controller.fatigueLevel.value = 'Low';
            controller.desiredSleepStartController.reset();
            controller.desiredSleepEndController.reset();
          },
          width: double.infinity,
          backgroundColor: const Color(0xFFF3F4F6),
        ),
      ],
    );
  }
}
