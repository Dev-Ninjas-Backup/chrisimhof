import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_range_slider.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:chrisimhof/features/calculator/widgets/calculator_live_score_section.dart';
import 'package:chrisimhof/features/calculator/widgets/hydration_entry_card.dart';
import 'package:chrisimhof/features/calculator/widgets/hydration_history_list.dart';
import 'package:chrisimhof/features/calculator/widgets/hydration_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class CalculatorHydrationTab extends StatelessWidget {
  const CalculatorHydrationTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CalculatorController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CalculatorLiveScoreSection(sectionKey: 'hydration'),
        const SizedBox(height: 24),
        Obx(() {
          final consumed = controller.hydrationConsumedController.value.value;
          final goal = controller.hydrationDailyGoalController.value.value;
          final remaining = (goal - consumed).clamp(0.0, double.infinity);

          return HydrationSummaryCard(
            consumed: consumed,
            goal: goal,
            remaining: remaining,
          );
        }),
        const SizedBox(height: 26),
        HydrationEntryCard(controller: controller),
        const SizedBox(height: 26),
        HydrationHistoryList(controller: controller),
        const SizedBox(height: 26),
        CustomRangeSlider(
          required: false,
          headerText: "Daily Goal (L)".tr,
          controller: controller.hydrationDailyGoalController,
          divisions: 40,
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
            "Hydration recommendation may adjust automatically based on sport activity"
                .tr,
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
                ? 'Submitting...'.tr
                : 'Next'.tr,
            onTap: controller.isHydrationSubmitting.value
                ? null
                : () {
                    controller.submitHydrationData();
                  },

          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          final errorMessage = controller.hydrationSubmitError.value;

          if (errorMessage.isEmpty) {
            return const SizedBox.shrink();
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            EasyLoading.showError(errorMessage);
            if (controller.hydrationSubmitError.value == errorMessage) {
              controller.hydrationSubmitError.value = '';
            }
          });

          return const SizedBox.shrink();
        }),
        CustomButton(
          text: "Reset".tr,
          onTap: () async {
            try {
              final msg = await controller.resetSession();

              controller.resetHydrationTracking();

              EasyLoading.showSuccess(msg);
            } catch (e) {
              EasyLoading.showError(e.toString());
            }
          },
          backgroundColor: Colors.grey[300],
        ),
      ],
    );
  }
}
