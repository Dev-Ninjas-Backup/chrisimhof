import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_range_slider.dart';
import 'package:chrisimhof/core/common/widgets/custom_text_form_field.dart';
import 'package:chrisimhof/core/common/widgets/time_widget.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:chrisimhof/features/calculator/widgets/fatigue_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class CalculatorSleepTab extends StatelessWidget {
  const CalculatorSleepTab({super.key});

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.find<CalculatorController>();

    return Column(
      children: [
        TimeWidget(
          topTitle: 'Wake-up-Time'.tr,
          controller: controller.wakeUpController,
        ),
        const SizedBox(height: 16),
        CustomRangeSlider(
          headerText: 'Sleep Last Night (h)'.tr,
          controller: controller.sleepLastNightController,
        ),
        const SizedBox(height: 16),
        CustomRangeSlider(
          headerText: 'Sleep Goal (h)'.tr,
          controller: controller.sleepGoalController,
        ),
        const SizedBox(height: 16),
        FatigueLevel(
          headerText: 'Fatigue Level'.tr,
          selectedOption: controller.fatigueLevel,
          options: ['Low'.tr, 'Average'.tr, 'High'.tr],
          onSelect: (option) => controller.fatigueLevel.value = option,
        ),
        const SizedBox(height: 24),
        TimeWidget(
          topTitle: 'Desired Sleep Start'.tr,
          controller: controller.desiredSleepStartController,
        ),
        const SizedBox(height: 16),
        TimeWidget(
          topTitle: 'Desired Wake Time'.tr,
          controller: controller.desiredSleepEndController,
        ),
        const SizedBox(height: 24),
        Obx(() {
          return Column(
            children: [
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('I want to take a nap'.tr),
                value: controller.wantsNap.value,
                onChanged: (val) => controller.setWantsNap(val ?? false),
              ),

              if (controller.wantsNap.value) ...[
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
                                      "Nap @number#".trParams({
                                        'number': nap['napNumber'].toString(),
                                      }),
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
                                  "Duration: @value min".trParams({
                                    'value': nap['duration'].toString(),
                                  }),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Time: @value".trParams({
                                    'value': nap['preferredTime'].toString(),
                                  }),
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
                      "Nap @number#".trParams({
                        'number': (controller.naps.length + 1).toString(),
                      }),
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
                  label: "Desired Nap Duration (min)".tr,
                  hintText: "Enter Duration".tr,
                  isRequired: true,
                  controller: controller.currentNapDurationController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                TimeWidget(
                  topTitle: 'Preferred Time'.tr,
                  controller: controller.preferredTimeController,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: "+Add Nap".tr,
                  onTap: () {
                    controller.addNap(
                      controller.currentNapDurationController.text,
                      controller.preferredTimeController.to24HourFormat,
                    );
                  },
                  width: double.infinity,
                ),
              ],
            ],
          );
        }),
        const SizedBox(height: 32),
        Obx(
          () => CustomButton(
            text: controller.isSleepSubmitting.value
                ? "Submitting...".tr
                : "Next".tr,
            onTap: controller.isSleepSubmitting.value
                ? null
                : () {
                    controller.submitSleepData();
                  },
            width: double.infinity,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          final errorMessage = controller.sleepSubmitError.value;

          if (errorMessage.isEmpty) {
            return const SizedBox.shrink();
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            EasyLoading.showError(errorMessage);
            if (controller.sleepSubmitError.value == errorMessage) {
              controller.sleepSubmitError.value = '';
            }
          });

          return const SizedBox.shrink();
        }),
        CustomButton(
          text: "Reset".tr,
          onTap: () {
            controller.clearAllNaps();
            controller.setWantsNap(false);
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
