import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_range_slider.dart';
import 'package:chrisimhof/core/common/widgets/time_widget.dart';
import 'package:chrisimhof/features/calculator/calculator_tabs/calculator_work_tab.dart';
import 'package:chrisimhof/features/calculator/widgets/caffeine_history_list.dart';
import 'package:chrisimhof/features/calculator/widgets/quick_entry.dart';
import 'package:chrisimhof/features/calculator/widgets/value_slider_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';

class CalculatorCaffeineTab extends StatelessWidget {
  const CalculatorCaffeineTab({super.key});

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.find<CalculatorController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Text
          Text(
            "Caffeine (last 8 hours)",
            style: getTextStyle(
              color: AppColors.primaryTextColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Obx(
            () => Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                color: AppColors.primaryButtonColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                "Active caffeine in your body now: ${controller.caffeineLastEightHoursValue.value.toInt()} mg",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Obx(
            () => CaffeineTrackerCard(
              current24hValue: controller.caffeine24hValue.value,
              maxValue: controller.caffeinMaxValue.value,
            ),
          ),
          const SizedBox(height: 32),
          CaffeineHistoryList(),
          const SizedBox(height: 32),
          QuickEntrySelector(
            onEntrySelected: (name, amount) {
              controller.addCaffeineIntake(name, amount, 'Now');
              Get.snackbar(
                'Caffeine Added',
                '$name ($amount mg) added to your intake',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          SizedBox(height: 32),
          TimeWidget(
            topTitle: 'Time of Intake',
            controller: controller.caffeineIntakeTimeController,
          ),
          const SizedBox(height: 150),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: CustomButton(
              text: 'Next',
              onTap: () {
                Get.snackbar(
                  'Caffeine Saved',
                  'Your caffeine intake has been recorded',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TabButton(
                  text: 'Skip',
                  onTap: () {
                    Get.snackbar(
                      'Skipped',
                      'Caffeine tracking skipped for this cycle',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TabButton(
                  text: 'Reset',
                  onTap: () {
                    controller.resetCaffeineTracking();
                    Get.snackbar(
                      'Reset',
                      'Caffeine tracking has been reset',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}