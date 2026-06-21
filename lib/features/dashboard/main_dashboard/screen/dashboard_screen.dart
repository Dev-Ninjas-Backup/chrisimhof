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
import 'package:shimmer/shimmer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use putOrFind to avoid re-creating controllers on every rebuild
    final controller = Get.isRegistered<DashboardController>()
        ? Get.find<DashboardController>()
        : Get.put(DashboardController());
    // Register shared controllers so they persist across route changes
    // and receive socket updates from DashboardController.
    if (!Get.isRegistered<RecommendationController>())
      Get.put(RecommendationController());
    if (!Get.isRegistered<SleepController>()) Get.put(SleepController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () => controller.fetchDashboardData(),
        color: AppColors.secondaryButtonColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(
                  showBackButton: false,
                  showSettingsButton: true,
                  showLogo: true,
                ),
                const SizedBox(height: 30),
                Obx(() {
                  if (controller.isLoading.value && !controller.hasLoadedOnce.value) {
                    return const DashboardShimmer();
                  }

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
                    ],
                  );
                }),
                const SizedBox(height: 90),
              ],
            ),
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

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey[300]!;
    final highlightColor = Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting & Date Shimmer
          Container(
            width: 140,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 200,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),

          // Bedtime Card Shimmer
          Container(
            width: double.infinity,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          const SizedBox(height: 24),

          // Quick Add Section Shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              4,
              (index) => Container(
                width: (MediaQuery.of(context).size.width - 32 - 36) / 4,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Today Progress Section Shimmer
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          const SizedBox(height: 24),

          // Split Status Section Shimmer (2 columns)
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // For You Section Shimmer
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ],
      ),
    );
  }
}
