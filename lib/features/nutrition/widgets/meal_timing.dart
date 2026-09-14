import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/nutrition/controller/nutrition_controller.dart';
import 'package:chrisimhof/features/nutrition/widgets/meal_edit_bottom_sheet.dart';
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
      final meals = controller.mealsList.where((m) => m.isLogged).toList();

      if (meals.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.subtle, width: 1.5),
          ),
          child: Center(
            child: Text(
              'No meals logged yet.'.tr,
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSoft,
              ),
            ),
          ),
        );
      }

      final sortedMeals = List<MealItem>.from(meals);
      sortedMeals.sort((a, b) {
        if (a.occurredAt != null &&
            b.occurredAt != null &&
            a.occurredAt!.isNotEmpty &&
            b.occurredAt!.isNotEmpty) {
          try {
            final dtA = DateTime.parse(a.occurredAt!);
            final dtB = DateTime.parse(b.occurredAt!);
            final cmp = dtA.compareTo(dtB);
            if (cmp != 0) return cmp;
          } catch (_) {}
        }
        int parseMinutes(String timeStr) {
          try {
            final clean = timeStr.contains('·')
                ? timeStr.split('·').last.trim()
                : timeStr.contains(' ')
                    ? timeStr.split(' ').last.trim()
                    : timeStr.trim();
            final parts = clean.split(':');
            if (parts.length >= 2) {
              final h = int.parse(parts[0].trim());
              final m = int.parse(parts[1].trim());
              return h * 60 + m;
            }
          } catch (_) {}
          return 0;
        }

        return parseMinutes(a.time).compareTo(parseMinutes(b.time));
      });

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.subtle, width: 1.5),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: sortedMeals.length,
          separatorBuilder: (context, index) => const Divider(
            height: 1.5,
            color: AppColors.subtle,
          ),
          itemBuilder: (context, index) {
            final item = sortedMeals[index];

            Color badgeBgColor;
            Color badgeTextColor;
            final typeLower = item.type.toLowerCase();
            if (typeLower == 'heavy' || typeLower == 'lourd') {
              badgeBgColor = const Color(0xFFFEF2F2);
              badgeTextColor = const Color(0xFFE11D48);
            } else if (typeLower == 'medium' || typeLower == 'moyen') {
              badgeBgColor = const Color(0xFFFFFBEB);
              badgeTextColor = const Color(0xFFD97706);
            } else {
              badgeBgColor = const Color(0xFFECFDF5);
              badgeTextColor = const Color(0xFF059669);
            }

            final mealNumber = index + 1;
            final key = 'Meal $mealNumber';
            final defaultMealName =
                (mealNumber <= 8) ? key.tr : '${'Meal'.tr} $mealNumber';

            String displayMealName = defaultMealName;
            final lower = item.name.toLowerCase().trim();
            final isGenericOrCircadian = lower.isEmpty ||
                lower == 'meal' ||
                lower.startsWith('meal ') ||
                lower == 'snack' ||
                lower == 'pre-shift meal' ||
                lower == 'night meal' ||
                lower == 'post-shift meal' ||
                lower == 'repas' ||
                lower == 'collation' ||
                lower == 'undefined' ||
                lower == 'null';

            if (!isGenericOrCircadian) {
              displayMealName = item.name.tr;
            }

            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => MealEditBottomSheet.show(
                context,
                controller: controller,
                meal: item,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Row(
                  children: [
                    // Green checkmark circle
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Meal Name and Time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            displayMealName,
                            style: getTextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.time,
                            style: getTextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.greyAlt,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Badge (Léger / Moyen / Lourd)
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
                        item.type.tr,
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: badgeTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Pencil Edit Icon
                    const Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: AppColors.textSoft,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
