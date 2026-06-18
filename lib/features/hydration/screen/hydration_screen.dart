import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/hydration/controller/hydration_controller.dart';
import 'package:chrisimhof/features/hydration/widgets/hydration_progress_card.dart';
import 'package:chrisimhof/features/hydration/widgets/listof_intakes.dart';
import 'package:chrisimhof/features/hydration/widgets/weekly_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HydrationScreen extends StatelessWidget {
  const HydrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HydrationController controller = Get.put(HydrationController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: 'Hydration'.tr,
                showBackButton: true,
              ),
              const SizedBox(height: 16),
                
              // 1. HYDRATION PROGRESS CARD
              HydrationProgressCard(controller: controller),
              const SizedBox(height: 20),
                
              // 2. QUICK INTAKE ROW
              Row(
                children: controller.quickOptions.map((option) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => controller.addIntake(option.amountMl, option.typeName),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 4),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(color: AppColors.subtle, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '+ ${option.amountMl}',
                              style: getTextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.blue2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              option.label.tr,
                              style: getTextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),
                
              // 3. SELECTED DAY'S INTAKE LIST
              Obx(() {
                final String dayName = controller.selectedDayIndex.value == controller.todayIndex.value
                    ? 'TODAY'.tr
                    : controller.weekLabels[controller.selectedDayIndex.value].tr;
                return Text(
                  "$dayName'S INTAKE",
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryTextColor,
                  ),
                );
              }),
              const SizedBox(height: 12),
                
              ListofIntakes(controller: controller),
              const SizedBox(height: 30),
                
              // 4. WEEKLY CARD (Containing Weekly header & bar charts)
              WeeklyCard(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}
