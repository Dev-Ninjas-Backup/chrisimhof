import 'package:chrisimhof/core/common/controller/range_slider_controller.dart';
import 'package:chrisimhof/core/common/controller/time_controller.dart';
import 'package:chrisimhof/features/calculator/models/calculator_session_model.dart';
import 'package:chrisimhof/features/calculator/models/hydration_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/sleep_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/work_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/nutrition_calculator_model.dart';
import 'package:chrisimhof/features/calculator/results/model/calculator_results_model.dart';
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
  late TextEditingController caffeineDrinkNameController;
  late TextEditingController caffeineDrinkTypeController;
  late TextEditingController caffeineAmountController;
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
    caffeineDrinkNameController = TextEditingController();
    caffeineDrinkTypeController = TextEditingController();
    caffeineAmountController = TextEditingController();
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
      caffeineIntakeTimeController.formattedTime,
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

  CalculatorResultsData buildResultsData() {
    final int sleepScore = _calculateSleepScore();
    final int hydrationScore = _calculateHydrationScore();
    final int caffeineScore = _calculateCaffeineScore();
    final int nutritionScore = _calculateNutritionScore();
    final int sportScore = _calculateSportScore();

    final List<int> scores = [
      sleepScore,
      hydrationScore,
      caffeineScore,
      nutritionScore,
      sportScore,
    ];

    final int overallScore =
        scores.reduce((total, score) => total + score) ~/ scores.length;

    return CalculatorResultsData(
      overallScore: overallScore,
      overallLabel: _overallLabelFor(overallScore),
      metrics: [
        CalculatorResultMetric(
          title: 'Sleep',
          score: sleepScore,
          detail: _sleepDetailText(),
          iconKey: 'sleep',
        ),
        CalculatorResultMetric(
          title: 'Hydration',
          score: hydrationScore,
          detail: _hydrationDetailText(),
          iconKey: 'hydration',
        ),
        CalculatorResultMetric(
          title: 'Caffeine',
          score: caffeineScore,
          detail: '${caffeine24hValue.value.toInt()}mg today',
          iconKey: 'caffeine',
        ),
        CalculatorResultMetric(
          title: 'Nutrition',
          score: nutritionScore,
          detail: _nutritionDetailText(),
          iconKey: 'nutrition',
        ),
      ],
      recommendations: [
        CalculatorRecommendation(
          title: 'Recommendations of the day',
          headline: 'Nutrition',
          description: _nutritionRecommendationText(),
          iconKey: 'nutrition',
        ),
        CalculatorRecommendation(
          title: 'Caffeine',
          headline: 'Caffeine',
          description: _caffeineRecommendationText(),
          iconKey: 'caffeine',
        ),
        CalculatorRecommendation(
          title: 'Sport',
          headline: 'Sport',
          description: _sportRecommendationText(sportScore),
          iconKey: 'sport',
        ),
      ],
    );
  }

  int _calculateSleepScore() {
    final double sleptHours = sleepLastNightController.value.value;
    final double goalHours = sleepGoalController.value.value;
    if (goalHours <= 0) {
      return 0;
    }

    return ((sleptHours / goalHours) * 100).round().clamp(0, 100);
  }

  int _calculateHydrationScore() {
    final double consumed = hydrationConsumedController.value.value;
    final double goal = hydrationDailyGoalController.value.value;
    if (goal <= 0) {
      return 0;
    }

    return ((consumed / goal) * 100).round().clamp(0, 100);
  }

  int _calculateCaffeineScore() {
    final double max = caffeinMaxValue.value;
    if (max <= 0) {
      return 0;
    }

    final double ratio = 1 - (caffeine24hValue.value / max);
    return (ratio * 100).round().clamp(0, 100);
  }

  int _calculateNutritionScore() {
    final int desiredMeals = desiredNumberOfMealsController.value.value
        .toInt()
        .clamp(1, 10);
    final int baseScore = hasMealTodaySelection.value == 'Yes' ? 70 : 45;
    final int mealBonus = (desiredMeals * 7).clamp(0, 30);
    return (baseScore + mealBonus).clamp(0, 100);
  }

  int _calculateSportScore() {
    final int duration = int.tryParse(sportDurationController.text.trim()) ?? 0;
    final int durationScore = (duration * 2).clamp(0, 70);
    final int intensityScore = (sportIntensity.value * 30).round().clamp(0, 30);
    return (durationScore + intensityScore).clamp(0, 100);
  }

  String _overallLabelFor(int score) {
    if (score >= 85) {
      return 'Excellent level';
    }
    if (score >= 70) {
      return 'Good level';
    }
    if (score >= 50) {
      return 'Fair level';
    }
    return 'Needs support';
  }

  String _sleepDetailText() {
    final double slept = sleepLastNightController.value.value;
    final double goal = sleepGoalController.value.value;
    final double debt = (goal - slept).clamp(0, goal);
    return '${slept.toStringAsFixed(0)}h slept / ${debt.toStringAsFixed(0)}h debt';
  }

  String _hydrationDetailText() {
    return '${hydrationConsumedController.value.value.toStringAsFixed(1)}L / ${hydrationDailyGoalController.value.value.toStringAsFixed(1)}L';
  }

  String _nutritionDetailText() {
    final String mealState = hasMealTodaySelection.value == 'Yes'
        ? 'Meal logged'
        : 'No meal yet';
    return '$mealState • ${desiredNumberOfMealsController.value.value.toInt()} meals';
  }

  String _nutritionRecommendationText() {
    if (hasMealTodaySelection.value == 'Yes') {
      return 'Keep your meals light and balanced tonight, and spread protein and carbs evenly across ${desiredNumberOfMealsController.value.value.toInt()} meals.';
    }

    return 'Plan a simple meal soon with protein, easy carbs, and enough fiber so your energy stays stable through the day.';
  }

  String _caffeineRecommendationText() {
    if (caffeine24hValue.value >= caffeinMaxValue.value) {
      return 'Your caffeine is already at the daily limit, so avoid more intake and shift to water for the rest of the day.';
    }

    return 'Moderate caffeine intake looks manageable. Try to stop around ${caffeineIntakeTimeController.formattedTime} to better protect your sleep.';
  }

  String _sportRecommendationText(int sportScore) {
    final int duration = int.tryParse(sportDurationController.text.trim()) ?? 0;
    final String activity = selectedActivityType.value.isEmpty
        ? 'movement'
        : selectedActivityType.value.toLowerCase();

    if (sportScore >= 75) {
      return 'Your $activity plan looks strong. Keep the ${sportIntensity.value.toStringAsFixed(1)} intensity and allow time to recover after ${duration} minutes.';
    }

    return 'Add a little more $activity today or increase intensity slightly so you build toward a stronger activity score.';
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
    caffeineDrinkNameController.dispose();
    caffeineDrinkTypeController.dispose();
    caffeineAmountController.dispose();
    caffeineIntakeTimeController.dispose();
    super.onClose();
  }
}
