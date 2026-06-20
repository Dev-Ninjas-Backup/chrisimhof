import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/hydration/controller/hydration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListofIntakes extends StatelessWidget {
  const ListofIntakes({super.key, required this.controller});

  final HydrationController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final logs = controller.selectedDayDisplayLogs;

      if (logs.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 30),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.subtle, width: 1.5),
          ),
          child: Center(
            child: Text(
              'No intake logged yet.'.tr,
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSoft,
              ),
            ),
          ),
        );
      }

      return Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.subtle, width: 1.5),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          itemCount: logs.length,
          separatorBuilder: (context, index) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Divider(height: 1.5, color: AppColors.subtle),
          ),
          itemBuilder: (context, index) {
            final log = logs[index];
            return Dismissible(
              key: Key(log.id),
              direction: controller.isSelectedDayToday
                  ? DismissDirection.endToStart
                  : DismissDirection.none,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.delete_outline, color: AppColors.red),
              ),
              onDismissed: (_) => controller.deleteLog(log.id),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    // Time
                    Text(
                      log.time,
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.greyAlt,
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Blue bullet dot
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.blue2,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Log type/name
                    Text(
                      log.type.tr,
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    const Spacer(),
                    // Log amount
                    Text(
                      '${log.amountMl} ml',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.blue2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
