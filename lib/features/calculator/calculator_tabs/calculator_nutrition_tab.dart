import 'package:chrisimhof/core/common/controller/time_controller.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_range_slider.dart';
import 'package:chrisimhof/core/common/widgets/time_widget.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:chrisimhof/features/calculator/models/nutrition_calculator_model.dart';
import 'package:chrisimhof/features/calculator/widgets/calculator_live_score_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class CalculatorNutritionTab extends StatelessWidget {
  const CalculatorNutritionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CalculatorController>();

    return Column(
      children: [
        const CalculatorLiveScoreSection(sectionKey: 'nutrition'),
        const SizedBox(height: 16),
        CustomRangeSlider(
          required: false,
          headerText: 'Desired Number of Meals'.tr,
          controller: controller.desiredNumberOfMealsController,
        ),
        const SizedBox(height: 24),
        TimeWidget(
          topTitle: 'First Meal Time'.tr,
          controller: controller.firstMealTimeController,
        ),
        const SizedBox(height: 24),
        TimeWidget(
          topTitle: 'Last Meal Time'.tr,
          controller: controller.lastMealTimeController,
        ),
        const SizedBox(height: 24),
        _nutritionBinarySelection(
          title: 'Already had a meal today?'.tr,
          selectedValue: controller.hasMealTodaySelection,
          leadingValue: 'Yes',
          trailingValue: 'No',
        ),
        const SizedBox(height: 24),
        _mealTagsSection(controller),
        const SizedBox(height: 24),
        _nutritionMealListSection(context, controller),
        const SizedBox(height: 32),
        Obx(
          () => CustomButton(
            text: controller.isNutritionSubmitting.value
                ? 'Submitting...'.tr
                : 'Next'.tr,
            onTap: controller.isNutritionSubmitting.value
                ? null
                : controller.submitNutritionData,
            width: double.infinity,
          ),
        ),
        const SizedBox(height: 16),
        _secondaryActionButton(
          text: 'Reset'.tr,
          onTap: () async {
            try {
              final msg = await controller.resetSession();
              controller.resetNutritionFormState();
              EasyLoading.showSuccess(msg);
            } catch (e) {
              EasyLoading.showError(e.toString());
            }
          },
        ),
        Obx(() {
          final errorMessage = controller.nutritionSubmitError.value;

          if (errorMessage.isEmpty) {
            return const SizedBox.shrink();
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            EasyLoading.showError(errorMessage);
            if (controller.nutritionSubmitError.value == errorMessage) {
              controller.nutritionSubmitError.value = '';
            }
          });

          return const SizedBox.shrink();
        }),
      ],
    );
  }
}

Widget _nutritionBinarySelection({
  required String title,
  required RxString selectedValue,
  required String leadingValue,
  required String trailingValue,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: getTextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
        ),
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: Obx(
              () => _capsuleToggleButton(
                text: leadingValue.tr,
                isSelected: selectedValue.value == leadingValue,
                onTap: () => selectedValue.value = leadingValue,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Obx(
              () => _capsuleToggleButton(
                text: trailingValue.tr,
                isSelected: selectedValue.value == trailingValue,
                onTap: () => selectedValue.value = trailingValue,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _mealTagsSection(CalculatorController controller) {
  const tags = ['LIGHT', 'HEAVY', 'FATTY'];

  return _sectionCard(
    title: 'Meal Tags'.tr,
    child: Row(
      children: tags
          .map(
            (tag) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: tag == tags.last ? 0 : 8),
                child: Obx(
                  () => _capsuleToggleButton(
                    text: tag.tr,
                    isSelected: controller.selectedMealTag.value == tag,
                    onTap: () => controller.selectMealTag(tag),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    ),
  );
}

Widget _nutritionMealListSection(
  BuildContext context,
  CalculatorController controller,
) {
  return _sectionCard(
    title: 'Meal Tags'.tr,
    child: Column(
      children: [
        Obx(() {
          if (controller.nutritionMeals.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No meals added yet'.tr,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondaryTextColor,
                ),
              ),
            );
          }

          return Column(
            children: List.generate(controller.nutritionMeals.length, (index) {
              final meal = controller.nutritionMeals[index];

              return Column(
                children: [
                  _nutritionMealRow(
                    meal: meal,
                    onTap: () =>
                        _showMealEditor(context, controller, index, meal),
                  ),
                  if (index != controller.nutritionMeals.length - 1)
                    const Divider(height: 1, color: Color(0xFFE5E7EB)),
                ],
              );
            }),
          );
        }),
        const SizedBox(height: 20),
        CustomButton(
          text: 'Add'.tr,
          onTap: controller.addNutritionMeal,
          width: double.infinity,
        ),
      ],
    ),
  );
}

Widget _nutritionMealRow({
  required NutritionMealRequest meal,
  required VoidCallback onTap,
}) {
  String formatDisplayTime(String value) {
    final parts = value.split(':');
    if (parts.length != 2) return value;

    final hour24 = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    final period = hour24 >= 12 ? 'PM' : 'AM';
    final normalizedHour = hour24 % 12 == 0 ? 12 : hour24 % 12;

    return '${normalizedHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}$period';
  }

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.tag.tr,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meal.order.toString(),
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatDisplayTime(meal.time),
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.secondaryTextColor,
          ),
        ],
      ),
    ),
  );
}

Widget _capsuleToggleButton({
  required String text,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryButtonColor
            : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: getTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : AppColors.primaryTextColor,
        ),
      ),
    ),
  );
}

Widget _secondaryActionButton({
  required String text,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: getTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTextColor,
        ),
      ),
    ),
  );
}

Widget _sectionCard({required String title, required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    ),
  );
}

Future<void> _showMealEditor(
  BuildContext context,
  CalculatorController controller,
  int index,
  NutritionMealRequest meal,
) async {
  final timeController = TimeController();
  final parts = meal.time.split(':');

  if (parts.length == 2) {
    timeController.hour.value = int.tryParse(parts[0]) ?? 0;
    timeController.minute.value = int.tryParse(parts[1]) ?? 0;
    timeController.period.value = timeController.hour.value >= 12 ? 'PM' : 'AM';
  }

  final selectedTag = meal.tag.obs;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TimeWidget(topTitle: 'Meal Time'.tr, controller: timeController),
              const SizedBox(height: 16),
              _sectionCard(
                title: 'Meal Tags'.tr,
                child: Row(
                  children: ['LIGHT', 'HEAVY', 'FATTY']
                      .map(
                        (tag) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: tag == 'FATTY' ? 0 : 8,
                            ),
                            child: Obx(
                              () => _capsuleToggleButton(
                                text: tag.tr,
                                isSelected: selectedTag.value == tag,
                                onTap: () => selectedTag.value = tag,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Save'.tr,
                onTap: () {
                  controller.updateNutritionMeal(
                    index,
                    meal.copyWith(
                      time: timeController.to24HourFormat,
                      tag: selectedTag.value,
                    ),
                  );
                  Navigator.of(context).pop();
                },
                width: double.infinity,
              ),
              const SizedBox(height: 12),
              _secondaryActionButton(
                text: 'Delete'.tr,
                onTap: () {
                  controller.removeNutritionMeal(index);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
