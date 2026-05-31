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

  void changeTab(int index) => currentIndex.value = index;
}
