import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/features/calculator/calculator_tabs/calculator_work_tab.dart';
import 'package:chrisimhof/features/calculator/widgets/calculator_live_score_section.dart';
import 'package:chrisimhof/features/calculator/widgets/caffeine_history_list.dart';
import 'package:chrisimhof/features/calculator/widgets/quick_entry.dart';
import 'package:chrisimhof/features/calculator/widgets/value_slider_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';

class CalculatorCaffeineTab extends StatelessWidget {
  const CalculatorCaffeineTab({super.key});

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.find<CalculatorController>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CalculatorLiveScoreSection(sectionKey: 'caffeine'),
          const SizedBox(height: 16),

          // Obx(
          //   () => Container(
          //     width: double.infinity,
          //     padding: const EdgeInsets.symmetric(vertical: 10),
          //     decoration: BoxDecoration(
          //       color: AppColors.primaryButtonColor,
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     child: Text(
          //       "Active caffeine in your body now: @value mg".trParams({
          //         'value': controller.caffeineLastEightHoursValue.value
          //             .toInt()
          //             .toString(),
          //       }),
          //       textAlign: TextAlign.center,
          //       style: const TextStyle(
          //         color: Colors.white,
          //         fontSize: 16,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 32),
          Obx(
            () => CaffeineTrackerCard(
              current24hValue: controller.caffeine24hValue.value,
              maxValue: controller.caffeinMaxValue.value,
              interactive: false,
            ),
          ),
          const SizedBox(height: 32),
          CaffeineHistoryList(),
          const SizedBox(height: 32),
          QuickEntrySelector(
            onEntrySelected: (preset, consumedAt) {
              controller.addCaffeineIntake(
                '${preset.label} (${preset.drinkType})',
                preset.defaultMg,
                consumedAt,
              );
            },
          ),
          const SizedBox(height: 130),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Obx(
              () => CustomButton(
                text: controller.isCaffeineSubmitting.value
                    ? 'Submitting...'.tr
                    : 'Next'.tr,
                onTap: () {
                  if (!controller.isCaffeineSubmitting.value) {
                    handleSubmitCaffeine(controller);
                  }
                },
              ),
            ),
          ),
          Obx(() {
            final errorMessage = controller.caffeineSubmitError.value;

            if (errorMessage.isEmpty) {
              return const SizedBox.shrink();
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              EasyLoading.showError(errorMessage);
              if (controller.caffeineSubmitError.value == errorMessage) {
                controller.caffeineSubmitError.value = '';
              }
            });

            return const SizedBox.shrink();
          }),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Obx(
                  () => TabButton(
                    text: controller.isCaffeineSubmitting.value
                        ? 'Skipping...'.tr
                        : 'Skip'.tr,
                    onTap: () {
                      if (!controller.isCaffeineSubmitting.value) {
                        _handleSkipCaffeine(controller);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TabButton(
                  text: 'Reset'.tr,
                  onTap: () async {
                    try {
                      final msg = await controller.resetSession();

                      controller.resetCaffeineTracking();

                      EasyLoading.showSuccess(msg);
                    } catch (e) {
                      EasyLoading.showError(e.toString());
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void handleSubmitCaffeine(CalculatorController controller) async {
    try {
      await controller.submitCaffeineIntake();
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        controller.caffeineSubmitError.value.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _handleSkipCaffeine(CalculatorController controller) async {
    try {
      await controller.skipCaffeineIntake();
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        controller.caffeineSubmitError.value.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
