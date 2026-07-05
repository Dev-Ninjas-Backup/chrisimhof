import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/work_schedule_settings/controller/work_schedule_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RotationBuilderCard extends StatelessWidget {
  final WorkScheduleSettingsController controller;
  final List<String> daysOfWeek;

  const RotationBuilderCard({
    super.key,
    required this.controller,
    required this.daysOfWeek,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSoft),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        final totalWeeks = controller.weeks.value;
        return Column(
          children: List.generate(totalWeeks, (weekIdx) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (weekIdx > 0) const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.mintSoft,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Week ${weekIdx + 1}'.tr.toUpperCase(),
                        style: getTextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.secondaryButtonColor,
                        ).copyWith(letterSpacing: 1.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...List.generate(7, (dayIdx) {
                  final overallDayIdx = (weekIdx * 7) + dayIdx;
                  if (overallDayIdx >= controller.pattern.length) {
                    return const SizedBox.shrink();
                  }

                  final dayName = daysOfWeek[dayIdx];
                  final currentShift = controller.pattern[overallDayIdx];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            dayName.tr,
                            style: getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: ['D', 'E', 'N', 'Off'].map((shiftCode) {
                              final isSelected = currentShift == shiftCode;
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0,
                                  ),
                                  child: GestureDetector(
                                    onTap: () => controller.updateDayPattern(
                                      overallDayIdx,
                                      shiftCode,
                                    ),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 150,
                                      ),
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? _getShiftColor(
                                                shiftCode,
                                                bg: true,
                                              )
                                            : AppColors.gray100,
                                        borderRadius: BorderRadius.circular(8),
                                        border: isSelected
                                            ? Border.all(
                                                color: _getShiftColor(
                                                  shiftCode,
                                                  bg: false,
                                                ),
                                                width: 1,
                                              )
                                            : Border.all(
                                                color: AppColors.transparent,
                                              ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        shiftCode.tr,
                                        style: getTextStyle(
                                          fontSize: 12,
                                          fontWeight: isSelected
                                              ? FontWeight.w800
                                              : FontWeight.w500,
                                          color: isSelected
                                              ? _getShiftColor(
                                                  shiftCode,
                                                  bg: false,
                                                )
                                              : AppColors.textSoft,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          }),
        );
      }),
    );
  }

  Color _getShiftColor(String code, {required bool bg}) {
    if (code == 'D') {
      return bg ? AppColors.amberSoft3 : AppColors.orangeAccent2;
    } else if (code == 'E') {
      return bg ? AppColors.lavenderSoft : AppColors.violet;
    } else if (code == 'N') {
      return bg ? AppColors.indigoSoft : AppColors.indigo;
    } else {
      // Off
      return bg ? AppColors.mintSoft2 : AppColors.secondaryButtonColor;
    }
  }
}
