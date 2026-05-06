// ignore_for_file: deprecated_member_use

import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_text_form_field.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:chrisimhof/features/calculator/models/activity_type_enum.dart';
import 'package:chrisimhof/features/calculator/results/model/calculate_result_model.dart';
import 'package:chrisimhof/features/calculator/results/screen/calculator_results_screen.dart';
import 'package:chrisimhof/features/calculator/widgets/activity_type_selector.dart';
import 'package:chrisimhof/features/calculator/widgets/calculator_live_score_section.dart';
import 'package:chrisimhof/features/calculator/widgets/indensity_slider.dart';
import 'package:chrisimhof/features/calculator/widgets/sport_activity_list.dart';
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
              const CalculatorLiveScoreSection(sectionKey: 'sport'),
              const SizedBox(height: 16),
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
                  const SizedBox(height: 30),
                  Obx(
                    () => ActivityTypeSelector(
                      selectedActivity: controller.selectedActivityType.value,
                      onSelect: (activity) {
                        controller.selectActivityType(activity);
                      },
                    ),
                  ),
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
              const SizedBox(height: 24),
              const SportActivityList(),
              const SizedBox(height: 120),

              CustomButton(
                text: "Add Activity".tr,
                onTap: () async {
                  try {
                    final bottomInset = MediaQuery.of(
                      context,
                    ).viewInsets.bottom;

                    await controller.submitSportData();
                    if (controller.sportSubmitError.value.isEmpty) {
                      // Show bottom sheet summary matching Figma
                      final activityLabel =
                          controller.selectedActivityType.value.isNotEmpty
                          ? controller.selectedActivityType.value
                          : 'Walking'.tr;
                      final durationText =
                          controller.sportDurationController.text.isNotEmpty
                          ? '${controller.sportDurationController.text} min'
                          : '0 min';
                      final activityTypeText =
                          controller.selectedActivityType.value.isNotEmpty
                          ? controller.selectedActivityType.value
                          : ActivityType.walk.displayName;
                      final intensityText =
                          (controller.sportIntensity.value == 2.0)
                          ? 'Hard'.tr
                          : (controller.sportIntensity.value == 1.0)
                          ? 'Moderate'.tr
                          : 'Light'.tr;

                      Get.bottomSheet(
                        Container(
                          padding: EdgeInsets.only(
                            top: 20,
                            left: 16,
                            right: 16,
                            bottom: bottomInset + 24,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Activity Time'.tr,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // First row: activity label and duration with chevron
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          activityLabel,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Text(
                                        durationText,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.chevron_right),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(height: 1),

                              // Activity Type row
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Activity Type'.tr,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    Text(
                                      activityTypeText,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),

                              // Intensity row
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Intensity'.tr,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    Text(
                                      intensityText,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryButtonColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    try {
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
                              activity: 0,
                              recovery: 0,
                            ),
                            recommendations: [],
                            createdAt: '',
                          ),
                          sessionId:
                              controller.calculatorSession.value?.sessionId,
                        ),
                      );
                    } catch (e) {
                      EasyLoading.showError(e.toString());
                    }
                  },
                  child: Text(
                    'Calculate'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: "Reset".tr,
                onTap: () async {
                  try {
                    final msg = await controller.resetSession();

                    controller.sportDurationController.clear();
                    controller.setTrainingIntent('NO_TRAINING');
                    controller.selectedActivityType.value = '';
                    controller.setSportIntensity(0);

                    EasyLoading.showSuccess(msg);
                  } catch (e) {
                    EasyLoading.showError(e.toString());
                  }
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
