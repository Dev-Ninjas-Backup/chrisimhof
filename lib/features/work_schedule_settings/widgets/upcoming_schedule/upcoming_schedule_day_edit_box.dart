import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/work_schedule_settings/controller/work_schedule_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpcomingScheduleDayEditBox extends StatelessWidget {
  final WorkScheduleSettingsController controller;
  final DateTime date;
  final String currentShift;
  final bool isOverride;

  const UpcomingScheduleDayEditBox({
    super.key,
    required this.controller,
    required this.date,
    required this.currentShift,
    required this.isOverride,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDateStr = DateFormat('EEE, d MMM').format(date);
    final tempShift = currentShift.obs;

    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.mintSoft3,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.secondaryButtonColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${'Edit'.tr} $formattedDateStr',
            style: getTextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 10),

          // Shift buttons D E N Off
          Obx(() {
            return Row(
              children: ['D', 'E', 'N', 'Off'].map((code) {
                final isSelected = tempShift.value == code;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: GestureDetector(
                      onTap: () => tempShift.value = code,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: 34,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.secondaryButtonColor
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.secondaryButtonColor
                                : AppColors.borderSoft,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          code.tr,
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.primaryTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.applyDayOverride(date, tempShift.value);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryButtonColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'Apply to this day'.tr,
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
              if (isOverride) const SizedBox(width: 8),
              if (isOverride)
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: OutlinedButton(
                      onPressed: () {
                        controller.revertDayOverride(date);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.textSoft,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Revert to rotation'.tr,
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSoft,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
