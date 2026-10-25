import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/work/controller/work_controller.dart';
import 'package:chrisimhof/features/dashboard/work/widgets/todays_shift_card.dart';
import 'package:chrisimhof/features/dashboard/work/widgets/shift_type_grid.dart';
import 'package:chrisimhof/features/dashboard/work/widgets/this_week_card.dart';
import 'package:chrisimhof/features/dashboard/work/widgets/settings_tiles_card.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkScheduleScreen extends StatelessWidget {
  const WorkScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: 'Work schedule'.tr,
                showBackButton: true,
                showMoreButton: false,
              ),
              const SizedBox(height: 20),
              TodaysShiftCard(controller: controller),
              const SizedBox(height: 24),

              ShiftTypeGrid(controller: controller),
              const SizedBox(height: 24),

              ThisWeekCard(controller: controller),
              const SizedBox(height: 24),

              // Direct custom rotation shortcut (Feedback 08 Oct, Issue 08)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderSoft),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.02),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => Get.toNamed(AppRoutes.workScheduleSettingsScreen),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.add_circle_outline_rounded,
                              color: Color(0xFF2563EB),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create a custom rotation'.tr,
                                  style: getTextStyle2(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryTextColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Set your personal shift rotation schedule'.tr,
                                  style: getTextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSoft,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFF94A3B8),
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SettingsTilesCard(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}
