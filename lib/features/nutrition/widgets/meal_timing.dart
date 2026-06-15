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
    
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Timeline (Circle & Line)
                Column(
                  children: [
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
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 36,
                        color: const Color(0xFFEEF2F0),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // Right Content
                Expanded(
                  child: SizedBox(
                    height: isLast ? 40 : 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      );
    });
  }
}
