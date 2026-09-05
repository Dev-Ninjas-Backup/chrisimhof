import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/nutrition/controller/nutrition_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MealTiming extends StatelessWidget {
  const MealTiming({
    super.key,
    required this.controller,
  });

  final NutritionController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEEF2F0)),
        ),
        child: Column(
          children: List.generate(controller.mealsList.length, (index) {
            final item = controller.mealsList[index];
            final isLast = index == controller.mealsList.length - 1;
    
            Color statusColor;
            Color badgeBgColor;
            Color badgeTextColor;
    
            if (item.type == 'Light') {
              statusColor = const Color(0xFF34D399); // mint
              badgeBgColor = const Color(0xFFECFDF5);
              badgeTextColor = const Color(0xFF059669);
            } else if (item.type == 'Medium') {
              statusColor = const Color(0xFFF59E0B); // orange
              badgeBgColor = const Color(0xFFFFFBEB);
              badgeTextColor = const Color(0xFFD97706);
            } else {
              statusColor = const Color(0xFFF43F5E); // rose
              badgeBgColor = const Color(0xFFFEF2F2);
              badgeTextColor = const Color(0xFFE11D48);
            }
    
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16.0),
              child: InkWell(
                onTap: () => _showEditMealDialog(context, item),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left Timeline Circle
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: item.isLogged ? statusColor : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: statusColor,
                            width: 2,
                          ),
                        ),
                        child: item.isLogged
                            ? const Icon(Icons.check, size: 14, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      // Meal Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.name,
                              style: getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.isLogged ? item.time : '${item.time} • planned',
                              style: getTextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Badge & Edit Icon
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: badgeBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.type,
                              style: getTextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: badgeTextColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: AppColors.textSoft,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  void _showEditMealDialog(BuildContext context, MealItem item) {
    final selectedHeaviness = (item.type.isNotEmpty ? item.type : 'Light').obs;
    DateTime initialDt = DateTime.now();
    if (item.time.contains(':') && !item.time.contains('--')) {
      try {
        final cleanTime = item.time.contains('·') ? item.time.split('·').last.trim() : item.time;
        final parts = cleanTime.replaceAll(RegExp(r'[^0-9:]'), '').split(':');
        if (parts.length >= 2) {
          final h = int.parse(parts[0]);
          final m = int.parse(parts[1]);
          final now = DateTime.now();
          initialDt = DateTime(now.year, now.month, now.day, h, m);
        }
      } catch (_) {}
    } else if (item.occurredAt != null && item.occurredAt!.isNotEmpty) {
      try {
        initialDt = DateTime.parse(item.occurredAt!);
      } catch (_) {}
    }
    final selectedDate = initialDt.obs;
    final selectedTime = TimeOfDay(hour: initialDt.hour, minute: initialDt.minute).obs;

    Get.dialog(
      Obx(
        () => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('Edit Meal Entry'.tr),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Heaviness'.tr,
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSoft,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: ['Light', 'Medium', 'Heavy'].map((h) {
                    final isSel =
                        selectedHeaviness.value.toLowerCase() == h.toLowerCase();
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => selectedHeaviness.value = h,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSel ? AppColors.primaryButtonColor : AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSel
                                  ? AppColors.primaryButtonColor
                                  : AppColors.borderSoft,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              h.tr,
                              style: getTextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isSel
                                    ? AppColors.white
                                    : AppColors.primaryTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
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
            if (item.id.isNotEmpty)
              TextButton(
                onPressed: () {
                  Get.back();
                  controller.deleteMealLog(item.id);
                },
                child: Text('Delete'.tr, style: const TextStyle(color: Colors.red)),
              ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel'.tr),
            ),
            ElevatedButton(
              onPressed: () {
                final d = selectedDate.value;
                final t = selectedTime.value;
                final fullDateTime = DateTime(d.year, d.month, d.day, t.hour, t.minute);
                Get.back();
                controller.editMealLog(item.id, selectedHeaviness.value, occurredAt: fullDateTime);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButtonColor,
              ),
              child: Text('Save'.tr, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
