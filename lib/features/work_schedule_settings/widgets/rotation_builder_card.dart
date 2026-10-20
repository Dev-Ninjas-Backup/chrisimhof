import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/service/helper/shift_display_helper.dart';
import 'package:chrisimhof/features/work_schedule_settings/controller/work_schedule_settings_controller.dart';
import 'package:chrisimhof/features/work_schedule_settings/widgets/template_selection_sheet.dart';
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

  bool get _isFrench => (Get.locale?.languageCode ?? 'en') == 'fr';

  String _formatShortDate(DateTime d) {
    const monthsEn = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const monthsFr = [
      'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'
    ];
    return '${d.day} ${(_isFrench ? monthsFr : monthsEn)[d.month - 1]}';
  }

  String _formatWeekday(DateTime d) {
    const weekdaysEn = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    const weekdaysFr = [
      'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'
    ];
    return (_isFrench ? weekdaysFr : weekdaysEn)[d.weekday - 1];
  }

  String _formatFullDate(DateTime d) {
    final w = _formatWeekday(d);
    final m = _formatShortDate(d);
    return '$w, $m ${d.year}';
  }

  Future<void> _pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.startDate.value,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
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
      controller.startDate.value = picked;
    }
  }

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
        final totalWeeks = controller.weeks.value;
        final baseStartDate = controller.startDate.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Start Date Context & Helper Banner
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.mintSoft3,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.secondaryButtonColor.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      size: 18,
                      color: AppColors.secondaryButtonColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Rotation starts on:'.tr,
                              style: getTextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSoft,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _formatFullDate(baseStartDate),
                                style: getTextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryTextColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Assign each day\'s shift below. The pattern repeats every @weeks automatically.'
                              .trParams({
                            'weeks':
                                '${totalWeeks} ${totalWeeks == 1 ? 'week'.tr : 'weeks'.tr}',
                          }),
                          style: getTextStyle(
                            fontSize: 11,
                            color: AppColors.textSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => _pickStartDate(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.secondaryButtonColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.edit_calendar_rounded,
                            size: 13,
                            color: AppColors.secondaryButtonColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Change'.tr,
                            style: getTextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondaryButtonColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ...List.generate(totalWeeks, (weekIdx) {
              final weekStart = baseStartDate.add(Duration(days: weekIdx * 7));
              final weekEnd = baseStartDate.add(Duration(days: weekIdx * 7 + 6));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (weekIdx > 0) const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Week Badge with calendar dates
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.mintSoft,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.secondaryButtonColor
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          '${'WEEK'.tr} ${weekIdx + 1} · ${_formatShortDate(weekStart)} – ${_formatShortDate(weekEnd)}',
                          style: getTextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.secondaryButtonColor,
                          ).copyWith(letterSpacing: 0.5),
                        ),
                      ),

                      // "Use a template" button on Week 1 header
                      if (weekIdx == 0)
                        InkWell(
                          onTap: () => _openTemplateSheet(context),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.secondaryButtonColor,
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.auto_awesome_outlined,
                                  size: 13,
                                  color: AppColors.secondaryButtonColor,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Use a template'.tr,
                                  style: getTextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.secondaryButtonColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ...List.generate(7, (dayIdx) {
                    final overallDayIdx = (weekIdx * 7) + dayIdx;
                    if (overallDayIdx >= controller.pattern.length) {
                      return const SizedBox.shrink();
                    }

                    final dayDate = baseStartDate.add(
                      Duration(days: overallDayIdx),
                    );
                    final weekdayName = _formatWeekday(dayDate);
                    final dayDateStr = _formatShortDate(dayDate);
                    final isFirstDay = overallDayIdx == 0;
                    final currentShift = controller.pattern[overallDayIdx];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          // Day name and date with start indicator
                          SizedBox(
                            width: 86,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      weekdayName,
                                      style: getTextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: isFirstDay
                                            ? AppColors.secondaryButtonColor
                                            : AppColors.primaryTextColor,
                                      ),
                                    ),
                                    if (isFirstDay) ...[
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 1,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.mintSoft,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'Start'.tr,
                                          style: getTextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                            color:
                                                AppColors.secondaryButtonColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  dayDateStr,
                                  style: getTextStyle(
                                    fontSize: 11,
                                    fontWeight: isFirstDay
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isFirstDay
                                        ? AppColors.secondaryButtonColor
                                        : AppColors.textSoft,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ...controller.shiftTimes.keys,
                                'Off',
                              ].map((shiftOption) {
                                final isSelected = currentShift == shiftOption;
                                final abbrev = controller.getDisplayCodeForDay(
                                  overallDayIdx,
                                  shiftOption,
                                );

                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 3.0,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (isSelected) {
                                          _showCustomizeCodeDialog(
                                            context,
                                            overallDayIdx,
                                            shiftOption,
                                          );
                                        } else {
                                          controller.updateDayPattern(
                                            overallDayIdx,
                                            shiftOption,
                                          );
                                        }
                                      },
                                      onLongPress: () => _showCustomizeCodeDialog(
                                        context,
                                        overallDayIdx,
                                        shiftOption,
                                      ),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 160,
                                        ),
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? _getShiftColor(
                                                  shiftOption,
                                                  bg: true,
                                                )
                                              : AppColors.gray100,
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          border: Border.all(
                                            color: isSelected
                                                ? _getShiftColor(
                                                    shiftOption,
                                                    bg: false,
                                                  )
                                                : AppColors.transparent,
                                            width: isSelected ? 1.5 : 1,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          abbrev,
                                          style: getTextStyle(
                                            fontSize:
                                                abbrev.length > 2 ? 10 : 11,
                                            fontWeight: isSelected
                                                ? FontWeight.w800
                                                : FontWeight.w600,
                                            color: isSelected
                                                ? _getShiftColor(
                                                    shiftOption,
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
            const SizedBox(height: 12),
            Text(
              'Touchez le code du poste sélectionné pour le personnaliser.'.tr,
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSoft,
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showCustomizeCodeDialog(
    BuildContext context,
    int dayIndex,
    String shiftOption,
  ) {
    final currentCode = controller.getDisplayCodeForDay(dayIndex, shiftOption);
    final textController = TextEditingController(text: currentCode);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Customize shift code'.tr,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter a custom initial or short code (e.g. DN)'.tr,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: textController,
                maxLength: 4,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: 'e.g. DN, J, A, N',
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.setDayDisplayCode(dayIndex, null);
                Navigator.of(ctx).pop();
              },
              child: Text(
                'Reset to default'.tr,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                final customCode = textController.text.trim().toUpperCase();
                controller.setDayDisplayCode(
                  dayIndex,
                  customCode.isEmpty ? null : customCode,
                );
                Navigator.of(ctx).pop();
              },
              child: Text(
                'Save'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryButtonColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openTemplateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TemplateSelectionSheet(controller: controller),
    );
  }

  Color _getShiftColor(String key, {required bool bg}) {
    return ShiftDisplayHelper.getShiftColor(key, bg: bg);
  }
}
