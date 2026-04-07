import 'package:chrisimhof/features/analytics/screen/analytics_screen.dart';
import 'package:chrisimhof/features/dashboard/screen/dashboard_screen.dart';
import 'package:chrisimhof/features/history/screen/history_screen.dart';
import 'package:chrisimhof/features/nav_bar/controller/nav_controller.dart';
import 'package:chrisimhof/features/nav_bar/widget/custom_navbar.dart';
import 'package:chrisimhof/features/settings/main/screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Total height the floating navbar occupies from the screen bottom.
/// Screens must add this as bottom padding so content isn't hidden.
const double kNavBarTotalHeight =
    32 + 12 + 56; // bottom + top padding + pill height

class NavbarScreen extends StatelessWidget {
  const NavbarScreen({super.key});

  static const List<Widget> _screens = [
    DashboardScreen(),
    AnalyticsScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Obx(() => _screens[controller.currentIndex.value]),
          const Align(alignment: Alignment.bottomCenter, child: CustomNavBar()),
        ],
      ),
    );
  }
}
