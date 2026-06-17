import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/sleep/controller/sleep_controller.dart';
import 'package:chrisimhof/features/dashboard/sleep/model/sleep_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SleepEntryDialog extends StatelessWidget {
  final SleepLog? log;
  final SleepController controller;

  late final Rx<DateTime> selectedDate;
  late final Rx<TimeOfDay> selectedBedtime;
  late final Rx<TimeOfDay> selectedWakeup;
  late final RxInt selectedQuality;

  SleepEntryDialog({super.key, this.log, required this.controller}) {
    selectedDate = (log?.date ?? DateTime.now()).obs;
    selectedBedtime = (log?.bedtime ?? const TimeOfDay(hour: 23, minute: 8)).obs;
    selectedWakeup = (log?.wakeupTime ?? const TimeOfDay(hour: 5, minute: 50)).obs;
    selectedQuality = (log?.quality ?? 85).obs;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                log == null ? 'Log Sleep' : 'Edit Sleep Log',
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryTextColor,
                ),
              ),
              const SizedBox(height: 20),

              // Date Selector
              Text(
                'DATE',
                style: getTextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSoft,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate.value,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    selectedDate.value = date;
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.subtle,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        final date = selectedDate.value;
                        final weekdaysShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        final monthsShort = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                        return Text(
                          '${weekdaysShort[date.weekday - 1]}, ${date.day} ${monthsShort[date.month - 1]}',
                          style: getTextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextColor,
                          ),
                        );
                      }),
                      const Icon(
                        Icons.calendar_today_rounded,
                        color: AppColors.indigo,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Bedtime Selector
              Text(
                'BEDTIME',
                style: getTextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSoft,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedBedtime.value,
                  );
                  if (time != null) {
                    selectedBedtime.value = time;
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.subtle,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        final time = selectedBedtime.value;
                        return Text(
                          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                          style: getTextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextColor,
                          ),
                        );
                      }),
                      const Icon(
                        Icons.nightlight_round,
                        color: AppColors.indigo,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Wakeup Selector
              Text(
                'WAKE-UP TIME',
                style: getTextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSoft,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedWakeup.value,
                  );
                  if (time != null) {
                    selectedWakeup.value = time;
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.subtle,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        final time = selectedWakeup.value;
                        return Text(
                          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                          style: getTextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextColor,
                          ),
                        );
                      }),
                      const Icon(
                        Icons.wb_sunny_rounded,
                        color: AppColors.indigo,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Quality Score Slider
              Text(
                'SLEEP QUALITY',
                style: getTextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSoft,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppColors.primaryButtonColor,
                      inactiveTrackColor: AppColors.subtle,
                      thumbColor: AppColors.primaryButtonColor,
                      overlayColor: AppColors.primaryButtonColor.withValues(alpha: 0.2),
                      valueIndicatorColor: AppColors.primaryButtonColor,
                      valueIndicatorTextStyle: getTextStyle(color: AppColors.white),
                    ),
                    child: Slider(
                      value: selectedQuality.value.toDouble(),
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: '${selectedQuality.value}%',
                      onChanged: (val) {
                        selectedQuality.value = val.toInt();
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${selectedQuality.value}%',
                      style: getTextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryButtonColor,
                      ),
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 24),

              // Action Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (log != null) ...[
                    GestureDetector(
                      onTap: () {
                        controller.deleteLog(log!.id);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.roseSoft2,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.rose.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          'Delete',
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.red,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        'Cancel',
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSoft,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (log == null) {
                        controller.addSleepLog(
                          date: selectedDate.value,
                          bedtime: selectedBedtime.value,
                          wakeupTime: selectedWakeup.value,
                          quality: selectedQuality.value,
                        );
                      } else {
                        controller.updateSleepLog(
                          id: log!.id,
                          date: selectedDate.value,
                          bedtime: selectedBedtime.value,
                          wakeupTime: selectedWakeup.value,
                          quality: selectedQuality.value,
                        );
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTextColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        log == null ? 'Add' : 'Save',
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showSleepEntryDialog(
  BuildContext context,
  SleepController controller, {
  SleepLog? log,
}) {
  showDialog(
    context: context,
    builder: (context) => SleepEntryDialog(log: log, controller: controller),
  );
}
