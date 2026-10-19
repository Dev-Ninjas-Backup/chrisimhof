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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(totalWeeks, (weekIdx) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (weekIdx > 0) const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Week Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.mintSoft,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'WEEK ${weekIdx + 1}'.tr,
                          style: getTextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.secondaryButtonColor,
                          ).copyWith(letterSpacing: 1.0),
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

                    final dayName = daysOfWeek[dayIdx];
                    final currentShift = controller.pattern[overallDayIdx];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 82,
                            child: Text(
                              dayName.tr,
                              style: getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTextColor,
                              ),
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
                                              fontSize: abbrev.length > 2 ? 10 : 11,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
