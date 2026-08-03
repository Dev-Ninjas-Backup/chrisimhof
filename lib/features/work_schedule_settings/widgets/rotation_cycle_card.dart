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
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: 2),
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

          // Rotation length row
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
                    const SizedBox(height: 2),
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
              Obx(() {
                final isTemplate =
                    controller.selectedTemplateKey.value.isNotEmpty;
                return Row(
                  children: [
                    _buildCycleAdjustBtn(
                      Icons.remove,
                      () {
                        if (controller.weeks.value > 1) {
                          controller.setWeeks(controller.weeks.value - 1);
                        }
                      },
                      disabled: isTemplate,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Text(
                        '${controller.weeks.value} ${controller.weeks.value == 1 ? 'Week'.tr : 'Weeks'.tr}',
                        style: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isTemplate
                              ? AppColors.textSoft
                              : AppColors.primaryTextColor,
                        ),
                      ),
                    ),
                    _buildCycleAdjustBtn(
                      Icons.add,
                      () {
                        if (controller.weeks.value < 8) {
                          controller.setWeeks(controller.weeks.value + 1);
                        }
                      },
                      disabled: isTemplate,
                    ),
                  ],
                );
              }),
            ],
          ),

          // Dynamic explanation text matching design image 1
          Obx(() {
            final w = controller.weeks.value;
            if (w <= 1) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.mintSoft3,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.mintSoft),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: AppColors.secondaryButtonColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Rotation length = @weeks weeks adds extra week cards automatically — each week keeps its own Monday–Sunday rows.'
                            .trParams({'weeks': w.toString()}),
                        style: getTextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.mintSoftText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCycleAdjustBtn(
    IconData icon,
    VoidCallback onTap, {
    bool disabled = false,
  }) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Opacity(
        opacity: disabled ? 0.4 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.gray50,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderSoft),
          ),
          child: Icon(icon, size: 16, color: AppColors.primaryTextColor),
        ),
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
