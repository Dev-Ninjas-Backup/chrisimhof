import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/sleep/controller/sleep_controller.dart';
import 'package:chrisimhof/features/dashboard/sleep/model/sleep_log.dart';
import 'package:chrisimhof/features/dashboard/sleep/widgets/sleep_entry_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SleepHistoryList extends StatelessWidget {
  final SleepController controller;

  const SleepHistoryList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'History',
              style: getTextStyle2(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryTextColor,
              ),
            ),
            // GestureDetector(
            //   onTap: () => showSleepEntryDialog(context, controller),
            //   child: Row(
            //     children: [
            //       const Icon(
            //         Icons.add,
            //         color: AppColors.secondaryButtonColor,
            //         size: 16,
            //       ),
            //       const SizedBox(width: 4),
            //       Text(
            //         'Log a past night',
            //         style: getTextStyle(
            //           fontSize: 14,
            //           fontWeight: FontWeight.w600,
            //           color: AppColors.secondaryButtonColor,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 16),

        // List of history logs
        Obx(() {
          final logs = controller.filteredHistoryLogs;
          if (logs.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Text(
                  'No sleep logged for this day.',
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.selectionGray,
                  ),
                ),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return _buildHistoryCard(context, log, controller);
            },
          );
        }),
      ],
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    SleepLog log,
    SleepController controller,
  ) {
    final weekdaysShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekdayStr = weekdaysShort[log.date.weekday - 1];
    final dayStr = log.date.day.toString();

    final bedStr =
        '${log.bedtime.hour.toString().padLeft(2, '0')}:${log.bedtime.minute.toString().padLeft(2, '0')}';
    final wakeStr =
        '${log.wakeupTime.hour.toString().padLeft(2, '0')}:${log.wakeupTime.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 16, 16.02, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.gray100, width: 1),
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
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.sleepHistoryCircle,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.nightlight_round,
                color: AppColors.indigo,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Date & Time details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$weekdayStr $dayStr',
                  style: getTextStyle2(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$bedStr → $wakeStr',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.selectionGray,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                log.durationString,
                style: getTextStyle2(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'quality ${log.quality}',
                style: getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryButtonColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          GestureDetector(
            onTap: () => showSleepEntryDialog(context, controller, log: log),
            child: const Icon(
              Icons.edit_outlined,
              color: AppColors.selectionGray,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
