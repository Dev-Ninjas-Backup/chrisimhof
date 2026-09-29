import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/statistics/controller/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PeriodFilterBar extends StatelessWidget {
  final StatisticsController controller;

  const PeriodFilterBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> periods = [
      {'key': '7d', 'label': '7 j'.tr},
      {'key': '30d', 'label': '30 j'.tr},
      {'key': '90d', 'label': '90 j'.tr},
      {'key': '1y', 'label': '1 an'.tr},
    ];

    return Obx(() {
      final current = controller.selectedPeriod.value;
      return Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F6),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: periods.map((p) {
            final isSelected = current == p['key'];
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.changePeriod(p['key']!),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: isSelected
                        ? Border.all(color: const Color(0xFF34D399), width: 1.2)
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    p['label']!,
                    style: getTextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primaryTextColor
                          : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}
