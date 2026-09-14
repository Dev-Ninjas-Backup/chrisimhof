import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/hydration/controller/hydration_controller.dart';
import 'package:chrisimhof/features/hydration/widgets/hydration_edit_bottom_sheet.dart';
import 'package:chrisimhof/features/hydration/widgets/hydration_progress_card.dart';
import 'package:chrisimhof/features/hydration/widgets/listof_intakes.dart';
import 'package:chrisimhof/features/hydration/widgets/weekly_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HydrationScreen extends StatefulWidget {
  const HydrationScreen({super.key});

  @override
  State<HydrationScreen> createState() => _HydrationScreenState();
}

class _HydrationScreenState extends State<HydrationScreen> {
  late final HydrationController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<HydrationController>();
    controller.selectToday();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(title: 'Hydration'.tr, showBackButton: true),
              const SizedBox(height: 16),

              // 1. HYDRATION PROGRESS CARD
              HydrationProgressCard(controller: controller),
              const SizedBox(height: 24),

              // 2. QUICK INTAKE SECTION
              Text(
                'Quick Add'.tr,
                style: getTextStyle2(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
              ),
              const SizedBox(height: 12),

              // Quick Add 4-cards Row
              Row(
                children: controller.quickOptions.map((option) {
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => controller.addIntake(
                        option.amountMl,
                        option.typeName,
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(
                            color: AppColors.subtle,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.add_rounded,
                              color: AppColors.blue2,
                              size: 22,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${option.amountMl} ml',
                              style: getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.blue2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // "Personnalisé" / Custom Button
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  HydrationEditBottomSheet.show(
                    context,
                    controller: controller,
                    log: null,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(
                      color: AppColors.subtle,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.blue2,
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: AppColors.blue2,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Custom'.tr,
                              style: getTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Enter another quantity'.tr,
                              style: getTextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.primaryTextColor,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 26),

              // 3. SELECTED DAY'S INTAKE LIST
              Obx(() {
                final String dayName =
                    controller.selectedDayIndex.value ==
                        controller.todayIndex.value
                    ? 'Today'.tr
                    : controller
                          .weekLabels[controller.selectedDayIndex.value]
                          .tr;
                final count = controller.selectedDayDisplayLogs.length;
                final countText = count > 1 ? '$count ${'entries'.tr}' : '$count ${'entry'.tr}';

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dayName,
                      style: getTextStyle2(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    if (count > 0)
                      Text(
                        countText,
                        style: getTextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.greyAlt,
                        ),
                      ),
                  ],
                );
              }),
              const SizedBox(height: 12),

              ListofIntakes(controller: controller),
              const SizedBox(height: 26),

              // 4. WEEKLY CARD (Containing Weekly header & bar charts)
              WeeklyCard(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}
