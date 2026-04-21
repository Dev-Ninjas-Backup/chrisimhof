import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_text_form_field.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:chrisimhof/features/calculator/results/model/calculate_result_model.dart';
import 'package:chrisimhof/features/calculator/results/screen/calculator_results_screen.dart';
import 'package:chrisimhof/features/calculator/widgets/activity_type_selector.dart';
import 'package:chrisimhof/features/calculator/widgets/indensity_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculatorSportTab extends StatelessWidget {
  const CalculatorSportTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalculatorController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomTextFormField(
                label: "Desired Duration (min)",
                hintText: "Enter Duration",
                isRequired: false,
                controller: controller.sportDurationController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              Obx(
                () => ActivityTypeSelector(
                  selectedActivity: controller.selectedActivityType.value,
                  onSelect: (activity) {
                    controller.selectActivityType(activity);
                  },
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => IntensitySlider(
                  value: controller.sportIntensity.value,
                  onChanged: (value) {
                    controller.setSportIntensity(value);
                  },
                ),
              ),
              const SizedBox(height: 180),
              CustomButton(
                text: "Calculate",
                onTap: () async {
                  try {
                    await controller.submitSportData();
                    if (controller.sportSubmitError.value.isEmpty) {
                      Get.to(
                        () => CalculatorResultsScreen(
                          initialData: CalculateResultResponse(
                            id: '',
                            overallScore: 0,
                            scoreBreakdown: ScoreBreakdown(
                              sleep: 0,
                              nutrition: 0,
                              hydration: 0,
                              caffeine: 0,
                            ),
                            recommendations: [],
                            createdAt: '',
                          ),
                          sessionId:
                              controller.calculatorSession.value?.sessionId,
                        ),
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        controller.sportSubmitError.value,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      'Failed to submit sport activity: $e',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                backgroundColor: AppColors.primaryButtonColor,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: "Reset",
                onTap: () {
                  controller.sportDurationController.clear();
                  controller.selectActivityType('');
                  controller.setSportIntensity(0);
                },
                backgroundColor: Colors.grey[300],
              ),
            ],
          ),
        );
      },
    );
  }
}
