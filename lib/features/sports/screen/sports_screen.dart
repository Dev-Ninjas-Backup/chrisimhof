import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/sports/controller/sports_controller.dart';
import 'package:chrisimhof/features/sports/widgets/add_sport_session_bottomsheet.dart';
import 'package:chrisimhof/features/sports/widgets/list_of_workouts.dart';
import 'package:chrisimhof/features/sports/widgets/recovery_impact_card.dart';
import 'package:chrisimhof/features/sports/widgets/todays_sport_session_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SportsScreen extends StatelessWidget {
  const SportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SportsController controller = Get.put(SportsController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: 'Sport'.tr,
                showBackButton: true,
                showMoreButton: true,
              ),
              const SizedBox(height: 28),

              // TODAY'S SESSION CARD
              TodaysSportSessionCard(controller: controller),
              const SizedBox(height: 20.0),

              // RECOVERY IMPACT CARD
              RecoveryImpactCard(controller: controller),
              const SizedBox(height: 30.0),

              // LOG A NEW SESSION BUTTON
              CustomButton(
                text: 'Log a new session'.tr,
                plusIcon: true,
                showIcon: Icons.add,
                icon: null,
                backgroundColor: AppColors.primaryTextColor,
                textColor: Colors.white,
                iconColor: Colors.white,
                onTap: () => showLogSessionBottomSheet(context, controller),
              ),
              const SizedBox(height: 30.0),

              // THIS WEEK HEADER
              Text(
                'THIS WEEK'.tr,
                style: getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 12.0),

              // THIS WEEK LIST
              ListOfWorkouts(controller: controller),
            ],
          ),
        ),
      ),
    );
  }

  void showLogSessionBottomSheet(
      BuildContext context, SportsController controller) {
    final activity = 'Running'.obs;
    final duration = 45.obs;
    final zone = 'Z3'.obs;
    final effort = 'Medium'.obs;
    final type = 'cardio'.obs;
    final distanceController = TextEditingController(text: '6.8 km');
    final startTime = '12:40'.obs;
    final endTime = '13:25'.obs;

    Get.bottomSheet(
      AddSportSessionBottomsheet(
        activity: activity,
        type: type,
        zone: zone,
        duration: duration,
        effort: effort,
        distanceController: distanceController,
        startTime: startTime,
        endTime: endTime,
      ),
      isScrollControlled: true,
    );
  }
}
