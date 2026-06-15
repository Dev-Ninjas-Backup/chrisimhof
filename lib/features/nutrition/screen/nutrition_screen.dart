import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/nutrition/controller/nutrition_controller.dart';
import 'package:chrisimhof/features/nutrition/widgets/log_meal.dart';
import 'package:chrisimhof/features/nutrition/widgets/meal_timing.dart';
import 'package:chrisimhof/features/nutrition/widgets/set_meal_target.dart';
import 'package:chrisimhof/features/nutrition/widgets/sleep_impact_card.dart';
import 'package:chrisimhof/features/nutrition/widgets/todays_meal_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final NutritionController controller = Get.put(NutritionController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: 'Nutrition'.tr,
                showBackButton: true,
                showMoreButton: true,
              ),
              const SizedBox(height: 28),

              // TODAY'S MEALS CARD
              TodaysMealCard(controller: controller),
              const SizedBox(height: 20),

              // DAILY TARGET CARD
              SetMealTarget(controller: controller),
              const SizedBox(height: 20),

              // LOG A MEAL CARD
              LogMeal(controller: controller),
              const SizedBox(height: 30),

              // TODAY'S TIMING HEADER
              Text(
                "TODAY'S TIMING",
                style: getTextStyle2(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 12),

              // TIMELINE CARD
              MealTiming(controller: controller),
              const SizedBox(height: 20),

              // SLEEP IMPACT ALERT CARD
              SleepImpactCard(),
              const SizedBox(height: 20),

              // DAILY NOTES CARD
              Obx(() {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFEEF2F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DAILY NOTES',
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textSoft,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...controller.notesList.map((note) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              '"$note"',
                              style: getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryTextColor,
                              ),
                            ),
                          )),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => showAddNoteDialog(context, controller),
                        child: Row(
                          children: [
                            const Icon(Icons.add, size: 16, color: Color(0xFF10B981)),
                            const SizedBox(width: 4),
                            Text(
                              'Add note',
                              style: getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void showAddNoteDialog(BuildContext context, NutritionController controller) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Add Note',
          style: getTextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
          ),
        ),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Enter your note here...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: getTextStyle(color: AppColors.textSoft),
            ),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                controller.addNote(textController.text);
              }
              Get.back();
            },
            child: Text(
              'Add',
              style: getTextStyle(
                color: const Color(0xFF10B981),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
