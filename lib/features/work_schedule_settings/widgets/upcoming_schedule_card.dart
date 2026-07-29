import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/work_schedule_settings/controller/work_schedule_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpcomingScheduleCard extends StatelessWidget {
  final WorkScheduleSettingsController controller;

  const UpcomingScheduleCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final upcomingDays = List.generate(7, (i) => now.add(Duration(days: i)));

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
          children: List.generate(upcomingDays.length, (idx) {
            final date = upcomingDays[idx];
            final dateStr =
                '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
            final isToday = idx == 0;
            final isOverride = controller.overrides.containsKey(dateStr);
            final currentShift = controller.getShiftForDate(date);
            final isEditing = controller.editingDateStr.value == dateStr;

            final dayName = DateFormat('EEE').format(date).toUpperCase();
            final dayNum = date.day.toString();

            return Column(
              children: [
                if (idx > 0) const Divider(height: 16, color: AppColors.borderSoft),
                
                // Normal Row
                GestureDetector(
                  onTap: () {
                    if (isEditing) {
                      controller.editingDateStr.value = '';
                    } else {
                      controller.editingDateStr.value = dateStr;
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        // Date column (MON 6)
                        SizedBox(
                          width: 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dayName,
                                style: getTextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textSoft,
                                ),
                              ),
                              Text(
                                dayNum,
                                style: getTextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Shift Dot & Shift Name
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getShiftDotColor(currentShift),
                          ),
                        ),
                        const SizedBox(width: 8),

                        Text(
                          _getShiftFullName(currentShift),
                          style: getTextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Time range text if not Off
                        if (currentShift != 'Off')
                          Text(
                            _getShiftTimeRange(currentShift),
                            style: getTextStyle(
                              fontSize: 12,
                              color: AppColors.textSoft,
                            ),
                          ),

                        const Spacer(),

                        // Badge: TODAY or EDITED
                        if (isToday)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.mintSoft,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'TODAY'.tr,
                              style: getTextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: AppColors.secondaryButtonColor,
                              ),
                            ),
                          )
                        else if (isOverride)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.gray100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'EDITED'.tr,
                              style: getTextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textSoft,
                              ),
                            ),
                          )
                        else
                          Icon(
                            isEditing
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.chevron_right_rounded,
                            color: AppColors.grey,
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                ),

                // Expanded Edit Box matching Image 1 right screen
                if (isEditing)
                  _buildEditDayBox(context, date, currentShift, isOverride),
              ],
            );
          }),
        );
      }),
    );
  }

  Widget _buildEditDayBox(
    BuildContext context,
    DateTime date,
    String currentShift,
    bool isOverride,
  ) {
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

  Color _getShiftDotColor(String code) {
    if (code == 'D') return AppColors.orangeAccent2;
    if (code == 'E') return AppColors.violet;
    if (code == 'N') return AppColors.indigo;
    return AppColors.grey;
  }

  String _getShiftFullName(String code) {
    if (code == 'D') return 'Day'.tr;
    if (code == 'E') return 'Evening'.tr;
    if (code == 'N') return 'Night'.tr;
    return 'Off'.tr;
  }

  String _getShiftTimeRange(String code) {
    final name = _getShiftFullName(code);
    final times = controller.shiftTimes[name];
    if (times != null) {
      return '${times['start']}–${times['end']}';
    }
    return '';
  }
}
