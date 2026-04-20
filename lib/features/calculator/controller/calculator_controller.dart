import 'package:chrisimhof/core/common/controller/range_slider_controller.dart';
import 'package:chrisimhof/core/common/controller/time_controller.dart';
import 'package:chrisimhof/features/calculator/models/calculator_session_model.dart';
import 'package:chrisimhof/features/calculator/models/sleep_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/work_calculator_model.dart';
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
  final RxDouble caffeine24hValue = 180.0.obs;
  final RxDouble caffeinMaxValue = 400.0.obs;
  final RxDouble caffeineLastEightHoursValue = 110.0.obs;
  late TimeController caffeineIntakeTimeController;
  final RxList<Map<String, String>> caffeineHistory =
      <Map<String, String>>[].obs;

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
    // Initialize with sample caffeine history
    caffeineHistory.assignAll([
      {'name': 'Coffee', 'dose': '100mg', 'time': '06:11 PM'},
      {'name': 'Espresso', 'dose': '75mg', 'time': '02:45 PM'},
    ]);
  }

  void _loadCaffeineHistory() {}

  void addCaffeineIntake(String name, int mgAmount, String time) {
    caffeineHistory.add({'name': name, 'dose': '${mgAmount}mg', 'time': time});
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

  @override
  void onClose() {
    durationController.dispose();
    currentNapDurationController.dispose();
    daysWorkedController.dispose();
    sportDurationController.dispose();
    caffeineIntakeTimeController.dispose();
    super.onClose();
  }
}
