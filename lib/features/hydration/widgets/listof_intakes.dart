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
            return InkWell(
              onTap: controller.isSelectedDayToday && !log.id.startsWith('weekly_total')
                  ? () => _showEditDeleteDialog(context, log)
                  : null,
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
                    if (controller.isSelectedDayToday && !log.id.startsWith('weekly_total')) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.more_vert_rounded, size: 18, color: AppColors.textSoft),
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

  void _showEditDeleteDialog(BuildContext context, HydrationLog log) {
    final volumeCtrl = TextEditingController(text: '${log.amountMl}');
    DateTime initialDt = DateTime.now();
    if (log.time.contains(':') && !log.time.contains('--')) {
      try {
        final parts = log.time.split(':');
        final h = int.parse(parts[0].trim());
        final m = int.parse(parts[1].trim());
        final now = DateTime.now();
        initialDt = DateTime(now.year, now.month, now.day, h, m);
      } catch (_) {}
    } else if (log.occurredAt != null && log.occurredAt!.isNotEmpty) {
      try {
        initialDt = DateTime.parse(log.occurredAt!);
      } catch (_) {}
    }
    final selectedDate = initialDt.obs;
    final selectedTime = TimeOfDay(hour: initialDt.hour, minute: initialDt.minute).obs;

    Get.dialog(
      Obx(
        () => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Edit Hydration Entry'.tr),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Volume (ml)'.tr,
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSoft,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: volumeCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    suffixText: 'ml',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Date & Time'.tr,
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSoft,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate.value,
                            firstDate: DateTime.now().subtract(const Duration(days: 365)),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            selectedDate.value = picked;
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderSoft),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSoft),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '${selectedDate.value.day}/${selectedDate.value.month}/${selectedDate.value.year}',
                                  style: getTextStyle(
                                    fontSize: 11,
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTime.value,
                          );
                          if (picked != null) {
                            selectedTime.value = picked;
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderSoft),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time_outlined, size: 14, color: AppColors.textSoft),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  selectedTime.value.format(context),
                                  style: getTextStyle(
                                    fontSize: 11,
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                controller.deleteLog(log.id);
              },
              child: Text('Delete'.tr, style: const TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel'.tr),
            ),
            ElevatedButton(
              onPressed: () {
                final vol = int.tryParse(volumeCtrl.text) ?? log.amountMl;
                final d = selectedDate.value;
                final t = selectedTime.value;
                final fullDateTime = DateTime(d.year, d.month, d.day, t.hour, t.minute);
                Get.back();
                controller.editHydrationLog(log.id, vol, occurredAt: fullDateTime);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue2),
              child: Text('Save'.tr, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
