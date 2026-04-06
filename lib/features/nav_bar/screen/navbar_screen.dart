import 'package:chrisimhof/features/dashboard/screen/dashboard_screen.dart';
import 'package:chrisimhof/features/nav_bar/controller/nav_controller.dart';
import 'package:chrisimhof/features/nav_bar/widget/custom_navbar.dart';
import 'package:chrisimhof/features/settings/main/screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      body: Obx(() => _screens[controller.currentIndex.value]),
      bottomNavigationBar: const CustomNavBar(),
    );
  }
}

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Analytics',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'History',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
