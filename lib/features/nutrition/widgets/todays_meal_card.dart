import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/nutrition/controller/nutrition_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodaysMealCard extends StatelessWidget {
  const TodaysMealCard({
    super.key,
    required this.controller,
  });

  final NutritionController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFECFDF5), // Light mint soft green
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "TODAY'S MEALS",
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF10B981),
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${controller.loggedMealsCount}',
                    style: getTextStyle2(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                  TextSpan(
                    text: ' / ${controller.dailyTarget.value} planned',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF83EDBA),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(
                controller.dailyTarget.value,
                (index) => Expanded(
                  child: Container(
                    height: 8,
                    margin: EdgeInsets.only(
                      right: index == controller.dailyTarget.value - 1 ? 0 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: index < controller.loggedMealsCount
                          ? const Color(0xFF10B981)
                          : const Color(0xFF83EDBA).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
