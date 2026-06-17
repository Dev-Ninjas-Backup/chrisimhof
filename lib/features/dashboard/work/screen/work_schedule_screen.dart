import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/dashboard/work/controller/work_controller.dart';
import 'package:chrisimhof/features/dashboard/work/widgets/todays_shift_card.dart';
import 'package:chrisimhof/features/dashboard/work/widgets/shift_type_grid.dart';
import 'package:chrisimhof/features/dashboard/work/widgets/this_week_card.dart';
import 'package:chrisimhof/features/dashboard/work/widgets/shapes_today_card.dart';
import 'package:chrisimhof/features/dashboard/work/widgets/settings_tiles_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkScheduleScreen extends StatelessWidget {
  const WorkScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WorkController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(
                title: 'Work schedule',
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

              ShapesTodayCard(controller: controller),
              const SizedBox(height: 24),

              SettingsTilesCard(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}
