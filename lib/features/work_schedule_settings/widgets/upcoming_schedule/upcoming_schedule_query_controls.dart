import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/work_schedule_settings/controller/work_schedule_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpcomingScheduleQueryControls extends StatelessWidget {
  final WorkScheduleSettingsController controller;

  const UpcomingScheduleQueryControls({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final fromDate = controller.calendarFromDate.value;
      final daysLimit = controller.calendarDaysLimit.value;
      final formattedFromStr = DateFormat('yyyy-MM-dd').format(fromDate);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Start Date picker container
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Date (from)'.tr,
                      style: getTextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSoft,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: fromDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
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
                          controller.updateCalendarRange(picked, daysLimit);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gray100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.borderSoft),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 16,
                              color: AppColors.secondaryButtonColor,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                formattedFromStr,
                                style: getTextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Days Limit stepper container
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Days Limit'.tr,
                    style: getTextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSoft,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderSoft),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (daysLimit > 1) {
                              controller.updateCalendarRange(
                                fromDate,
                                daysLimit - 1,
                              );
                            }
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.borderSoft),
                            ),
                            child: const Icon(
                              Icons.remove,
                              size: 16,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '$daysLimit ${'days'.tr}',
                            style: getTextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (daysLimit < 60) {
                              controller.updateCalendarRange(
                                fromDate,
                                daysLimit + 1,
                              );
                            }
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.borderSoft),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 16,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    });
  }
}
