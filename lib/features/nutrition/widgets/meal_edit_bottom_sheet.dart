import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/core/service/helper/timezone_helper.dart';
import 'package:chrisimhof/features/nutrition/controller/nutrition_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MealEditBottomSheet extends StatelessWidget {
  final NutritionController controller;
  final MealItem meal;

  const MealEditBottomSheet({
    super.key,
    required this.controller,
    required this.meal,
  });

  static Future<void> show(
    BuildContext context, {
    required NutritionController controller,
    required MealItem meal,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MealEditBottomSheet(
        controller: controller,
        meal: meal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime initialDt = DateTime.now();
    if (meal.time.contains(':') && !meal.time.contains('--')) {
      try {
        final timeOnly = meal.time.split(' ').last;
        final parts = timeOnly.split(':');
        final h = int.parse(parts[0].trim());
        final m = int.parse(parts[1].trim());
        DateTime baseDate = DateTime.now();
        if (meal.occurredAt != null && meal.occurredAt!.isNotEmpty) {
          try {
            baseDate = TimezoneHelper.parseSessionUtcToLocal(meal.occurredAt!);
          } catch (_) {}
        }
        initialDt = DateTime(baseDate.year, baseDate.month, baseDate.day, h, m);
      } catch (_) {}
    } else if (meal.occurredAt != null && meal.occurredAt!.isNotEmpty) {
      try {
        initialDt = TimezoneHelper.parseSessionUtcToLocal(meal.occurredAt!);
      } catch (_) {}
    }

    String initialType = 'Light';
    final tLower = meal.type.toLowerCase();
    if (tLower == 'heavy' || tLower == 'lourd') {
      initialType = 'Heavy';
    } else if (tLower == 'medium' || tLower == 'moyen') {
      initialType = 'Medium';
    }

    final selectedType = initialType.obs;
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
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
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

            // Header: Fork & Knife Icon + Tag + Title + Close Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Image.asset(
                      IconPath.homeScreenMealIcon,
                      width: 24,
                      height: 24,
                      color: const Color(0xFF047857),
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
                        'NUTRITION',
                        style: getTextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSoft,
                        ).copyWith(letterSpacing: 0.8),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Modifier le repas'.tr,
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

            // Section 1: Consistance du repas / Meal consistency
            Text(
              'Meal consistency'.tr,
              style: getTextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),

            // 3 Choice Cards: Léger, Moyen, Lourd
            Obx(() {
              final currentType = selectedType.value;
              return Row(
                children: [
                  _buildChoiceCard(
                    typeKey: 'Light',
                    label: 'Light'.tr,
                    iconPath: IconPath.lightMeal,
                    isSelected: currentType == 'Light',
                    onTap: () => selectedType.value = 'Light',
                  ),
                  const SizedBox(width: 10),
                  _buildChoiceCard(
                    typeKey: 'Medium',
                    label: 'Medium'.tr,
                    iconPath: IconPath.mediumMeal,
                    isSelected: currentType == 'Medium',
                    onTap: () => selectedType.value = 'Medium',
                  ),
                  const SizedBox(width: 10),
                  _buildChoiceCard(
                    typeKey: 'Heavy',
                    label: 'Heavy'.tr,
                    iconPath: IconPath.heavyMeal,
                    isSelected: currentType == 'Heavy',
                    onTap: () => selectedType.value = 'Heavy',
                  ),
                ],
              );
            }),
            const SizedBox(height: 12),

            // Description Chip: Icon + e.g. "Repas léger"
            Obx(() {
              final type = selectedType.value;
              String desc = 'Light meal'.tr;
              String icon = IconPath.lightMeal;
              if (type == 'Medium') {
                desc = 'Medium meal'.tr;
                icon = IconPath.mediumMeal;
              } else if (type == 'Heavy') {
                desc = 'Heavy meal'.tr;
                icon = IconPath.heavyMeal;
              }

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD1FAE5)),
                ),
                child: Row(
                  children: [
                    Image.asset(icon, width: 22, height: 22),
                    const SizedBox(width: 10),
                    Text(
                      desc,
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF047857),
                      ),
                    ),
                  ],
                ),
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
                                  primary: Color(0xFF047857),
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
                                  primary: Color(0xFF047857),
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
                      final d = selectedDate.value;
                      final t = selectedTime.value;
                      final fullDateTime = DateTime(d.year, d.month, d.day, t.hour, t.minute);
                      Navigator.of(context).pop();
                      controller.editMealLog(
                        meal.id,
                        selectedType.value,
                        occurredAt: fullDateTime,
                      );
                    },
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669),
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

            // Delete meal action
            if (meal.id.isNotEmpty && meal.id.length >= 10) ...[
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.deleteMealLog(meal.id);
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
                          'Delete meal'.tr,
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
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceCard({
    required String typeKey,
    required String label,
    required String iconPath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFECFDF5) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF059669) : AppColors.subtle,
              width: isSelected ? 1.5 : 1.2,
            ),
          ),
          child: Stack(
            children: [
              // Top Right Checkmark
              if (isSelected)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Color(0xFF059669),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      iconPath,
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
