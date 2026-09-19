import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/hydration/controller/hydration_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HydrationEditBottomSheet extends StatelessWidget {
  final HydrationController controller;
  final HydrationLog? log;

  const HydrationEditBottomSheet({
    super.key,
    required this.controller,
    this.log,
  });

  bool get isEdit => log != null;

  static Future<void> show(
    BuildContext context, {
    required HydrationController controller,
    HydrationLog? log,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HydrationEditBottomSheet(
        controller: controller,
        log: log,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime initialDt = DateTime.now();
    if (log != null) {
      if (log!.time.contains(':') && !log!.time.contains('--')) {
        try {
          final parts = log!.time.split(':');
          final h = int.parse(parts[0].trim());
          final m = int.parse(parts[1].trim());
          final now = DateTime.now();
          initialDt = DateTime(now.year, now.month, now.day, h, m);
        } catch (_) {}
      } else if (log!.occurredAt != null && log!.occurredAt!.isNotEmpty) {
        try {
          initialDt = DateTime.parse(log!.occurredAt!).toLocal();
        } catch (_) {}
      }
    }

    final initialAmount = log?.amountMl ?? 500;
    final currentVolume = initialAmount.obs;
    final textController = TextEditingController(text: '$initialAmount');
    final selectedDate = initialDt.obs;
    final selectedTime = TimeOfDay(hour: initialDt.hour, minute: initialDt.minute).obs;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? MediaQuery.of(context).viewInsets.bottom + 20
            : MediaQuery.of(context).padding.bottom + 36,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Drag Handle
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header Row: Soft Water Icon + Tag & Title + Close Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.blueSoft2,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.water_drop_outlined,
                    color: AppColors.blue2,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'HYDRATATION',
                        style: getTextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSoft,
                        ).copyWith(letterSpacing: 0.8),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isEdit ? 'Modifier la quantité'.tr : 'Custom'.tr,
                        style: getTextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.gray100Alt2,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Section 1: Volume d'eau / Water volume
            Text(
              'Water volume'.tr,
              style: getTextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),

            // Stepper Container: (-) Editable Center (+)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F8FE),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.blueSoft2, width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Minus Button (-50 ml)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (currentVolume.value > 50) {
                        currentVolume.value = (currentVolume.value - 50).clamp(50, 5000);
                        textController.text = currentVolume.value.toString();
                        textController.selection = TextSelection.fromPosition(
                          TextPosition(offset: textController.text.length),
                        );
                      }
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.blue2.withValues(alpha: 0.35),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.remove_rounded,
                        color: AppColors.blue2,
                        size: 24,
                      ),
                    ),
                  ),

                  // Center directly editable quantity
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        IntrinsicWidth(
                          child: TextField(
                            controller: textController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            textAlign: TextAlign.center,
                            style: getTextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryTextColor,
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                              border: InputBorder.none,
                            ),
                            onChanged: (val) {
                              final parsed = int.tryParse(val);
                              if (parsed != null && parsed > 0) {
                                currentVolume.value = parsed;
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'ml',
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Plus Button (+50 ml)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      currentVolume.value = (currentVolume.value + 50).clamp(50, 5000);
                      textController.text = currentVolume.value.toString();
                      textController.selection = TextSelection.fromPosition(
                        TextPosition(offset: textController.text.length),
                      );
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.blue2,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Preset Pills: [ 250 ml ] [ 500 ml ] [ 750 ml ] [ 1 000 ml ]
            Obx(() {
              final vol = currentVolume.value;
              return Row(
                children: [250, 500, 750, 1000].map((preset) {
                  final isSelected = vol == preset;
                  final label = preset == 1000 ? '1 000 ml' : '$preset ml';
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        currentVolume.value = preset;
                        textController.text = preset.toString();
                        textController.selection = TextSelection.fromPosition(
                          TextPosition(offset: textController.text.length),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.blueSoft2 : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? AppColors.blue2 : AppColors.borderColor,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          label,
                          style: getTextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected ? AppColors.blue2 : AppColors.primaryTextColor,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 24),

            // Section 2: Date et heure / Date and time
            Text(
              'Date and time'.tr,
              style: getTextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),

            Obx(
              () => Row(
                children: [
                  // Date Picker Box
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate.value,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.blue2,
                                  onPrimary: Colors.white,
                                  onSurface: AppColors.primaryTextColor,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          selectedDate.value = picked;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderColor, width: 1.2),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                              color: AppColors.textSoft,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                DateFormat('d MMM yyyy', Get.locale?.toString()).format(selectedDate.value),
                                style: getTextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Time Picker Box
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime.value,
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.blue2,
                                  onPrimary: Colors.white,
                                  onSurface: AppColors.primaryTextColor,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          selectedTime.value = picked;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderColor, width: 1.2),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time_outlined,
                              size: 18,
                              color: AppColors.textSoft,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${selectedTime.value.hour.toString().padLeft(2, '0')}:${selectedTime.value.minute.toString().padLeft(2, '0')}',
                                style: getTextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Action Buttons: [ Annuler ]  [ Enregistrer ]
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderColor, width: 1.2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Cancel'.tr,
                        style: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      final vol = int.tryParse(textController.text) ?? currentVolume.value;
                      if (vol <= 0) return;
                      final d = selectedDate.value;
                      final t = selectedTime.value;
                      final fullDateTime = DateTime(d.year, d.month, d.day, t.hour, t.minute);
                      Navigator.of(context).pop();

                      if (isEdit && log != null) {
                        controller.editHydrationLog(log!.id, vol, occurredAt: fullDateTime);
                      } else {
                        controller.addCustomIntake(vol, occurredAt: fullDateTime);
                      }
                    },
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.blue2,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Save'.tr,
                        style: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Delete entry action (shown only when editing an existing entry)
            if (isEdit && log != null && !log!.id.startsWith('weekly_total')) ...[
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.deleteLog(log!.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Delete entry'.tr,
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ] else ...[
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
