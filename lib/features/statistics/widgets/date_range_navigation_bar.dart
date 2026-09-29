import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/statistics/controller/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateRangeNavigationBar extends StatelessWidget {
  final StatisticsController controller;

  const DateRangeNavigationBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dateText = controller.selectedTab.value == 0
          ? controller.formattedSingleDay
          : controller.formattedDateRange;

      return Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildArrowButton(
              icon: Icons.chevron_left_rounded,
              onTap: controller.selectedTab.value == 0
                  ? controller.previousDay
                  : controller.previousPeriod,
            ),
            Expanded(
              child: Text(
                dateText,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final initial = controller.selectedTab.value == 0
                        ? controller.myDaySelectedDate.value
                        : controller.periodEndDate.value;
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: initial,
                      firstDate: DateTime(2024),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppColors.secondaryButtonColor,
                              onPrimary: AppColors.white,
                              onSurface: AppColors.primaryTextColor,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      if (controller.selectedTab.value == 0) {
                        controller.myDaySelectedDate.value = picked;
                      } else {
                        controller.periodEndDate.value = picked;
                        controller.loadAnalytics();
                      }
                    }
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                _buildArrowButton(
                  icon: Icons.chevron_right_rounded,
                  onTap: controller.selectedTab.value == 0
                      ? controller.nextDay
                      : controller.nextPeriod,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF334155),
          ),
        ),
      ),
    );
  }
}
