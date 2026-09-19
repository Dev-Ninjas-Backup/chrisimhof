import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/caffeine/controller/caffeine_controller.dart';
import 'package:chrisimhof/features/dashboard/caffeine/model/caffeine_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddCaffeineBottomSheet extends StatelessWidget {
  final CaffeineController controller;
  final CaffeineEntry? entry;

  const AddCaffeineBottomSheet({
    super.key,
    required this.controller,
    this.entry,
  });

  bool get isEdit => entry != null;

  static Future<void> show(
    BuildContext context, {
    required CaffeineController controller,
    CaffeineEntry? entry,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddCaffeineBottomSheet(
        controller: controller,
        entry: entry,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime initialDt = entry?.timestamp ?? DateTime.now();
    final initialAmount = entry?.amountMg ?? 80;
    final currentAmount = initialAmount.obs;

    final titleController = TextEditingController(
      text: entry != null ? entry!.title.tr : 'Custom'.tr,
    );
    final amountController = TextEditingController(text: '$initialAmount');
    final selectedDate = initialDt.obs;
    final selectedTime =
        TimeOfDay(hour: initialDt.hour, minute: initialDt.minute).obs;

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

            // Header Row: Soft Coffee Badge + Category/Title + Close Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.coffee_outlined,
                      color: Color(0xFF9A3412),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'CAFÉINE',
                        style: getTextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSoft,
                        ).copyWith(letterSpacing: 0.8),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isEdit ? 'Modifier la caféine'.tr : 'Ajouter de la caféine'.tr,
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

            // Section 1: Nom de la boisson / Drink name
            Text(
              'Nom de la boisson'.tr,
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderColor, width: 1.2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: titleController,
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        border: InputBorder.none,
                        hintText: 'Nom de la boisson'.tr,
                        hintStyle: getTextStyle(
                          color: AppColors.textSoft.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.edit_outlined,
                    color: AppColors.textSoft,
                    size: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Section 2: Quantité de caféine / Caffeine amount
            Text(
              'Quantité de caféine'.tr,
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 10),

            // Stepper Container: (-) Editable Center (+) (10 mg increments)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFFED7AA),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Minus Button (-10 mg)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (currentAmount.value > 0) {
                        currentAmount.value =
                            (currentAmount.value - 10).clamp(0, 1000);
                        amountController.text = currentAmount.value.toString();
                        amountController.selection = TextSelection.fromPosition(
                          TextPosition(offset: amountController.text.length),
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
                          color: const Color(0xFFFED7AA),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.remove_rounded,
                        color: Color(0xFF9A3412),
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
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textAlign: TextAlign.center,
                            style: getTextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryTextColor,
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 2,
                                vertical: 2,
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (val) {
                              final parsed = int.tryParse(val);
                              if (parsed != null) {
                                currentAmount.value = parsed;
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'mg',
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSoft,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Plus Button (+10 mg)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      currentAmount.value =
                          (currentAmount.value + 10).clamp(0, 1000);
                      amountController.text = currentAmount.value.toString();
                      amountController.selection = TextSelection.fromPosition(
                        TextPosition(offset: amountController.text.length),
                      );
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFED7AA),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Color(0xFF9A3412),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Section 3: Date et heure / Date and time
            Text(
              'Date and time'.tr,
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 10),

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
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 365),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF9A3412),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.borderColor,
                            width: 1.2,
                          ),
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
                                DateFormat(
                                  'd MMM yyyy',
                                  Get.locale?.toString(),
                                ).format(selectedDate.value),
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
                                  primary: Color(0xFF9A3412),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.borderColor,
                            width: 1.2,
                          ),
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

            // Action Buttons: [ Annuler ]  [ Ajouter / Save ]
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
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 1.2,
                        ),
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
                    onTap: () async {
                      final title = titleController.text.trim();
                      final amount =
                          int.tryParse(amountController.text.trim()) ??
                          currentAmount.value;
                      if (title.isEmpty || amount <= 0) return;

                      final d = selectedDate.value;
                      final t = selectedTime.value;
                      final fullDateTime = DateTime(
                        d.year,
                        d.month,
                        d.day,
                        t.hour,
                        t.minute,
                      );

                      bool success = false;
                      if (isEdit && entry != null) {
                        success = await controller.editCaffeineEntry(
                          entry!.id,
                          title,
                          amount,
                          fullDateTime,
                        );
                      } else {
                        success = await controller.addCaffeineEntry(
                          title,
                          amount,
                          fullDateTime,
                        );
                      }
                      if (success) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9A3412),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        isEdit ? 'Save'.tr : 'Add'.tr,
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
            if (isEdit && entry != null) ...[
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.deleteCaffeineEntry(entry!.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
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
