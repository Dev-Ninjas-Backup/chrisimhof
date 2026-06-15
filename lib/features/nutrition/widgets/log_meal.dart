import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/nutrition/controller/nutrition_controller.dart';
import 'package:chrisimhof/features/nutrition/widgets/meal_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogMeal extends StatelessWidget {
  const LogMeal({
    super.key,
    required this.controller,
  });

  final NutritionController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final formattedTime = '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEEF2F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LOG A MEAL',
                  style: getTextStyle2(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 4),
                    Text(
                      'now - $formattedTime',
                      style: getTextStyle2(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'How heavy was it (no food names — only heaviness matters for sleep & recovery)',
              style: getTextStyle2(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textSoft,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                MealCard(type: 'Light', iconPath: IconPath.lightMeal, subtext: 'salad • fruit • snack', isSelected: controller.selectedMealType.value == 'Light', activeColor: const Color(0xFF10B981), bgColor: const Color(0xFFECFDF5), textColor: const Color(0xFF047857), subtextColor: const Color(0xFF065F46), onTap: () => controller.selectMealType('Light')),
                const SizedBox(width: 8),
                MealCard(type: 'Medium', iconPath: IconPath.mediumMeal, subtext: 'standard • balanced', isSelected: controller.selectedMealType.value == 'Medium', activeColor: const Color(0xFFF59E0B), bgColor: const Color(0xFFFFFBEB), textColor: const Color(0xFFB45309), subtextColor: const Color(0xFF78350F), onTap: () => controller.selectMealType('Medium')),
                const SizedBox(width: 8),
                MealCard(type: 'Heavy', iconPath: IconPath.heavyMeal, subtext: 'rich • fatty • large', isSelected: controller.selectedMealType.value == 'Heavy', activeColor: const Color(0xFFF43F5E), bgColor: const Color(0xFFFEF2F2), textColor: const Color(0xFFBE123C), subtextColor: const Color(0xFF9F1239), onTap: () => controller.selectMealType('Heavy')),
              ],
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Save meal',
              onTap: controller.saveMeal,
              backgroundColor: const Color(0xFF111827), // Slate 900
              textColor: Colors.white,
              icon: null,
              plusIcon: true,
              showIcon: Icons.add_rounded,
              iconColor: Colors.white,
            ),
          ],
        ),
      );
    });
  }
}
