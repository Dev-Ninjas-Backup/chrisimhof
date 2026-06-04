import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_text_form_field.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/dashboard/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class QuickAddWidget extends StatelessWidget {
  QuickAddWidget({super.key});

  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, right: 16, bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Add'.tr,
            style: getTextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _QuickAddItem(
                  title: 'Hydration'.tr,
                  iconPath: IconPath.waterDrops,
                  onAdd: () => _showHydrationSheet(context),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _QuickAddItem(
                  title: 'Sport'.tr,
                  iconPath: IconPath.sports,
                  onAdd: () => _showSportSheet(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _QuickAddItem(
                  title: 'Caffeine'.tr,
                  iconPath: IconPath.vector,
                  onAdd: () => _showCaffeineSheet(context),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _QuickAddItem(
                  title: 'Nutrition'.tr,
                  iconPath: IconPath.iron,
                  onAdd: () => _showNutritionSheet(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showHydrationSheet(BuildContext context) async {
    final consumedController = TextEditingController();
    final goalController = TextEditingController(text: '2.5');

    await _showQuickAddSheet(
      context: context,
      title: 'Add Hydration'.tr,
      child: Column(
        children: [
          CustomTextFormField(
            label: 'Already Consumed (L)'.tr,
            controller: consumedController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            hintText: '0.5',
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            label: 'Daily Goal (L)'.tr,
            controller: goalController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            hintText: '2.5',
          ),
          const SizedBox(height: 24),
          _SubmitQuickAddButton(
            onPressed: () async {
              final consumed = double.tryParse(consumedController.text.trim());
              final goal = double.tryParse(goalController.text.trim());

              if (consumed == null || goal == null) {
                EasyLoading.showError('Enter valid hydration values'.tr);
                return;
              }

              await _submitAction(
                action: () => controller.quickAddHydration(
                  waterConsumedL: consumed,
                  waterGoalL: goal,
                ),
                close: () => Navigator.of(context).pop(),
                successMessage: 'Hydration updated'.tr,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showCaffeineSheet(BuildContext context) async {
    final amountController = TextEditingController();
    final timeController = TextEditingController(text: '08:00');
    final drinkNameController = TextEditingController(text: 'Americano');
    final drinkType = 'COFFEE'.obs;

    await _showQuickAddSheet(
      context: context,
      title: 'Add Caffeine'.tr,
      child: Column(
        children: [
          CustomTextFormField(
            label: 'Amount (mg)'.tr,
            controller: amountController,
            keyboardType: TextInputType.number,
            hintText: '95',
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            label: 'Time (HH:mm)'.tr,
            controller: timeController,
            hintText: '08:00',
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            label: 'Drink Name'.tr,
            controller: drinkNameController,
            hintText: 'Americano',
          ),
          const SizedBox(height: 16),
          Obx(
            () => DropdownButtonFormField<String>(
              initialValue: drinkType.value,
              decoration: _dropdownDecoration('Drink Type'.tr),
              items: const ['COFFEE', 'ESPRESSO', 'TEA', 'ENERGY_DRINK']
                  .map(
                    (type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) drinkType.value = value;
              },
            ),
          ),
          const SizedBox(height: 24),
          _SubmitQuickAddButton(
            onPressed: () async {
              final amount = int.tryParse(amountController.text.trim());
              if (amount == null || amount <= 0) {
                EasyLoading.showError('Enter a valid caffeine amount'.tr);
                return;
              }

              await _submitAction(
                action: () => controller.quickAddCaffeine(
                  amountMg: amount,
                  consumedAt: timeController.text.trim(),
                  drinkType: drinkType.value,
                  drinkName: drinkNameController.text.trim(),
                ),
                close: () => Navigator.of(context).pop(),
                successMessage: 'Caffeine updated'.tr,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showSportSheet(BuildContext context) async {
    final durationController = TextEditingController();
    final activityType = 'WALKING'.obs;
    final intensity = 'LIGHT'.obs;

    await _showQuickAddSheet(
      context: context,
      title: 'Add Sport'.tr,
      child: Column(
        children: [
          Obx(
            () => DropdownButtonFormField<String>(
              initialValue: activityType.value,
              decoration: _dropdownDecoration('Activity Type'.tr),
              items: const ['WALKING', 'RUNNING', 'CYCLING', 'STRENGTH']
                  .map(
                    (type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) activityType.value = value;
              },
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => DropdownButtonFormField<String>(
              initialValue: intensity.value,
              decoration: _dropdownDecoration('Intensity'.tr),
              items: const ['LIGHT', 'MODERATE', 'HARD']
                  .map(
                    (type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) intensity.value = value;
              },
            ),
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            label: 'Duration (min)'.tr,
            controller: durationController,
            keyboardType: TextInputType.number,
            hintText: '30',
          ),
          const SizedBox(height: 24),
          _SubmitQuickAddButton(
            onPressed: () async {
              final duration = int.tryParse(durationController.text.trim());
              if (duration == null || duration <= 0) {
                EasyLoading.showError('Enter a valid duration'.tr);
                return;
              }

              await _submitAction(
                action: () => controller.quickAddSport(
                  activityType: activityType.value,
                  intensity: intensity.value,
                  durationMin: duration,
                ),
                close: () => Navigator.of(context).pop(),
                successMessage: 'Sport updated'.tr,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showNutritionSheet(BuildContext context) async {
    final mealTimeController = TextEditingController(text: '12:30');
    final mealsPerDayController = TextEditingController(text: '4');
    final firstMealTimeController = TextEditingController(text: '07:00');
    final lastMealTimeController = TextEditingController(text: '20:00');
    final mealOrderController = TextEditingController(text: '2');
    final hadMealToday = true.obs;
    final mealTag = 'HEAVY'.obs;

    await _showQuickAddSheet(
      context: context,
      title: 'Add Nutrition'.tr,
      child: Column(
        children: [
          CustomTextFormField(
            label: 'Meal Time (HH:mm)'.tr,
            controller: mealTimeController,
            hintText: '12:30',
          ),
          const SizedBox(height: 16),
          Obx(
            () => DropdownButtonFormField<String>(
              initialValue: mealTag.value,
              decoration: _dropdownDecoration('Meal Tag'.tr),
              items: const ['LIGHT', 'HEAVY', 'FATTY']
                  .map(
                    (tag) =>
                        DropdownMenuItem<String>(value: tag, child: Text(tag)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) mealTag.value = value;
              },
            ),
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            label: 'Meals Per Day'.tr,
            controller: mealsPerDayController,
            keyboardType: TextInputType.number,
            hintText: '4',
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            label: 'Meal Order'.tr,
            controller: mealOrderController,
            keyboardType: TextInputType.number,
            hintText: '2',
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            label: 'First Meal Time'.tr,
            controller: firstMealTimeController,
            hintText: '07:00',
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            label: 'Last Meal Time'.tr,
            controller: lastMealTimeController,
            hintText: '20:00',
          ),
          const SizedBox(height: 16),
          Obx(
            () => SwitchListTile.adaptive(
              activeThumbColor: AppColors.primaryButtonColor,
              activeTrackColor: AppColors.primaryButtonColor.withValues(
                alpha: 0.35,
              ),
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Had Meal Today'.tr,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
              value: hadMealToday.value,
              onChanged: (value) => hadMealToday.value = value,
            ),
          ),
          const SizedBox(height: 8),
          _SubmitQuickAddButton(
            onPressed: () async {
              final mealsPerDay = int.tryParse(
                mealsPerDayController.text.trim(),
              );
              final order = int.tryParse(mealOrderController.text.trim());

              if (mealsPerDay == null || order == null) {
                EasyLoading.showError('Enter valid nutrition values'.tr);
                return;
              }

              await _submitAction(
                action: () => controller.quickAddNutrition(
                  mealTime: mealTimeController.text.trim(),
                  mealTag: mealTag.value,
                  order: order,
                  mealsPerDay: mealsPerDay,
                  firstMealTime: firstMealTimeController.text.trim(),
                  lastMealTime: lastMealTimeController.text.trim(),
                  hadMealToday: hadMealToday.value,
                ),
                close: () => Navigator.of(context).pop(),
                successMessage: 'Nutrition updated'.tr,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showQuickAddSheet({
    required BuildContext context,
    required String title,
    required Widget child,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: getTextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  child,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitAction({
    required Future<void> Function() action,
    required VoidCallback close,
    required String successMessage,
  }) async {
    try {
      await action();
      close();
      EasyLoading.showSuccess(successMessage);
    } catch (e) {
      EasyLoading.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: getTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryTextColor,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: AppColors.primaryTextColor),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}

class _QuickAddItem extends StatelessWidget {
  const _QuickAddItem({
    required this.title,
    required this.iconPath,
    required this.onAdd,
  });

  final String title;
  final String iconPath;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F7F8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(iconPath, fit: BoxFit.cover),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
        ),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F7F8),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: AppColors.primaryButtonColor,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class _SubmitQuickAddButton extends StatelessWidget {
  const _SubmitQuickAddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    return Obx(
      () => CustomButton(
        text: controller.isQuickAddSubmitting.value
            ? 'Updating...'.tr
            : 'Save'.tr,
        onTap: controller.isQuickAddSubmitting.value ? null : onPressed,
        width: double.infinity,
      ),
    );
  }
}
