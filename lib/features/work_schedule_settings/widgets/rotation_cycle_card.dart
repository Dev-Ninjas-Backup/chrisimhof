import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/work_schedule_settings/controller/work_schedule_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RotationCycleCard extends StatelessWidget {
  final WorkScheduleSettingsController controller;

  const RotationCycleCard({super.key, required this.controller});

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
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Start date picker row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Week 1 Start Date'.tr,
                      style: getTextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    Text(
                      'App aligns rotation week to dates'.tr,
                      style: getTextStyle(
                        fontSize: 12,
                        color: AppColors.textSoft,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                final date = controller.startDate.value;
                final formatted =
                    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
                return OutlinedButton.icon(
                  onPressed: () => _pickStartDate(context),
                  icon: const Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: AppColors.secondaryButtonColor,
                  ),
                  label: Text(
                    formatted,
                    style: getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryButtonColor,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppColors.secondaryButtonColor,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                );
              }),
            ],
          ),
          const Divider(height: 24, color: AppColors.borderSoft),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rotation length'.tr,
                      style: getTextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    Text(
                      'Number of weeks in cycle'.tr,
                      style: getTextStyle(
                        fontSize: 12,
                        color: AppColors.textSoft,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildCycleAdjustBtn(Icons.remove, () {
                    if (controller.weeks.value > 1) {
                      controller.setWeeks(controller.weeks.value - 1);
                    }
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Obx(
                      () => Text(
                        '${controller.weeks.value} ${controller.weeks.value == 1 ? 'Week'.tr : 'Weeks'.tr}',
                        style: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ),
                  ),
                  _buildCycleAdjustBtn(Icons.add, () {
                    if (controller.weeks.value < 8) {
                      controller.setWeeks(controller.weeks.value + 1);
                    }
                  }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCycleAdjustBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.gray50,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Icon(icon, size: 16, color: AppColors.primaryTextColor),
      ),
    );
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
}
