import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/hydration/controller/hydration_controller.dart';
import 'package:chrisimhof/features/hydration/widgets/hydration_edit_bottom_sheet.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: logs.length,
          separatorBuilder: (context, index) => const Divider(
            height: 1.5,
            color: AppColors.subtle,
          ),
          itemBuilder: (context, index) {
            final log = logs[index];
            final bool canEdit = controller.isSelectedDayToday && !log.id.startsWith('weekly_total');

            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: canEdit
                  ? () => HydrationEditBottomSheet.show(context, controller: controller, log: log)
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Row(
                  children: [
                    // Soft blue circle with water droplet icon
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.blueSoft2.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.water_drop_outlined,
                        color: AppColors.blue2,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Log type and time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            log.type.tr,
                            style: getTextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            log.time,
                            style: getTextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.greyAlt,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Log amount in bold blue
                    Text(
                      '${log.amountMl} ml',
                      style: getTextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue2,
                      ),
                    ),

                    // Pencil edit icon
                    if (canEdit) ...[
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: AppColors.textSoft,
                      ),
                    ],
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
