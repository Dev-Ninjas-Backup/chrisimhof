import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/features/recomendations/controller/recomendations_controller.dart';
import 'package:chrisimhof/features/settings/main/controller/settings_controller.dart';
import 'package:chrisimhof/features/statistics/controller/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavItemData {
  const NavItemData({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

class NavController extends GetxController {
  final currentIndex = 0.obs;

  final List<NavItemData> items = const [
    NavItemData(label: 'Home', icon: Icons.pie_chart_outline_rounded),
    NavItemData(label: 'For you', icon: Icons.auto_awesome_rounded),
    NavItemData(label: 'Stats', icon: Icons.trending_up_rounded),
    NavItemData(label: 'Profile', icon: Icons.person_outline_rounded),
  ];

  void changeTab(int index) {
    switch (index) {
      case 0:
        try {
          Get.delete<DashboardController>(force: true);
        } catch (_) {}
        break;
      case 1:
        try {
          Get.delete<RecommendationController>(force: true);
        } catch (_) {}
        break;
      case 2:
        try {
          Get.delete<StatisticsController>(force: true);
        } catch (_) {}
        break;
      case 3:
        try {
          Get.delete<SettingsController>(force: true);
        } catch (_) {}
        break;
    }
    currentIndex.value = index;
  }
}
