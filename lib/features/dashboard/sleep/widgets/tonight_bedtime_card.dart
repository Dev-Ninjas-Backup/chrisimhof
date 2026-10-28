import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/service/helper/time_format_helper.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/features/dashboard/sleep/controller/sleep_controller.dart';
import 'package:chrisimhof/features/settings/main/controller/settings_controller.dart';
import 'package:chrisimhof/features/work_schedule_settings/controller/work_schedule_settings_controller.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TonightBedtimeCard extends StatelessWidget {
  const TonightBedtimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SleepController>();
    return Obx(() {
      // --- Primary source: live sleep tab data from socket/API ---
      final bedtimeMap = controller.tonightBedtime.value;
      String? apiSleepStart = (bedtimeMap?['sleepStart'] ?? bedtimeMap?['time']) as String?;
      String? apiWakeTime   = (bedtimeMap?['wakeTime'] ?? bedtimeMap?['sleepEnd']) as String?;
      final apiNote         = controller.tonightNote.value;

      final isFr = (Get.locale?.languageCode ?? 'fr') == 'fr';

      // --- Target sleep duration ---
      int targetMinutes = 465;
      if (Get.isRegistered<SettingsController>()) {
        final st = Get.find<SettingsController>().sleepTargetMinutes.value;
        if (st > 0) targetMinutes = st;
      }
      final targetHours = targetMinutes ~/ 60;
      final targetMins = targetMinutes % 60;
      final targetDuration = isFr
          ? (targetMins == 0 ? '$targetHours h' : '$targetHours h $targetMins min')
          : (targetMins == 0 ? '${targetHours}h' : '${targetHours}h ${targetMins}m');

      // --- Next shift start time & morning shift detection ---
      String nextShiftTime = '';
      bool isMorningShift = false;
      int shiftStartH = -1;
      int shiftStartM = 0;

      // Priority 1: Direct backend session nextShiftStart
      final rawNextShift = bedtimeMap?['nextShiftStart']?.toString();
      if (rawNextShift != null && rawNextShift.contains(':')) {
        nextShiftTime = rawNextShift;
      }

      // Priority 2: Work rotation calendar schedule (Check next upcoming non-off shift)
      if (nextShiftTime.isEmpty && Get.isRegistered<WorkScheduleSettingsController>()) {
        final wssc = Get.find<WorkScheduleSettingsController>();
        if (wssc.isEnabled.value && (wssc.hasRotationData.value || wssc.upcomingScheduleDays.isNotEmpty)) {
          final now = DateTime.now();
          if (wssc.upcomingScheduleDays.isNotEmpty) {
            final nextDay = wssc.upcomingScheduleDays.firstWhereOrNull((d) {
              final type = d.shiftType.toLowerCase();
              return type != 'off' && type != 'repos' && type != 'vacation' && d.shiftStartTime.isNotEmpty;
            });
            if (nextDay != null) {
              nextShiftTime = nextDay.shiftStartTime;
            }
          }
          if (nextShiftTime.isEmpty) {
            for (int i = 0; i < 7; i++) {
              final checkDate = now.add(Duration(days: i));
              final shiftCode = wssc.getShiftForDate(checkDate).trim().toLowerCase();
              if (shiftCode.isNotEmpty && shiftCode != 'off' && shiftCode != 'repos' && shiftCode != 'vacation') {
                final matchKey = wssc.shiftTimes.keys.firstWhereOrNull(
                  (k) =>
                      k.toLowerCase() == shiftCode ||
                      k.toLowerCase().replaceAll(RegExp(r'[\s_]+'), '') ==
                          shiftCode.replaceAll(RegExp(r'[\s_]+'), ''),
                );
                if (matchKey != null && wssc.shiftTimes[matchKey] != null) {
                  final s = wssc.shiftTimes[matchKey]!['start'] ?? '';
                  if (s.isNotEmpty && s != '00:00') {
                    nextShiftTime = s;
                    break;
                  }
                }
              }
            }
          }
        }
      }

      // Priority 3: Dashboard active shift countdown if active today
      if (nextShiftTime.isEmpty && Get.isRegistered<DashboardController>()) {
        final dc = Get.find<DashboardController>();
        final parts = dc.dashboardData.value.workShiftCountdown.split('—');
        if (parts.isNotEmpty && parts.first.trim().contains(':')) {
          nextShiftTime = parts.first.trim();
        }
      }

      // Parse shift start hours & morning shift flag
      if (nextShiftTime.isNotEmpty) {
        final tParts = nextShiftTime.split(':');
        if (tParts.length == 2) {
          shiftStartH = int.tryParse(tParts[0]) ?? -1;
          shiftStartM = int.tryParse(tParts[1]) ?? 0;
          if (shiftStartH >= 4 && shiftStartH <= 10) {
            isMorningShift = true;
          }
        }
      }

      // Morning-shift fallback (only if backend nextSleepWindow has not already provided sleepStart/wakeTime)
      final bool hasBackendSleepWindow =
          apiSleepStart != null &&
          apiSleepStart.isNotEmpty &&
          apiSleepStart != '--:--' &&
          apiWakeTime != null &&
          apiWakeTime.isNotEmpty &&
          apiWakeTime != '--:--';

      if (!hasBackendSleepWindow && isMorningShift && shiftStartH >= 0) {
        final shiftTotalMinutes = shiftStartH * 60 + shiftStartM;
        final wakeTotalMinutes = (shiftTotalMinutes - 90 + 1440) % 1440;
        final bedTotalMinutes = (wakeTotalMinutes - targetMinutes + 1440) % 1440;

        final calcWake =
            '${(wakeTotalMinutes ~/ 60).toString().padLeft(2, '0')}:${(wakeTotalMinutes % 60).toString().padLeft(2, '0')}';
        final calcBed =
            '${(bedTotalMinutes ~/ 60).toString().padLeft(2, '0')}:${(bedTotalMinutes % 60).toString().padLeft(2, '0')}';

        apiWakeTime = calcWake;
        apiSleepStart = calcBed;
      }

      // Fallback to shift-aware optimal bedtime from DashboardController if not yet in map
      if (apiSleepStart == null || apiSleepStart.isEmpty || apiSleepStart == '--:--') {
        if (Get.isRegistered<DashboardController>()) {
          final optimal = Get.find<DashboardController>().dashboardData.value.optimalBedtime;
          if (optimal.isNotEmpty && optimal != '--:--') {
            apiSleepStart = optimal;
          }
        }
      }

      // Fallback to controller's calculated/parsed wakeup time if wakeTime not in map
      if (apiWakeTime == null || apiWakeTime.isEmpty || apiWakeTime == '--:--') {
        if (controller.wakeupHour.value != 0 || controller.wakeupMinute.value != 0) {
          apiWakeTime =
              '${controller.wakeupHour.value.toString().padLeft(2, '0')}:${controller.wakeupMinute.value.toString().padLeft(2, '0')}';
        }
      }

      int bufferMinutes = 0;
      if (bedtimeMap?['bedtimeBufferMinutes'] != null) {
        bufferMinutes = (bedtimeMap!['bedtimeBufferMinutes'] as num).toInt();
      } else if (Get.isRegistered<DashboardController>()) {
        bufferMinutes = Get.find<DashboardController>().dashboardData.value.bedtimeBufferMinutes;
      }

      final String bedtime = TimeFormatHelper.formatBedtime(apiSleepStart ?? '--:--');
      final String wakeup  = apiWakeTime  ?? '--:--';

      // Explanatory note text
      String noteText;
      if (nextShiftTime.isNotEmpty) {
        final formattedShift = TimeFormatHelper.formatTime(nextShiftTime);
        noteText = isFr
            ? 'Adaptée à votre prochain shift à $formattedShift. Objectif : $targetDuration pour favoriser votre récupération avant le travail.'
            : 'Adapted to your next shift at $formattedShift. Target: $targetDuration to promote your recovery before work.';
      } else if (apiNote != null && apiNote.isNotEmpty) {
        noteText = apiNote.tr;
      } else {
        noteText = isFr
            ? 'Objectif : $targetDuration pour favoriser votre récupération.'
            : 'Target: $targetDuration to promote your recovery.';
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.white, width: 1),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.blueSoft, AppColors.mintSoft2],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 1),
              blurRadius: 2,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.auto_awesome_outlined,
                  color: AppColors.indigo,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Recommended sleep window'.tr,
                        style: getTextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.indigo,
                        ).copyWith(letterSpacing: 1.1),
                      ),
                      if (bufferMinutes > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.amberSoft3,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.amberDark.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.coffee_outlined, size: 10, color: AppColors.amberDark),
                              const SizedBox(width: 3),
                              Text(
                                '+$bufferMinutes m ${'caffeine delay'.tr}',
                                style: getTextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.amberDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        bedtime,
                        style: getTextStyle2(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.arrow_right_alt_rounded,
                        color: AppColors.selectionGray,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        wakeup,
                        style: getTextStyle2(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    noteText,
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

