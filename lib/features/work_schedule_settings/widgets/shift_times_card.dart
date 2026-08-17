import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/work_schedule_settings/controller/work_schedule_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ShiftTimesCard extends StatelessWidget {
  final WorkScheduleSettingsController controller;

  const ShiftTimesCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      clipBehavior: Clip.antiAlias,
      child: Obx(() {
        final isEditable = !controller.hasRotationData.value;
        final isCustom = controller.selectedTemplateKey.value.isEmpty;
        final shiftKeys = controller.shiftTimes.keys.toList();

        return Column(
          children: [
            ...List.generate(shiftKeys.length, (idx) {
              final key = shiftKeys[idx];
              final times = controller.shiftTimes[key] ?? {'start': '00:00', 'end': '00:00'};
              final isLast = idx == shiftKeys.length - 1;

              final lower = key.toLowerCase();
              IconData icon;
              Color color;
              Color bgColor;
              String? iconPath;

              if (lower == 'day') {
                icon = Icons.wb_sunny_rounded;
                color = AppColors.amber;
                bgColor = AppColors.amberSoft3.withValues(alpha: 0.4);
              } else if (lower == 'evening') {
                icon = Icons.auto_awesome_rounded;
                color = AppColors.violet;
                bgColor = AppColors.lavenderSoft;
              } else if (lower == 'night') {
                icon = Icons.nightlight_round;
                iconPath = IconPath.sleep;
                color = AppColors.indigo;
                bgColor = AppColors.indigoSoft;
              } else {
                icon = Icons.work_rounded;
                color = AppColors.secondaryButtonColor;
                bgColor = AppColors.mintSoft;
              }

              return _buildShiftTimeRow(
                context,
                title: controller.formatShiftName(key),
                icon: iconPath != null ? null : icon,
                iconPath: iconPath,
                color: color,
                bgColor: bgColor,
                start: times['start']!,
                end: times['end']!,
                shiftName: key,
                showDivider: !isLast || (isCustom && isEditable),
                isCustom: isCustom && isEditable,
                isEditable: isEditable,
              );
            }),
            if (isCustom && isEditable) _buildAddShiftButton(context),
          ],
        );
      }),
    );
  }

  Widget _buildShiftTimeRow(
    BuildContext context, {
    required String title,
    required IconData? icon,
    required String? iconPath,
    required Color color,
    required Color bgColor,
    required String start,
    required String end,
    required String shiftName,
    required bool showDivider,
    required bool isCustom,
    required bool isEditable,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.borderSoft))
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: iconPath != null
                ? Image.asset(iconPath, color: color, width: 18, height: 18)
                : Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: (isCustom && isEditable) ? () => _editShiftName(context, shiftName) : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: getTextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                if (isCustom && isEditable) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.edit_rounded,
                    size: 13,
                    color: AppColors.textSoft,
                  ),
                ],
              ],
            ),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: isEditable ? () => _pickTime(context, shiftName, 'start') : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderSoft),
                  ),
                  child: Text(
                    start,
                    style: getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isEditable ? AppColors.primaryTextColor : AppColors.textSoft,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Text(
                  '–',
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSoft,
                  ),
                ),
              ),
              GestureDetector(
                onTap: isEditable ? () => _pickTime(context, shiftName, 'end') : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderSoft),
                  ),
                  child: Text(
                    end,
                    style: getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isEditable ? AppColors.primaryTextColor : AppColors.textSoft,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (isCustom && isEditable) ...[
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => _deleteShift(context, shiftName),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.red,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddShiftButton(BuildContext context) {
    return InkWell(
      onTap: () => _showAddShiftDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_rounded,
              color: AppColors.secondaryButtonColor,
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              'Add custom shift'.tr,
              style: getTextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.secondaryButtonColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddShiftDialog(BuildContext context) {
    final nameController = TextEditingController();
    String start = '08:00';
    String end = '16:00';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                'Add Custom Shift'.tr,
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SHIFT NAME'.tr,
                    style: getTextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSoft,
                    ).copyWith(letterSpacing: 1.1),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    style: getTextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. Morning 12h'.tr,
                      hintStyle: getTextStyle(
                        fontSize: 14,
                        color: AppColors.textSoft.withValues(alpha: 0.5),
                      ),
                      filled: true,
                      fillColor: AppColors.gray50,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.borderSoft, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.secondaryButtonColor, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'SHIFT TIMES'.tr,
                    style: getTextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSoft,
                    ).copyWith(letterSpacing: 1.1),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await _pickCustomTime(context, start);
                            if (picked != null) {
                              setState(() {
                                start = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.gray50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.borderSoft, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 16,
                                  color: AppColors.secondaryButtonColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  start,
                                  style: getTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'to'.tr,
                          style: getTextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSoft,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await _pickCustomTime(context, end);
                            if (picked != null) {
                              setState(() {
                                end = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.gray50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.borderSoft, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 16,
                                  color: AppColors.secondaryButtonColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  end,
                                  style: getTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel'.tr,
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSoft,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final enteredName = nameController.text.trim();
                    if (enteredName.isEmpty) {
                      EasyLoading.showError('Shift name cannot be empty'.tr);
                      return;
                    }
                    if (enteredName.toLowerCase() == 'off') {
                      EasyLoading.showError('"Off" is a reserved shift name'.tr);
                      return;
                    }
                    final duplicate = controller.shiftTimes.keys.any(
                      (k) => k.toLowerCase() == enteredName.toLowerCase(),
                    );
                    if (duplicate) {
                      EasyLoading.showError('A shift with this name already exists'.tr);
                      return;
                    }
                    controller.addCustomShift(enteredName, start, end);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryButtonColor,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Add'.tr,
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _editShiftName(BuildContext context, String oldKey) {
    final nameController = TextEditingController(text: controller.formatShiftName(oldKey));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Rename Shift'.tr,
            style: getTextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SHIFT NAME'.tr,
                style: getTextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSoft,
                ).copyWith(letterSpacing: 1.1),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                style: getTextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.gray50,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderSoft, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.secondaryButtonColor, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel'.tr,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSoft,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final enteredName = nameController.text.trim();
                if (enteredName.isEmpty) {
                  EasyLoading.showError('Shift name cannot be empty'.tr);
                  return;
                }
                if (enteredName.toLowerCase() == 'off') {
                  EasyLoading.showError('"Off" is a reserved shift name'.tr);
                  return;
                }

                final oldNameFormatted = controller.formatShiftName(oldKey);
                if (enteredName.toLowerCase() != oldKey.toLowerCase() &&
                    enteredName.toLowerCase() != oldNameFormatted.toLowerCase()) {
                  final duplicate = controller.shiftTimes.keys.any(
                    (k) => k.toLowerCase() == enteredName.toLowerCase(),
                  );
                  if (duplicate) {
                    EasyLoading.showError('A shift with this name already exists'.tr);
                    return;
                  }
                }

                controller.renameCustomShift(oldKey, enteredName);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryButtonColor,
                foregroundColor: AppColors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Save'.tr,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteShift(BuildContext context, String key) {
    if (controller.shiftTimes.length <= 1) {
      EasyLoading.showError('You must keep at least one shift'.tr);
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Delete Shift'.tr,
            style: getTextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this shift? Any days in your pattern assigned to this shift will revert to "Off".'.tr,
            style: getTextStyle(
              fontSize: 14,
              color: AppColors.secondaryTextColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel'.tr,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSoft,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                controller.deleteCustomShift(key);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: AppColors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Delete'.tr,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _pickCustomTime(BuildContext context, String currentStr) async {
    final parts = currentStr.split(':');
    final initialHour = parts.length == 2 ? (int.tryParse(parts[0]) ?? 8) : 8;
    final initialMinute = parts.length == 2 ? (int.tryParse(parts[1]) ?? 0) : 0;

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
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
      final hourStr = picked.hour.toString().padLeft(2, '0');
      final minuteStr = picked.minute.toString().padLeft(2, '0');
      return '$hourStr:$minuteStr';
    }
    return null;
  }

  Future<void> _pickTime(
    BuildContext context,
    String shift,
    String type,
  ) async {
    final currentStr = controller.shiftTimes[shift]?[type] ?? '00:00';
    final parts = currentStr.split(':');
    final initialHour = parts.length == 2 ? (int.tryParse(parts[0]) ?? 0) : 0;
    final initialMinute = parts.length == 2 ? (int.tryParse(parts[1]) ?? 0) : 0;

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
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
      final hourStr = picked.hour.toString().padLeft(2, '0');
      final minuteStr = picked.minute.toString().padLeft(2, '0');

      final updatedTimes = Map<String, Map<String, String>>.from(
        controller.shiftTimes,
      );
      updatedTimes[shift]![type] = '$hourStr:$minuteStr';
      controller.shiftTimes.assignAll(updatedTimes);
    }
  }
}
