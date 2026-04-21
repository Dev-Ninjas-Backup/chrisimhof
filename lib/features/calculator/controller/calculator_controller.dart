import 'package:chrisimhof/core/common/controller/range_slider_controller.dart';
import 'package:chrisimhof/core/common/controller/time_controller.dart';
import 'package:chrisimhof/features/calculator/models/calculator_session_model.dart';
import 'package:chrisimhof/features/calculator/models/caffeine_preset_model.dart';
import 'package:chrisimhof/features/calculator/models/caffeine_intake_model.dart';
import 'package:chrisimhof/features/calculator/models/hydration_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/sleep_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/work_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/nutrition_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/sport_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/activity_type_enum.dart';
import 'package:chrisimhof/features/calculator/service/calculator_service.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class CalculatorController extends GetxController {
  final tabs = ['Sleep', 'Work', 'Nutrition', 'Hydration', 'Caffeine', 'Sport'];

  final selectedTabIndex = 0.obs;

  // Session Management
  final CalculatorService _calculatorService = CalculatorService();
  final Rx<CalculatorSession?> calculatorSession = Rx(null);
  final RxBool isSessionLoading = true.obs;
  final RxString sessionError = ''.obs;

  // Sleep submission
  final RxBool isSleepSubmitting = false.obs;
  final RxString sleepSubmitError = ''.obs;

  // Work submission
  final RxBool isWorkSubmitting = false.obs;
  final RxString workSubmitError = ''.obs;

  // Nutrition submission
  final RxBool isNutritionSubmitting = false.obs;
  final RxString nutritionSubmitError = ''.obs;

  // Hydration submission
  final RxBool isHydrationSubmitting = false.obs;
  final RxString hydrationSubmitError = ''.obs;

  // Sport submission
  final RxBool isSportSubmitting = false.obs;
  final RxString sportSubmitError = ''.obs;

  // Sleep Tab Controllers
  late TimeController wakeUpController;
  late TimeController desiredSleepStartController;
  late TimeController desiredSleepEndController;
  late TimeController preferredTimeController;
  late TextEditingController durationController;
  late RangeSliderController sleepLastNightController;
  late RangeSliderController sleepGoalController;
  final RxString fatigueLevel = 'Low'.obs;

  // Nap management
  final RxList<Map<String, dynamic>> naps = <Map<String, dynamic>>[].obs;
  late TextEditingController currentNapDurationController;

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
  final RxDouble caffeine24hValue = 0.0.obs;
  final RxDouble caffeinMaxValue = 400.0.obs;
  final RxDouble caffeineLastEightHoursValue = 0.0.obs;
  late TimeController caffeineIntakeTimeController;
  late TextEditingController caffeineDrinkNameController;
  late TextEditingController caffeineDrinkTypeController;
  late TextEditingController caffeineAmountController;
  final RxList<Map<String, String>> caffeineHistory =
      <Map<String, String>>[].obs;

  // Caffeine Presets
  final RxList<CaffeinePreset> caffeinePresets = <CaffeinePreset>[].obs;
  final RxBool isCaffeinePresetsLoading = true.obs;
  final RxString caffeinePresetsError = ''.obs;

  // Caffeine Intake Submission
  final RxBool isCaffeineSubmitting = false.obs;
  final RxString caffeineSubmitError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchCalculatorSession();
    _initializeSleepControllers();
    _initializeWorkControllers();
    _initializeNutritionControllers();
    _initializeSportControllers();
    _initializeCaffeineControllers();
    _loadCaffeineHistory();
    _fetchCaffeinePresets();
  }

  Future<void> _fetchCalculatorSession() async {
    try {
      print('\n📋 _fetchCalculatorSession() CALLED');
      isSessionLoading.value = true;
      sessionError.value = '';

      final response = await _calculatorService.getCalculatorSession();
      print('✓ Response received: ${response.data}');
      print('  Session ID: ${response.data.sessionId}');
      print('  Completed Steps: ${response.data.completedSteps}');
      print('  Next Step: ${response.data.nextStep}');

      calculatorSession.value = response.data;
      print('✓ calculatorSession assigned: ${calculatorSession.value}');
      print(
        '✓ calculatorSession.value.sessionId: ${calculatorSession.value!.sessionId}',
      );
    } catch (e) {
      sessionError.value = e.toString();
      print('✗ Session error: $e');
      print('Stack trace: ${StackTrace.current}');
    } finally {
      isSessionLoading.value = false;
      print('✓ Session loading complete. IsLoading: ${isSessionLoading.value}');
    }
  }

  void _initializeSleepControllers() {
    wakeUpController = TimeController();
    desiredSleepStartController = TimeController();
    desiredSleepEndController = TimeController();
    preferredTimeController = TimeController();
    durationController = TextEditingController();
    currentNapDurationController = TextEditingController();
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
    caffeineDrinkNameController = TextEditingController();
    caffeineDrinkTypeController = TextEditingController();
    caffeineAmountController = TextEditingController();
    // Initialize with sample caffeine history
    caffeineHistory.assignAll([]);
  }

  void _loadCaffeineHistory() {}

  Future<void> _fetchCaffeinePresets() async {
    try {
      print('\n☕ _fetchCaffeinePresets() CALLED');
      isCaffeinePresetsLoading.value = true;
      caffeinePresetsError.value = '';

      final presets = await _calculatorService.getCaffeinePresets();
      print('✓ Caffeine presets received: ${presets.length} items');
      for (int i = 0; i < presets.length; i++) {
        print(
          '  Preset $i: label=${presets[i].label}, defaultMg=${presets[i].defaultMg}, drinkType=${presets[i].drinkType}',
        );
      }

      caffeinePresets.assignAll(presets);
      print(
        '✓ caffeinePresets assigned: ${caffeinePresets.length} items in list',
      );
    } catch (e) {
      caffeinePresetsError.value = e.toString();
      print('✗ Caffeine presets error: $e');
    } finally {
      isCaffeinePresetsLoading.value = false;
      print('✓ Caffeine presets loading complete');
    }
  }

  void addCaffeineIntake(String name, int mgAmount, String time) {
    caffeineHistory.add({'name': name, 'dose': '${mgAmount}mg', 'time': time});
    caffeine24hValue.value += mgAmount;
    caffeineLastEightHoursValue.value += mgAmount;
  }

  void resetAddCaffeineForm() {
    caffeineDrinkNameController.clear();
    caffeineDrinkTypeController.clear();
    caffeineAmountController.clear();
    caffeineIntakeTimeController.reset();
  }

  bool submitAddCaffeineForm() {
    final String drinkName = caffeineDrinkNameController.text.trim();
    final String drinkType = caffeineDrinkTypeController.text.trim();
    final int? amount = int.tryParse(caffeineAmountController.text.trim());

    if (drinkName.isEmpty ||
        drinkType.isEmpty ||
        amount == null ||
        amount <= 0) {
      return false;
    }

    addCaffeineIntake(
      '$drinkName (${drinkType})',
      amount,
      caffeineIntakeTimeController.to24HourFormat,
    );
    resetAddCaffeineForm();
    return true;
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

  Future<void> submitCaffeineIntake() async {
    print('\n☕ submitCaffeineIntake() CALLED');
    print(
      'DEBUG: calculatorSession.value?.sessionId = ${calculatorSession.value?.sessionId}',
    );

    try {
      if (calculatorSession.value == null ||
          calculatorSession.value!.sessionId == null) {
        print('✗ Session not initialized');
        caffeineSubmitError.value = 'Session not initialized';
        return;
      }

      print('✓ Session initialized: ${calculatorSession.value!.sessionId}');
      isCaffeineSubmitting.value = true;
      caffeineSubmitError.value = '';

      // Convert caffeineHistory to CaffeineIntake objects
      final List<CaffeineIntake> intakes = [];
      for (final entry in caffeineHistory) {
        final name = entry['name'] ?? '';
        final dose = entry['dose'] ?? '';
        var time = entry['time'] ?? '';

        // Parse dose (e.g., "75mg" -> 75)
        final amountMg = int.tryParse(dose.replaceAll('mg', '').trim()) ?? 0;

        // If time is "Now" or a 12-hour format, use TimeWidget time or format properly
        if (time == 'Now' || time.contains(RegExp(r'(AM|PM)'))) {
          time = caffeineIntakeTimeController.to24HourFormat;
        }

        // Try to find the drink type from presets
        String drinkType = 'COFFEE'; // default
        for (final preset in caffeinePresets) {
          if (preset.label.toLowerCase() == name.toLowerCase()) {
            drinkType = preset.drinkType;
            break;
          }
        }

        intakes.add(
          CaffeineIntake(
            amountMg: amountMg,
            consumedAt: time,
            drinkType: drinkType,
            drinkName: name,
          ),
        );
      }

      final request = CaffeineIntakeRequest(caffeineIntakes: intakes);

      print('=== Caffeine Intake Request ===');
      print('Request: ${request.toJson()}');
      print('===============================');

      final response = await _calculatorService.submitCaffeineIntake(
        calculatorSession.value!.sessionId!,
        request,
      );

      print('=== Caffeine Intake Response ===');
      print('Full Response: $response');
      print('Session ID: ${response.sessionId}');
      print('Message: ${response.message}');
      print('Next Step: ${response.nextStep}');
      print('Completed steps: ${response.completedSteps}');
      print('================================');

      print('✓ Caffeine intake submitted successfully');
      print('Next step: ${response.nextStep}');
      print('Session ID: ${response.sessionId}');
      print('Completed steps: ${response.completedSteps}');

      // Update session with response data
      calculatorSession.value = CalculatorSession(
        sessionId: response.sessionId,
        completedSteps: response.completedSteps,
        nextStep: response.nextStep,
        isFinalized: false,
        isReadyToCalculate: response.isReadyToCalculate,
        prefilled: false,
      );

      print('✓ Session updated');
      print('Navigating to Sport tab (index: 5)...');

      changeTab(5);

      print('✓ Navigation complete. Current tab: ${selectedTabIndex.value}');
    } catch (e) {
      print('✗ Caffeine intake submission error: $e');
      print('Stack trace: ${StackTrace.current}');
      caffeineSubmitError.value = e.toString();
    } finally {
      isCaffeineSubmitting.value = false;
      print(
        'Caffeine submission state: complete (loading=${isCaffeineSubmitting.value})',
      );
    }
  }

  Future<void> skipCaffeineIntake() async {
    print('\n☕ skipCaffeineIntake() CALLED');
    print(
      'DEBUG: calculatorSession.value?.sessionId = ${calculatorSession.value?.sessionId}',
    );

    try {
      if (calculatorSession.value == null ||
          calculatorSession.value!.sessionId == null) {
        print('✗ Session not initialized');
        caffeineSubmitError.value = 'Session not initialized';
        return;
      }

      print('✓ Session initialized: ${calculatorSession.value!.sessionId}');
      isCaffeineSubmitting.value = true;
      caffeineSubmitError.value = '';

      final response = await _calculatorService.skipCaffeineIntake(
        calculatorSession.value!.sessionId!,
      );

      print('=== Skip Caffeine Intake Response ===');
      print('Full Response: $response');
      print('Session ID: ${response.sessionId}');
      print('Message: ${response.message}');
      print('Next Step: ${response.nextStep}');
      print('Completed steps: ${response.completedSteps}');
      print('======================================');

      print('✓ Caffeine intake skipped successfully');
      print('Next step: ${response.nextStep}');
      print('Session ID: ${response.sessionId}');
      print('Completed steps: ${response.completedSteps}');

      // Update session with response data
      calculatorSession.value = CalculatorSession(
        sessionId: response.sessionId,
        completedSteps: response.completedSteps,
        nextStep: response.nextStep,
        isFinalized: false,
        isReadyToCalculate: response.isReadyToCalculate,
        prefilled: false,
      );

      print('✓ Session updated');
      print('Navigating to Sport tab (index: 5)...');

      changeTab(5);

      print('✓ Navigation complete. Current tab: ${selectedTabIndex.value}');
    } catch (e) {
      print('✗ Skip caffeine intake error: $e');
      print('Stack trace: ${StackTrace.current}');
      caffeineSubmitError.value = e.toString();
    } finally {
      isCaffeineSubmitting.value = false;
      print(
        'Skip caffeine state: complete (loading=${isCaffeineSubmitting.value})',
      );
    }
  }

  void selectShiftType(String shiftType) {
    selectedShiftType.value = shiftType;
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  Future<void> submitSleepData() async {
    print('\n🔵 submitSleepData() CALLED');
    print('DEBUG: calculatorSession.value = ${calculatorSession.value}');
    print(
      'DEBUG: calculatorSession.value?.sessionId = ${calculatorSession.value?.sessionId}',
    );
    print('DEBUG: isSessionLoading.value = ${isSessionLoading.value}');

    try {
      if (calculatorSession.value == null) {
        print('✗ calculatorSession.value is NULL');
        sleepSubmitError.value = 'Session not initialized (value is null)';
        return;
      }

      if (calculatorSession.value!.sessionId == null) {
        print('✗ calculatorSession.value.sessionId is NULL');
        sleepSubmitError.value = 'Session ID is null';
        return;
      }

      print('✓ Session initialized: ${calculatorSession.value!.sessionId}');
      isSleepSubmitting.value = true;
      sleepSubmitError.value = '';

      // Build nap list
      List<NapData> napList = [];
      for (int i = 0; i < naps.length; i++) {
        final nap = naps[i];
        napList.add(
          NapData(
            startTime: nap['preferredTime'] ?? '00:00',
            durationMin: int.tryParse(nap['duration'] ?? '0') ?? 0,
            order: i + 1,
          ),
        );
      }

      print('✓ Built nap list with ${napList.length} naps');

      // Build request
      final request = SleepCalculatorRequest(
        wakeUpTime: wakeUpController.to24HourFormat,
        sleepHours: sleepLastNightController.value.value,
        desiredSleepHours: sleepGoalController.value.value,
        fatigueLevel: fatigueLevel.value.toUpperCase(),
        desiredSleepStart: desiredSleepStartController.to24HourFormat,
        desiredWakeTime: desiredSleepEndController.to24HourFormat,
        naps: napList,
      );

      print('=== Sleep Data Request ===');
      print('Request: ${request.toJson()}');
      print('==========================');

      final response = await _calculatorService.submitSleepData(
        calculatorSession.value!.sessionId!,
        request,
      );

      print('=== Sleep Submission Response ===');
      print('Full Response: $response');
      print('Success: ${response.success}');
      print('Message: ${response.message}');
      print('Data: ${response.data}');
      print('==================================');

      if (response.success && response.data != null) {
        print('✓ Sleep submission successful');
        print('Next step: ${response.data!.nextStep}');
        print('Session ID: ${response.data!.sessionId}');
        print('Completed steps: ${response.data!.completedSteps}');

        // Update session with response data
        calculatorSession.value = CalculatorSession(
          sessionId: response.data!.sessionId,
          completedSteps: response.data!.completedSteps,
          nextStep: response.data!.nextStep,
          isFinalized: false,
          isReadyToCalculate: response.data!.isReadyToCalculate,
          prefilled: false,
        );

        print('✓ Session updated');
        print('Navigating to Work tab (index: 1)...');

        // Navigate to next tab (work tab)
        changeTab(1);

        print('✓ Navigation complete. Current tab: ${selectedTabIndex.value}');
      } else {
        print('✗ Sleep submission failed');
        print('Error message: ${response.message}');
        sleepSubmitError.value = response.message;
      }
    } catch (e) {
      print('✗ Sleep submission error: $e');
      print('Stack trace: ${StackTrace.current}');
      sleepSubmitError.value = e.toString();
    } finally {
      isSleepSubmitting.value = false;
      print(
        'Sleep submission state: complete (loading=${isSleepSubmitting.value})',
      );
    }
  }

  Future<void> submitWorkData() async {
    print('\n🔵 submitWorkData() CALLED');
    print('DEBUG: calculatorSession.value = ${calculatorSession.value}');
    print(
      'DEBUG: calculatorSession.value?.sessionId = ${calculatorSession.value?.sessionId}',
    );

    try {
      if (calculatorSession.value == null) {
        print('✗ calculatorSession.value is NULL');
        workSubmitError.value = 'Session not initialized (value is null)';
        return;
      }

      if (calculatorSession.value!.sessionId == null) {
        print('✗ calculatorSession.value.sessionId is NULL');
        workSubmitError.value = 'Session ID is null';
        return;
      }

      print('✓ Session initialized: ${calculatorSession.value!.sessionId}');
      isWorkSubmitting.value = true;
      workSubmitError.value = '';

      final request = WorkCalculatorRequest(
        shiftStart: workBeginsController.to24HourFormat,
        shiftEnd: workCompleteController.to24HourFormat,
        daysWorked: int.tryParse(daysWorkedController.text) ?? 1,
        shiftType: selectedShiftType.value.toUpperCase(),
      );

      print('=== Work Data Request ===');
      print('Request: ${request.toJson()}');
      print('========================');

      final response = await _calculatorService.submitWorkData(
        calculatorSession.value!.sessionId!,
        request,
      );

      print('=== Work Submission Response ===');
      print('Full Response: $response');
      print('Success: ${response.success}');
      print('Message: ${response.message}');
      print('Data: ${response.data}');
      print('=================================');

      if (response.success && response.data != null) {
        print('✓ Work submission successful');
        print('Next step: ${response.data!.nextStep}');
        print('Session ID: ${response.data!.sessionId}');
        print('Completed steps: ${response.data!.completedSteps}');

        // Update session with response data
        calculatorSession.value = CalculatorSession(
          sessionId: response.data!.sessionId,
          completedSteps: response.data!.completedSteps,
          nextStep: response.data!.nextStep,
          isFinalized: false,
          isReadyToCalculate: response.data!.isReadyToCalculate,
          prefilled: false,
        );

        print('✓ Session updated');
        print('Navigating to Nutrition tab (index: 2)...');

        // Navigate to next tab (nutrition tab)
        changeTab(2);

        print('✓ Navigation complete. Current tab: ${selectedTabIndex.value}');
      } else {
        print('✗ Work submission failed');
        print('Error message: ${response.message}');
        workSubmitError.value = response.message;
      }
    } catch (e) {
      print('✗ Work submission error: $e');
      print('Stack trace: ${StackTrace.current}');
      workSubmitError.value = e.toString();
    } finally {
      isWorkSubmitting.value = false;
      print(
        'Work submission state: complete (loading=${isWorkSubmitting.value})',
      );
    }
  }

  Future<void> skipWorkData() async {
    print('\n⏭️ skipWorkData() CALLED');
    print(
      'DEBUG: calculatorSession.value?.sessionId = ${calculatorSession.value?.sessionId}',
    );

    try {
      if (calculatorSession.value == null ||
          calculatorSession.value!.sessionId == null) {
        print('✗ Session not initialized');
        workSubmitError.value = 'Session not initialized';
        return;
      }

      print('✓ Session initialized: ${calculatorSession.value!.sessionId}');
      isWorkSubmitting.value = true;
      workSubmitError.value = '';

      final response = await _calculatorService.skipWorkData(
        calculatorSession.value!.sessionId!,
      );

      print('=== Skip Work Response ===');
      print('Full Response: $response');
      print('Success: ${response.success}');
      print('Message: ${response.message}');
      print('Data: ${response.data}');
      print('==========================');

      if (response.success && response.data != null) {
        print('✓ Work skipped successfully');
        print('Next step: ${response.data!.nextStep}');
        print('Session ID: ${response.data!.sessionId}');

        // Update session with response data
        calculatorSession.value = CalculatorSession(
          sessionId: response.data!.sessionId,
          completedSteps: response.data!.completedSteps,
          nextStep: response.data!.nextStep,
          isFinalized: false,
          isReadyToCalculate: response.data!.isReadyToCalculate,
          prefilled: false,
        );

        print('✓ Session updated');
        print('Navigating to Nutrition tab (index: 2)...');

        // Navigate to next tab (nutrition tab)
        changeTab(2);

        print('✓ Navigation complete. Current tab: ${selectedTabIndex.value}');
      } else {
        print('✗ Skip work failed');
        print('Error message: ${response.message}');
        workSubmitError.value = response.message;
      }
    } catch (e) {
      print('✗ Skip work error: $e');
      print('Stack trace: ${StackTrace.current}');
      workSubmitError.value = e.toString();
    } finally {
      isWorkSubmitting.value = false;
      print('Skip work state: complete (loading=${isWorkSubmitting.value})');
    }
  }

  Future<void> submitNutritionData() async {
    print('\n🔵 submitNutritionData() CALLED');
    print(
      'DEBUG: calculatorSession.value?.sessionId = ${calculatorSession.value?.sessionId}',
    );

    try {
      if (calculatorSession.value == null ||
          calculatorSession.value!.sessionId == null) {
        print('✗ Session not initialized');
        nutritionSubmitError.value = 'Session not initialized';
        return;
      }

      print('✓ Session initialized: ${calculatorSession.value!.sessionId}');
      isNutritionSubmitting.value = true;
      nutritionSubmitError.value = '';

      // Convert Yes/No to boolean
      final hadMealToday = hasMealTodaySelection.value == 'Yes';

      final request = NutritionCalculatorRequest(
        mealsPerDay: desiredNumberOfMealsController.value.value.toInt(),
        hadMealToday: hadMealToday,
        desiredMealCount: desiredNumberOfMealsController.value.value.toInt(),
        firstMealTime: firstMealTimeController.to24HourFormat,
        lastMealTime: lastMealTimeController.to24HourFormat,
      );

      print('=== Nutrition Data Request ===');
      print('Request: ${request.toJson()}');
      print('==============================');

      final response = await _calculatorService.submitNutritionData(
        calculatorSession.value!.sessionId!,
        request,
      );

      print('=== Nutrition Submission Response ===');
      print('Full Response: $response');
      print('Success: ${response.success}');
      print('Message: ${response.message}');
      print('Data: ${response.data}');
      print('======================================');

      if (response.success && response.data != null) {
        print('✓ Nutrition submission successful');
        print('Next step: ${response.data!.nextStep}');
        print('Session ID: ${response.data!.sessionId}');
        print('Completed steps: ${response.data!.completedSteps}');

        // Update session with response data
        calculatorSession.value = CalculatorSession(
          sessionId: response.data!.sessionId,
          completedSteps: response.data!.completedSteps,
          nextStep: response.data!.nextStep,
          isFinalized: false,
          isReadyToCalculate: response.data!.isReadyToCalculate,
          prefilled: false,
        );

        print('✓ Session updated');
        print('Navigating to Hydration tab (index: 3)...');

        // Navigate to next tab (hydration tab)
        changeTab(3);

        print('✓ Navigation complete. Current tab: ${selectedTabIndex.value}');
      } else {
        print('✗ Nutrition submission failed');
        print('Error message: ${response.message}');
        nutritionSubmitError.value = response.message;
      }
    } catch (e) {
      print('✗ Nutrition submission error: $e');
      print('Stack trace: ${StackTrace.current}');
      nutritionSubmitError.value = e.toString();
    } finally {
      isNutritionSubmitting.value = false;
      print(
        'Nutrition submission state: complete (loading=${isNutritionSubmitting.value})',
      );
    }
  }

  Future<void> submitHydrationData() async {
    print('\n🔵 submitHydrationData() CALLED');
    print(
      'DEBUG: calculatorSession.value?.sessionId = ${calculatorSession.value?.sessionId}',
    );

    try {
      if (calculatorSession.value == null ||
          calculatorSession.value!.sessionId == null) {
        print('✗ Session not initialized');
        hydrationSubmitError.value = 'Session not initialized';
        return;
      }

      print('✓ Session initialized: ${calculatorSession.value!.sessionId}');
      isHydrationSubmitting.value = true;
      hydrationSubmitError.value = '';

      final request = HydrationCalculatorRequest(
        waterConsumedL: hydrationConsumedController.value.value,
        waterGoalL: hydrationDailyGoalController.value.value,
      );

      print('=== Hydration Data Request ===');
      print('Request: ${request.toJson()}');
      print('==============================');

      final response = await _calculatorService.submitHydrationData(
        calculatorSession.value!.sessionId!,
        request,
      );

      print('=== Hydration Submission Response ===');
      print('Full Response: $response');
      print('Success: ${response.success}');
      print('Message: ${response.message}');
      print('Data: ${response.data}');
      print('====================================');

      if (response.success) {
        print('✓ Hydration submission successful');

        final currentSession = calculatorSession.value!;
        final completedSteps = response.data?.completedSteps.isNotEmpty == true
            ? response.data!.completedSteps
            : [
                ...currentSession.completedSteps,
                if (!currentSession.completedSteps.contains('hydration'))
                  'hydration',
              ];
        final nextStep = response.data?.nextStep.isNotEmpty == true
            ? response.data!.nextStep
            : 'caffeine';
        final sessionId = response.data?.sessionId.isNotEmpty == true
            ? response.data!.sessionId
            : currentSession.sessionId!;

        print('Next step: $nextStep');
        print('Session ID: $sessionId');
        print('Completed steps: $completedSteps');

        calculatorSession.value = CalculatorSession(
          sessionId: sessionId,
          completedSteps: completedSteps,
          nextStep: nextStep,
          isFinalized: false,
          isReadyToCalculate: response.data?.isReadyToCalculate ?? false,
          prefilled: false,
        );

        print('✓ Session updated');
        print('Navigating to Caffeine tab (index: 4)...');

        changeTab(4);

        print('✓ Navigation complete. Current tab: ${selectedTabIndex.value}');
      } else {
        print('✗ Hydration submission failed');
        print('Error message: ${response.message}');
        hydrationSubmitError.value = response.message;
      }
    } catch (e) {
      print('✗ Hydration submission error: $e');
      print('Stack trace: ${StackTrace.current}');
      hydrationSubmitError.value = e.toString();
    } finally {
      isHydrationSubmitting.value = false;
      print(
        'Hydration submission state: complete (loading=${isHydrationSubmitting.value})',
      );
    }
  }

  void selectActivityType(String activityType) {
    selectedActivityType.value = activityType;
  }

  void setSportIntensity(double intensity) {
    sportIntensity.value = intensity;
  }

  // Nap management methods
  void addNap(String duration, String preferredTime) {
    if (duration.isNotEmpty && preferredTime.isNotEmpty) {
      naps.add({
        'duration': duration,
        'preferredTime': preferredTime,
        'napNumber': naps.length + 1,
      });
      // Clear inputs after adding
      currentNapDurationController.clear();
      preferredTimeController.reset();
    }
  }

  void removeNap(int index) {
    if (index >= 0 && index < naps.length) {
      naps.removeAt(index);
    }
  }

  void clearAllNaps() {
    naps.clear();
    currentNapDurationController.clear();
  }

  Future<void> submitSportData() async {
    print('\n⚽ submitSportData() CALLED');
    print(
      'DEBUG: calculatorSession.value?.sessionId = ${calculatorSession.value?.sessionId}',
    );

    try {
      if (calculatorSession.value == null ||
          calculatorSession.value!.sessionId == null) {
        print('✗ Session not initialized');
        sportSubmitError.value = 'Session not initialized';
        return;
      }

      // Validate inputs
      if (sportDurationController.text.isEmpty) {
        print('✗ Activity duration not provided');
        sportSubmitError.value = 'Please enter activity duration';
        return;
      }

      if (selectedActivityType.value.isEmpty) {
        print('✗ Activity type not selected');
        sportSubmitError.value = 'Please select an activity type';
        return;
      }

      print('✓ Session initialized: ${calculatorSession.value!.sessionId}');
      isSportSubmitting.value = true;
      sportSubmitError.value = '';

      // Parse activity duration
      final int activityDuration =
          int.tryParse(sportDurationController.text) ?? 0;
      if (activityDuration <= 0) {
        throw Exception('Invalid activity duration');
      }

      // Map activity type to API format using enum
      final ActivityType selectedActivityEnum = ActivityType.fromDisplayName(
        selectedActivityType.value,
      );
      final String activityTypeApi = selectedActivityEnum.apiValue;

      // Map intensity to API format (0=LIGHT, 1=MODERATE, 2=HARD)
      String activityIntensity = 'LIGHT';
      if (sportIntensity.value == 1.0) {
        activityIntensity = 'MODERATE';
      } else if (sportIntensity.value == 2.0) {
        activityIntensity = 'HARD';
      }

      // Get current time in HH:MM format
      final now = DateTime.now();
      final activityTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      final request = SportRequest(
        activityDuration: activityDuration,
        activityType: activityTypeApi,
        activityIntensity: activityIntensity,
        activityTime: activityTime,
      );

      print('=== Sport Activity Request ===');
      print('Request: ${request.toJson()}');
      print('================================');

      final response = await _calculatorService.submitSportData(
        calculatorSession.value!.sessionId!,
        request,
      );

      print('=== Sport Activity Response ===');
      print('Full Response: $response');
      print('Session ID: ${response.sessionId}');
      print('Message: ${response.message}');
      print('Next Step: ${response.nextStep}');
      print('Completed steps: ${response.completedSteps}');
      print('Is Ready To Calculate: ${response.isReadyToCalculate}');
      print('================================');

      print('✓ Sport activity submitted successfully');
      print('Next step: ${response.nextStep}');
      print('Session ID: ${response.sessionId}');
      print('Ready to calculate: ${response.isReadyToCalculate}');

      // Update session with response data
      calculatorSession.value = CalculatorSession(
        sessionId: response.sessionId,
        completedSteps: response.completedSteps,
        nextStep: response.nextStep,
        isFinalized: false,
        isReadyToCalculate: response.isReadyToCalculate,
        prefilled: false,
      );

      print('✓ Session updated');
    } catch (e) {
      print('✗ Sport activity submission error: $e');
      print('Stack trace: ${StackTrace.current}');
      sportSubmitError.value = e.toString();
    } finally {
      isSportSubmitting.value = false;
      print(
        'Sport submission state: complete (loading=${isSportSubmitting.value})',
      );
    }
  }

  @override
  void onClose() {
    durationController.dispose();
    currentNapDurationController.dispose();
    daysWorkedController.dispose();
    sportDurationController.dispose();
    caffeineDrinkNameController.dispose();
    caffeineDrinkTypeController.dispose();
    caffeineAmountController.dispose();
    caffeineIntakeTimeController.dispose();
    super.onClose();
  }
}
