import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/work_schedule_settings/controller/work_schedule_settings_controller.dart';
import 'package:chrisimhof/features/work_schedule_settings/widgets/upcoming_schedule/upcoming_schedule_day_edit_box.dart';
import 'package:chrisimhof/features/work_schedule_settings/widgets/upcoming_schedule/upcoming_schedule_day_row.dart';
import 'package:chrisimhof/features/work_schedule_settings/widgets/upcoming_schedule/upcoming_schedule_query_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpcomingScheduleCard extends StatelessWidget {
  final WorkScheduleSettingsController controller;

  const UpcomingScheduleCard({super.key, required this.controller});

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
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Controls Section: Start Date & Days Limit
            UpcomingScheduleQueryControls(controller: controller),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.borderSoft),
            const SizedBox(height: 16),

            if (controller.isLoadingCalendar.value)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30.0),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.secondaryButtonColor,
                  ),
                ),
              )
            else if (controller.upcomingScheduleDays.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Text(
                    'No schedule items found'.tr,
                    style: getTextStyle(
                      fontSize: 14,
                      color: AppColors.textSoft,
                    ),
                  ),
                ),
              )
            else
              _buildScheduleList(context),
          ],
        );
      }),
    );
  }

  Widget _buildScheduleList(BuildContext context) {
    final now = DateTime.now();
    final calendarDays = controller.upcomingScheduleDays;

    return Column(
      children: List.generate(calendarDays.length, (idx) {
        final apiDay = calendarDays[idx];
        final dt = DateTime.tryParse(apiDay.date) ?? now;
        final dateStr = apiDay.date;
        final code = _mapShiftTypeToCode(apiDay.shiftType);

        String timeRangeStr = '';
        if (code != 'Off' &&
            apiDay.shiftStartTime.isNotEmpty &&
            apiDay.shiftEndTime.isNotEmpty) {
          timeRangeStr = '${apiDay.shiftStartTime}–${apiDay.shiftEndTime}';
        }

        final bool isOverride = apiDay.isOverride ||
            controller.overrides.containsKey(dateStr);
        final isToday = dt.year == now.year &&
            dt.month == now.month &&
            dt.day == now.day;
        final isEditing = controller.editingDateStr.value == dateStr;

        return Column(
          children: [
            if (idx > 0) const Divider(height: 16, color: AppColors.borderSoft),

            // Day Row Component
            UpcomingScheduleDayRow(
              date: dt,
              currentShift: code,
              timeRangeStr: timeRangeStr,
              isToday: isToday,
              isOverride: isOverride,
              isEditing: isEditing,
              onTap: () {
                if (isEditing) {
                  controller.editingDateStr.value = '';
                } else {
                  controller.editingDateStr.value = dateStr;
                }
              },
            ),

            // Expanded Edit Box Component
            if (isEditing)
              UpcomingScheduleDayEditBox(
                controller: controller,
                date: dt,
                currentShift: code,
                isOverride: isOverride,
              ),
          ],
        );
      }),
    );
  }

  String _mapShiftTypeToCode(String type) {
    final lower = type.toLowerCase();
    if (lower == 'day') return 'D';
    if (lower == 'evening') return 'E';
    if (lower == 'night') return 'N';
    return 'Off';
  }
}
