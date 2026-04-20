import 'package:chrisimhof/core/common/controller/range_slider_controller.dart';
import 'package:chrisimhof/core/common/controller/time_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class CalculatorController extends GetxController {
  final tabs = ['Sleep', 'Work', 'Nutrition', 'Hydration', 'Caffeine', 'Sport'];

  final selectedTabIndex = 0.obs;

  // Sleep Tab Controllers
  late TimeController wakeUpController;
  late TimeController desiredSleepStartController;
  late TimeController desiredSleepEndController;
  late TimeController preferredTimeController;
  late TextEditingController durationController;
  late RangeSliderController sleepLastNightController;
  late RangeSliderController sleepGoalController;

  // Work Tab Controllers
  late TimeController workBeginsController;
  late TimeController workCompleteController;
  late TextEditingController daysWorkedController;
  final RxString selectedShiftType = 'Day'.obs;

  // Hydration Tab Controllers
  late RangeSliderController hydrationConsumedController;
  late RangeSliderController hydrationDailyGoalController;

// Nutrition Tab Controllers
  late RangeSliderController desiredNumberOfMealsController;
  late TimeController firstMealTimeController;
  late TimeController lastMealTimeController;
  final RxString hasMealTodaySelection = 'No'.obs;

  // Sport Tab Controllers
  late TextEditingController sportDurationController;
  final RxString selectedActivityType = ''.obs;
  final RxDouble sportIntensity = 0.0.obs;

  // Caffeine Tab Controllers
  final RxDouble caffeine24hValue = 180.0.obs;
  final RxDouble caffeinMaxValue = 400.0.obs;
  final RxDouble caffeineLastEightHoursValue = 110.0.obs;
  late TimeController caffeineIntakeTimeController;
  final RxList<Map<String, String>> caffeineHistory = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeSleepControllers();
    _initializeWorkControllers();
    _initializeNutritionControllers();
    _initializeSportControllers();
    _initializeCaffeineControllers();
    _loadCaffeineHistory();
  }

  void _initializeSleepControllers() {
    wakeUpController = TimeController();
    desiredSleepStartController = TimeController();
    desiredSleepEndController = TimeController();
    preferredTimeController = TimeController();
    durationController = TextEditingController();
    sleepLastNightController = RangeSliderController(initialValue: 8);
    sleepGoalController = RangeSliderController(initialValue: 8);
  }

  void _initializeWorkControllers() {
    workBeginsController = TimeController();
    workCompleteController = TimeController();
    daysWorkedController = TextEditingController();
  }

  void _initializeNutritionControllers() {
    hydrationConsumedController = RangeSliderController(initialValue: 1.0);
    hydrationDailyGoalController = RangeSliderController(initialValue: 2.5);
    desiredNumberOfMealsController = RangeSliderController(initialValue: 3.0);
    firstMealTimeController = TimeController();
    lastMealTimeController = TimeController();
  }

  void _initializeSportControllers() {
    sportDurationController = TextEditingController();
  }

  void _initializeCaffeineControllers() {
    caffeineIntakeTimeController = TimeController();
    // Initialize with sample caffeine history
    caffeineHistory.assignAll([
      {'name': 'Coffee', 'dose': '100mg', 'time': '06:11 PM'},
      {'name': 'Espresso', 'dose': '75mg', 'time': '02:45 PM'},
    ]);
  }

  void _loadCaffeineHistory() {
  }

  void addCaffeineIntake(String name, int mgAmount, String time) {
    caffeineHistory.add({
      'name': name,
      'dose': '${mgAmount}mg',
      'time': time,
    });
    caffeine24hValue.value += mgAmount;
    caffeineLastEightHoursValue.value += mgAmount;
  }

  void clearCaffeineHistory() {
    caffeineHistory.clear();
    caffeine24hValue.value = 0;
    caffeineLastEightHoursValue.value = 0;
  }

  void resetCaffeineTracking() {
    caffeineLastEightHoursValue.value = 0;
  }

  void removeCaffeineEntry(int index) {
    if (index >= 0 && index < caffeineHistory.length) {
      caffeineHistory.removeAt(index);
    }
  }

  void selectShiftType(String shiftType) {
    selectedShiftType.value = shiftType;
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void selectActivityType(String activityType) {
    selectedActivityType.value = activityType;
  }

  void setSportIntensity(double intensity) {
    sportIntensity.value = intensity;
  }

  @override
  void onClose() {
    durationController.dispose();
    daysWorkedController.dispose();
    sportDurationController.dispose();
    caffeineIntakeTimeController.dispose();
    super.onClose();
  }
}
