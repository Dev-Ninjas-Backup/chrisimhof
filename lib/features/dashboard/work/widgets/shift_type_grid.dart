import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/work/controller/work_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShiftTypeGrid extends StatelessWidget {
  final WorkController controller;

  const ShiftTypeGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final shifts = [
      {
        'name': 'Day',
        'icon': Icons.wb_sunny_rounded,
        'color': AppColors.amber,
        'selectedBg': AppColors.orangeSoft,
        'selectedBorder': AppColors.amber,
      },
      {
        'name': 'Evening',
        'icon': Icons.auto_awesome_rounded,
        'color': AppColors.violet,
        'selectedBg': AppColors.lavenderSoft,
        'selectedBorder': AppColors.violet,
      },
      {
        'name': 'Night',
        'icon': Icons.nightlight_round,
        'color': AppColors.indigo,
        'selectedBg': AppColors.blueSoft,
        'selectedBorder': AppColors.indigo,
      },
      {
        'name': 'Off',
        'icon': Icons.favorite_rounded,
        'color': AppColors.secondaryButtonColor,
        'selectedBg': AppColors.mintSoft2,
        'selectedBorder': AppColors.secondaryButtonColor,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SHIFT TYPE',
          style: getTextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.textSoft,
          ).copyWith(letterSpacing: 1.1),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: shifts.map((shift) {
            final name = shift['name'] as String;
            final icon = shift['icon'] as IconData;
            final color = shift['color'] as Color;
            final selectedBg = shift['selectedBg'] as Color;
            final selectedBorder = shift['selectedBorder'] as Color;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Obx(() {
                  final isSelected = controller.selectedShiftType.value == name;

                  return GestureDetector(
                    onTap: () => controller.selectShift(name),
                    child: Container(
                      height: 98,
                      constraints: const BoxConstraints(
                        minWidth: 80,
                        maxWidth: 96,
                      ),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? selectedBg : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? selectedBorder : AppColors.gray100,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.05),
                            offset: const Offset(0, 4),
                            blurRadius: 20,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            color: isSelected ? AppColors.gray700 : color,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            name.tr,
                            style: getTextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? AppColors.gray700 : AppColors.textSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
