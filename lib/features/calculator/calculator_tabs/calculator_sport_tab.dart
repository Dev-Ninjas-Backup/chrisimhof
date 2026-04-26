import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_text_form_field.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:chrisimhof/features/calculator/results/model/calculate_result_model.dart';
import 'package:chrisimhof/features/calculator/results/screen/calculator_results_screen.dart';
import 'package:chrisimhof/features/calculator/widgets/indensity_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class CalculatorSportTab extends StatelessWidget {
  const CalculatorSportTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalculatorController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Training intent options
              Column(
                children: [
                  Obx(
                    () => RadioListTile<String>(
                      value: 'NO_TRAINING',
                      groupValue: controller.trainingIntent.value,
                      title: Text("I don't want to train today".tr),
                      onChanged: (v) =>
                          controller.setTrainingIntent(v ?? 'NO_TRAINING'),
                    ),
                  ),
                  Obx(
                    () => RadioListTile<String>(
                      value: 'WILL_TRAIN',
                      groupValue: controller.trainingIntent.value,
                      title: Text('I want to train today'.tr),
                      onChanged: (v) =>
                          controller.setTrainingIntent(v ?? 'WILL_TRAIN'),
                    ),
                  ),
                  Obx(
                    () => RadioListTile<String>(
                      value: 'ALREADY_TRAINED',
                      groupValue: controller.trainingIntent.value,
                      title: Text('I already trained'.tr),
                      onChanged: (v) =>
                          controller.setTrainingIntent(v ?? 'ALREADY_TRAINED'),
                    ),
                  ),
                ],
              ),

              // Show duration + intensity only when training or already trained
              Column(
                children: [
                  CustomTextFormField(
                    label: "Duration (min)".tr,
                    hintText: "Enter Duration".tr,
                    isRequired: false,
                    controller: controller.sportDurationController,
                    keyboardType: TextInputType.number,
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
                  const SizedBox(height: 24),
                ],
              ),
              const SizedBox(height: 120),

              CustomButton(
                text: "Calculate".tr,
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
                      EasyLoading.showError(
                        controller.sportSubmitError.value.tr,
                      );
                    }
                  } catch (e) {
                    EasyLoading.showError(e.toString());
                  }
                },
                backgroundColor: AppColors.primaryButtonColor,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: "Reset".tr,
                onTap: () {
                  controller.sportDurationController.clear();
                  controller.setTrainingIntent('NO_TRAINING');
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
