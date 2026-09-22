import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/nutrition/controller/nutrition_controller.dart';
import 'package:chrisimhof/features/nutrition/widgets/meal_timing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  late final NutritionController controller;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    controller = Get.find<NutritionController>();
    controller.fetchBaselineMealTarget();
  }

  @override
  Widget build(BuildContext context) {
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
              ),
              const SizedBox(height: 16),

              // 1. COMBINED REPAS DU JOUR & OBJECTIF QUOTIDIEN CARD
              Obx(() {
                final loggedCount = controller.loggedMealsCount;
                final target = controller.dailyTarget.value;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4), // soft green
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFD1FAE5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Title + Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'REPAS DU JOUR'.tr,
                            style: getTextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF047857),
                            ),
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F9F0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Image.asset(
                                IconPath.homeScreenMealIcon,
                                width: 20,
                                height: 20,
                                color: const Color(0xFF047857),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Counter: e.g. "3 / 5 prévus"
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$loggedCount ',
                              style: getTextStyle2(
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF047857),
                              ),
                            ),
                            TextSpan(
                              text: '/ $target ${'planned'.tr}',
                              style: getTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Segmented horizontal progress bars
                      Row(
                        children: List.generate(
                          target > 0 ? target : 1,
                          (index) => Expanded(
                            child: Container(
                              height: 8,
                              margin: EdgeInsets.only(
                                right: index == target - 1 ? 0 : 6,
                              ),
                              decoration: BoxDecoration(
                                color: index < loggedCount
                                    ? const Color(0xFF059669)
                                    : const Color(0xFFD1FAE5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Divider(height: 1, color: Color(0xFFD1FAE5)),
                      const SizedBox(height: 14),

                      // Daily goal stepper: Objectif quotidien [-] 5 [+]
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Daily goal'.tr,
                            style: getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: controller.decrementTarget,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.gray200),
                                  ),
                                  child: const Icon(
                                    Icons.remove_rounded,
                                    size: 18,
                                    color: AppColors.textSoft,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  '$target',
                                  style: getTextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryTextColor,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: controller.incrementTarget,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF059669),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.add_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),

              // 2. AJOUTER UN REPAS (ADD A MEAL) CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.subtle, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add a meal'.tr,
                      style: getTextStyle2(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Meal consistency'.tr,
                      style: getTextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSoft,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3 Choices: Léger, Moyen, Lourd
                    Obx(() {
                      final selected = controller.selectedMealType.value;
                      return Row(
                        children: [
                          _buildMealChoiceCard(
                            label: 'Light'.tr,
                            iconPath: IconPath.lightMeal,
                            isSelected: selected == 'Light',
                            onTap: () => controller.selectMealType('Light'),
                          ),
                          const SizedBox(width: 10),
                          _buildMealChoiceCard(
                            label: 'Medium'.tr,
                            iconPath: IconPath.mediumMeal,
                            isSelected: selected == 'Medium',
                            onTap: () => controller.selectMealType('Medium'),
                          ),
                          const SizedBox(width: 10),
                          _buildMealChoiceCard(
                            label: 'Heavy'.tr,
                            iconPath: IconPath.heavyMeal,
                            isSelected: selected == 'Heavy',
                            onTap: () => controller.selectMealType('Heavy'),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 16),

                    // Date & Time Picker Row: [Cal icon] Aujourd'hui · 13:17 [Edit icon]
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _pickDateTime,
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
                                _getFormattedSelectedDateTime(),
                                style: getTextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTextColor,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: AppColors.textSoft,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Save Button: + Enregistrer le repas
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        final fullDateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                        controller.saveMeal(occurredAt: fullDateTime);
                        // Reset date/time to now for next entry
                        setState(() {
                          selectedDate = DateTime.now();
                          selectedTime = TimeOfDay.now();
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Save meal'.tr,
                              style: getTextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),

              // 3. AUJOURD'HUI (TODAY'S LOGGED MEALS) HEADER & LIST
              Obx(() {
                final count = controller.loggedMealsCount;
                final countText = count > 1 ? '$count ${'meals'.tr}' : '$count ${'meal'.tr}';

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today'.tr,
                      style: getTextStyle2(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    if (count > 0)
                      Text(
                        countText,
                        style: getTextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.greyAlt,
                        ),
                      ),
                  ],
                );
              }),
              const SizedBox(height: 12),

              MealTiming(controller: controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealChoiceCard({
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

  String _getFormattedSelectedDateTime() {
    final now = DateTime.now();
    final isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
    final dateStr = isToday
        ? 'Today'.tr
        : DateFormat('d MMM', Get.locale?.toString()).format(selectedDate);
    final timeStr =
        '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
    return '$dateStr · $timeStr';
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
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
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
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
    if (pickedTime == null || !mounted) return;

    setState(() {
      selectedDate = pickedDate;
      selectedTime = pickedTime;
    });
  }
}
