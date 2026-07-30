import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/work_schedule_settings/controller/work_schedule_settings_controller.dart';
import 'package:chrisimhof/features/work_schedule_settings/widgets/custom_rotation_toggle_card.dart';
import 'package:chrisimhof/features/work_schedule_settings/widgets/rotation_builder_card.dart';
import 'package:chrisimhof/features/work_schedule_settings/widgets/rotation_cycle_card.dart';
import 'package:chrisimhof/features/work_schedule_settings/widgets/shift_times_card.dart';
import 'package:chrisimhof/features/work_schedule_settings/widgets/upcoming_schedule_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkScheduleSettingsScreen extends StatelessWidget {
  const WorkScheduleSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkScheduleSettingsController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchMyWorkRotation();
    });

    final daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.fetchMyWorkRotation(),
          color: AppColors.secondaryButtonColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(
                  title: 'Work schedule',
                  showBackButton: true,
                  showMoreButton: false,
                ),
                const SizedBox(height: 16),
                _buildHeaderSection(),
                const SizedBox(height: 24),

                Obx(() {
                  if (controller.isRotationLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.secondaryButtonColor,
                        ),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Enable Custom Rotation toggle card
                      CustomRotationToggleCard(controller: controller),
                      const SizedBox(height: 20),

                      Obx(() {
                        if (!controller.isEnabled.value) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('SHIFT TIMES'.tr),
                            const SizedBox(height: 8),
                            ShiftTimesCard(controller: controller),
                            const SizedBox(height: 24),

                            _buildSectionTitle('ROTATION CYCLE'.tr),
                            const SizedBox(height: 8),
                            RotationCycleCard(controller: controller),
                            const SizedBox(height: 24),

                            _buildSectionTitle('BUILD YOUR ROTATION'.tr),
                            const SizedBox(height: 8),
                            RotationBuilderCard(
                              controller: controller,
                              daysOfWeek: daysOfWeek,
                            ),
                            const SizedBox(height: 24),

                            _buildSectionTitle('UPCOMING SCHEDULE'.tr),
                            const SizedBox(height: 8),
                            UpcomingScheduleCard(controller: controller),
                            const SizedBox(height: 32),
                          ],
                        );
                      }),

                      CustomButton(
                        text: 'Save Rotation'.tr,
                        onTap: controller.saveSettings,
                        icon: null,
                      ),
                      const SizedBox(height: 40),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manage schedule'.tr,
          style: getTextStyle2(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Configure your default shift rotation and shift times once. The app will automatically map them to your calendar.'
              .tr,
          style: getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: getTextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: AppColors.textSoft,
        ).copyWith(letterSpacing: 1.2),
      ),
    );
  }
}
