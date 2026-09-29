import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/statistics/controller/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalyticsHeaderTabs extends StatelessWidget {
  final StatisticsController controller;

  const AnalyticsHeaderTabs({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Historique'.tr,
            style: getTextStyle2(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryTextColor,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Container(
          height: 48,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F4F6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Obx(() {
            final activeTab = controller.selectedTab.value;
            return Row(
              children: [
                Expanded(
                  child: _buildTabButton(
                    title: 'Ma journée'.tr,
                    isSelected: activeTab == 0,
                    onTap: () => controller.selectedTab.value = 0,
                  ),
                ),
                Expanded(
                  child: _buildTabButton(
                    title: "Vue d'ensemble".tr,
                    isSelected: activeTab == 1,
                    onTap: () => controller.selectedTab.value = 1,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTabButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: getTextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? const Color(0xFF1E293B)
                : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}
