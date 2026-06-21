import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/caffeine/controller/caffeine_controller.dart';
import 'package:chrisimhof/features/dashboard/caffeine/model/caffeine_entry.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CaffeineEntryDialog extends StatelessWidget {
  final CaffeineEntry? entry;
  final CaffeineController controller;

  late final TextEditingController titleCtrl;
  late final TextEditingController amountCtrl;
  late final Rx<DateTime> selectedTime;

  CaffeineEntryDialog({super.key, this.entry, required this.controller}) {
    titleCtrl = TextEditingController(text: entry?.title ?? 'Coffee');
    amountCtrl = TextEditingController(
      text: entry?.amountMg.toString() ?? '80',
    );
    selectedTime = (entry?.timestamp ?? DateTime.now()).obs;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              entry == null ? 'Add Caffeine'.tr : 'Edit Entry'.tr,
              style: getTextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'DRINK NAME'.tr,
              style: getTextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.textSoft,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: titleCtrl,
              style: getTextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. Espresso, Coffee, Tea'.tr,
                hintStyle: getTextStyle(
                  color: AppColors.textSoft.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: AppColors.subtle,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.caffeineTextDark,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'AMOUNT (MG)'.tr,
              style: getTextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.textSoft,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              style: getTextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. 80',
                hintStyle: getTextStyle(
                  color: AppColors.textSoft.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: AppColors.subtle,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.caffeineTextDark,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Time Selector Row
            Text(
              'TIME'.tr,
              style: getTextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.textSoft,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final timeOfDay = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(selectedTime.value),
                );
                if (timeOfDay != null) {
                  final now = DateTime.now();
                  selectedTime.value = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    timeOfDay.hour,
                    timeOfDay.minute,
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.subtle,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      final time = selectedTime.value;
                      final hr = time.hour.toString().padLeft(2, '0');
                      final min = time.minute.toString().padLeft(2, '0');
                      return Text(
                        '$hr:$min',
                        style: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
                        ),
                      );
                    }),
                    const Icon(
                      Icons.access_time_rounded,
                      color: AppColors.caffeineTextDark,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (entry != null) ...[
                  GestureDetector(
                    onTap: () {
                      controller.deleteCaffeineEntry(entry!.id);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.roseSoft2,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.rose.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        'Delete',
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.red,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      'Cancel',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSoft,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    final title = titleCtrl.text.trim();
                    final amount = int.tryParse(amountCtrl.text.trim()) ?? 0;
                    if (title.isNotEmpty && amount > 0) {
                      if (entry == null) {
                        controller.addCaffeineEntry(
                          title,
                          amount,
                          selectedTime.value,
                        );
                      } else {
                        controller.editCaffeineEntry(
                          entry!.id,
                          title,
                          amount,
                          selectedTime.value,
                        );
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTextColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      entry == null ? 'Add' : 'Save',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showCaffeineEntryDialog(
  BuildContext context,
  CaffeineController controller, {
  CaffeineEntry? entry,
}) {
  showDialog(
    context: context,
    builder: (context) =>
        CaffeineEntryDialog(entry: entry, controller: controller),
  );
}
