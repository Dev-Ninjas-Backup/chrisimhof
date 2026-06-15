import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/nutrition/controller/nutrition_controller.dart';
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
              Obx(() {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.mintSoft2, // Light mint soft green
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
                          color: AppColors.secondaryButtonColor,
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
                                color: AppColors.secondaryButtonColor,
                              ),
                            ),
                            TextSpan(
                              text: ' / ${controller.dailyTarget.value} planned',
                              style: getTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.mint,
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
                                    ? AppColors.secondaryButtonColor
                                    : AppColors.mint.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),

              // DAILY TARGET CARD
              Obx(() {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderSoft),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.mintSoft2,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Image(
                            image: AssetImage(IconPath.nutrition),
                            width: 24,
                            height: 24,
                            color: AppColors.secondaryButtonColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daily target',
                              style: getTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'How many meals per day?',
                              style: getTextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: controller.decrementTarget,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.gray200),
                              ),
                              child: const Icon(Icons.remove, size: 16, color: AppColors.textSoft),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${controller.dailyTarget.value}',
                            style: getTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: controller.incrementTarget,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.secondaryButtonColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.add, size: 16, color: AppColors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),

              // LOG A MEAL CARD
              Obx(() {
                final formattedTime = '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderSoft),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'LOG A MEAL',
                            style: getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 14, color: AppColors.textSoft),
                              const SizedBox(width: 4),
                              Text(
                                'now - $formattedTime',
                                style: getTextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSoft,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'How heavy was it (no food names — only heaviness matters for sleep & recovery)',
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSoft,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _buildMealSelectionCard(
                            type: 'Light',
                            iconPath: IconPath.lightMeal,
                            subtext: 'salad • fruit • snack',
                            isSelected: controller.selectedMealType.value == 'Light',
                            activeColor: AppColors.secondaryButtonColor,
                            bgColor: AppColors.mintSoft2,
                            textColor: AppColors.emerald,
                            subtextColor: AppColors.mintSoftText,
                            onTap: () => controller.selectMealType('Light'),
                          ),
                          const SizedBox(width: 8),
                          _buildMealSelectionCard(
                            type: 'Medium',
                            iconPath: IconPath.mediumMeal,
                            subtext: 'standard • balanced',
                            isSelected: controller.selectedMealType.value == 'Medium',
                            activeColor: AppColors.amber,
                            bgColor: AppColors.amberSoft,
                            textColor: AppColors.amberDarker,
                            subtextColor: AppColors.amberDarkest,
                            onTap: () => controller.selectMealType('Medium'),
                          ),
                          const SizedBox(width: 8),
                          _buildMealSelectionCard(
                            type: 'Heavy',
                            iconPath: IconPath.heavyMeal,
                            subtext: 'rich • fatty • large',
                            isSelected: controller.selectedMealType.value == 'Heavy',
                            activeColor: AppColors.rose,
                            bgColor: AppColors.roseSoft2,
                            textColor: AppColors.roseDark,
                            subtextColor: AppColors.roseDarkest,
                            onTap: () => controller.selectMealType('Heavy'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: controller.saveMeal,
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.primaryTextColor, // Slate 900
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add, color: AppColors.white, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                'Save meal',
                                style: getTextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 30),

              // TODAY'S TIMING HEADER
              Text(
                "TODAY'S TIMING",
                style: getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 12),

              // TIMELINE CARD
              Obx(() {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderSoft),
                  ),
                  child: Column(
                    children: List.generate(controller.mealsList.length, (index) {
                      final item = controller.mealsList[index];
                      final isLast = index == controller.mealsList.length - 1;

                      Color statusColor;
                      Color badgeBgColor;
                      Color badgeTextColor;

                      if (item.type == 'Light') {
                        statusColor = AppColors.primaryButtonColor; // mint
                        badgeBgColor = AppColors.mintSoft2;
                        badgeTextColor = AppColors.emeraldMedium;
                      } else if (item.type == 'Medium') {
                        statusColor = AppColors.amber; // orange
                        badgeBgColor = AppColors.amberSoft;
                        badgeTextColor = AppColors.amberDark;
                      } else {
                        statusColor = AppColors.rose; // rose
                        badgeBgColor = AppColors.roseSoft2;
                        badgeTextColor = AppColors.red;
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
                                  color: item.isLogged ? statusColor : AppColors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: statusColor,
                                    width: 2,
                                  ),
                                ),
                                child: item.isLogged
                                    ? const Icon(Icons.check, size: 14, color: AppColors.white)
                                    : null,
                              ),
                              if (!isLast)
                                Container(
                                  width: 2,
                                  height: 36,
                                  color: AppColors.borderSoft,
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
              }),
              const SizedBox(height: 20),

              // SLEEP IMPACT ALERT CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 234, 236, 244), // Indigo soft
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 1, color: AppColors.indigoSoft),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.indigoSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Image(
                          image: AssetImage(IconPath.sleep),
                          width: 24,
                          height: 24,
                          color: AppColors.indigo,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SLEEP IMPACT',
                            style: getTextStyle2(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              style: getTextStyle2(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blueDark,
                              ),
                              children: [
                                const TextSpan(text: 'Keep night meal '),
                                TextSpan(
                                  text: 'Light',
                                  style: getTextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.blueDark,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' — Heavy meals after 02:00 reduce deep sleep by ~15%.',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // DAILY NOTES CARD
              Obx(() {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderSoft),
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
                        onTap: () => _showAddNoteDialog(context, controller),
                        child: Row(
                          children: [
                            const Icon(Icons.add, size: 16, color: AppColors.secondaryButtonColor),
                            const SizedBox(width: 4),
                            Text(
                              'Add note',
                              style: getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondaryButtonColor,
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

  Widget _buildMealSelectionCard({
    required String type,
    required String iconPath,
    required String subtext,
    required bool isSelected,
    required Color activeColor,
    required Color bgColor,
    required Color textColor,
    required Color subtextColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? activeColor : AppColors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                iconPath,
                height: 24,
                width: 24,
              ),
              const SizedBox(height: 8),
              Text(
                type,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtext,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: subtextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context, NutritionController controller) {
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
            onPressed: () => Navigator.pop(context),
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
              Navigator.pop(context);
            },
            child: Text(
              'Add',
              style: getTextStyle(
                color: AppColors.secondaryButtonColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}