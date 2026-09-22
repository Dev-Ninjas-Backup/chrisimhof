import 'package:chrisimhof/core/common/widgets/custom_switch.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/work_schedule_settings/controller/work_schedule_settings_controller.dart';
import 'package:chrisimhof/features/work_schedule_settings/model/work_rotation_preset_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RotationListCard extends StatelessWidget {
  final WorkScheduleSettingsController controller;

  const RotationListCard({super.key, required this.controller});

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
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rotations & Templates'.tr,
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Toggle which rotation is currently active'.tr,
                      style: getTextStyle(
                        fontSize: 12,
                        color: AppColors.textSoft,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                final isCreating = controller.isCreatingNewRotation.value;
                return InkWell(
                  onTap: () {
                    if (isCreating) {
                      controller.cancelNewRotation();
                    } else {
                      controller.startNewRotation();
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isCreating ? AppColors.gray100 : AppColors.mintSoft,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isCreating
                            ? AppColors.borderSoft
                            : AppColors.secondaryButtonColor,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isCreating
                              ? Icons.close_rounded
                              : Icons.add_rounded,
                          size: 16,
                          color: isCreating
                              ? AppColors.textSoft
                              : AppColors.secondaryButtonColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isCreating ? 'Cancel'.tr : 'New'.tr,
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isCreating
                                ? AppColors.textSoft
                                : AppColors.secondaryButtonColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 16),

          // Presets list
          Obx(() {
            if (controller.isLoadingPresets.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.secondaryButtonColor,
                  ),
                ),
              );
            }

            final presets = controller.apiPresets;
            if (presets.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    'No rotations available'.tr,
                    style: getTextStyle(
                      fontSize: 14,
                      color: AppColors.textSoft,
                    ),
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: presets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, index) {
                final tmpl = presets[index];
                return _buildRotationItem(context, tmpl);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRotationItem(
    BuildContext context,
    WorkRotationPresetModel tmpl,
  ) {
    return Obx(() {
      final activeKey = controller.activeRotationKey.value;
      final currentRotationName = controller.rotationName.value;

      final bool isActive = (activeKey.isNotEmpty && activeKey == tmpl.key) ||
          (activeKey.isEmpty &&
              currentRotationName.isNotEmpty &&
              tmpl.label.toLowerCase() == currentRotationName.toLowerCase());

      return InkWell(
        onTap: () {
          if (!isActive) {
            controller.activateRotation(tmpl);
          }
        },
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.mintSoft3 : AppColors.gray50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive
                  ? AppColors.secondaryButtonColor
                  : AppColors.borderSoft,
              width: isActive ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon or left indicator
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.white : AppColors.gray200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    isActive
                        ? Icons.check_circle_rounded
                        : Icons.calendar_today_rounded,
                    size: 18,
                    color: isActive
                        ? AppColors.secondaryButtonColor
                        : AppColors.textSoft,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title and badges
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            tmpl.label.tr,
                            style: getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (tmpl.isCustom)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF), // soft blue
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Custom'.tr,
                              style: getTextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gray200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${tmpl.cycleWeeks} ${tmpl.cycleWeeks == 1 ? 'wk'.tr : 'wks'.tr}',
                            style: getTextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSoft,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (tmpl.description.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        tmpl.description.tr,
                        style: getTextStyle(
                          fontSize: 12,
                          color: AppColors.textSoft,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Delete button for custom templates
              if (tmpl.isCustom && tmpl.id != null && tmpl.id!.isNotEmpty)
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: AppColors.red,
                  ),
                  onPressed: () => _confirmDelete(context, tmpl),
                  tooltip: 'Delete template'.tr,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),

              // Active Toggle Switch
              CustomSwitch(
                value: isActive,
                onChanged: (val) {
                  if (val && !isActive) {
                    controller.activateRotation(tmpl);
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  void _confirmDelete(BuildContext context, WorkRotationPresetModel tmpl) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Delete Template'.tr,
          style: getTextStyle2(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to delete this custom template?'.tr,
          style: getTextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel'.tr,
              style: getTextStyle(color: AppColors.textSoft),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              controller.deleteCustomTemplate(tmpl);
            },
            child: Text(
              'Delete'.tr,
              style: getTextStyle(
                color: AppColors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
