import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/widgets/bedtime_card.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/widgets/end_day_button.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/widgets/for_you_section.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/widgets/quick_add_section.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/widgets/split_status_section.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/widgets/today_progress_section.dart';
import 'package:chrisimhof/features/dashboard/sleep/controller/sleep_controller.dart';
import 'package:chrisimhof/features/recomendations/controller/recomendations_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    // Register shared controllers so they persist across route changes
    // and receive socket updates from DashboardController.
    Get.put(RecommendationController());
    Get.put(SleepController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                showBackButton: false,
                showSettingsButton: true,
                showLogo: true,
              ),
              Obx(() {
                final data = controller.dashboardData.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(data.date),
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSoft,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _getGreeting(data.userName),
                      style: getTextStyle2(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),
              const BedtimeCard(),
              const SizedBox(height: 24),
              const QuickAddSection(),
              const SizedBox(height: 24),
              const TodayProgressSection(),
              const SizedBox(height: 24),
              SplitStatusSection(),
              const SizedBox(height: 24),
              const ForYouSection(),
              const SizedBox(height: 28),
              const EndDayButton(),
              SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${weekdays[dt.weekday - 1]}, ${months[dt.month - 1]} ${dt.day}';
  }

  String _getGreeting(String name) {
    final isFrench = Get.locale?.languageCode == 'fr';
    final hour = DateTime.now().hour;
    if (isFrench) {
      return hour >= 18 ? 'Bonsoir, $name' : 'Bonjour, $name';
    } else {
      return hour >= 18 ? 'Good evening, $name' : 'Hello, $name';
    }
  }
}
