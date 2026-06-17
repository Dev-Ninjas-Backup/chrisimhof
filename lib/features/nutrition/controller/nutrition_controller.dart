import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';

class MealItem {
  final String name;
  final String time;
  final String type; // 'Light', 'Medium', 'Heavy'
  final bool isLogged;
  final bool isPlanned;

  MealItem({
    required this.name,
    required this.time,
    required this.type,
    required this.isLogged,
    required this.isPlanned,
  });

  MealItem copyWith({
    String? name,
    String? time,
    String? type,
    bool? isLogged,
    bool? isPlanned,
  }) {
    return MealItem(
      name: name ?? this.name,
      time: time ?? this.time,
      type: type ?? this.type,
      isLogged: isLogged ?? this.isLogged,
      isPlanned: isPlanned ?? this.isPlanned,
    );
  }
}

class NutritionController extends GetxController {
  final RxInt dailyTarget = 5.obs;
  final RxString selectedMealType = 'Light'.obs;

  final RxList<MealItem> mealsList = <MealItem>[].obs;

  final RxList<String> notesList = <String>[].obs;

  int get loggedMealsCount => mealsList.where((m) => m.isLogged).length;

  @override
  void onInit() {
    super.onInit();
    loadNutritionData();
  }

  Future<void> loadNutritionData() async {
    try {
      final jsonStr = await SharedPreferencesHelper.getMeals();
      if (jsonStr != null) {
        final Map<String, dynamic> data = jsonDecode(jsonStr);
        dailyTarget.value = data['dailyTarget'] ?? 5;
        final List mealsJson = data['meals'] ?? [];
        mealsList.assignAll(mealsJson.map((m) => MealItem(
          name: m['name'] ?? '',
          time: m['time'] ?? '',
          type: m['type'] ?? 'Light',
          isLogged: m['isLogged'] ?? false,
          isPlanned: m['isPlanned'] ?? false,
        )).toList());
      } else {
        // No saved data — start empty and persist empty state
        await saveNutritionData();
      }

      final notes = await SharedPreferencesHelper.getNutritionNotes();
      if (notes != null) {
        notesList.assignAll(notes);
      }
      // No hardcoded notes — notes start empty if none saved
    } catch (e) {
      debugPrint('Error loading nutrition data: $e');
    }
  }

  Future<void> saveNutritionData() async {
    try {
      final Map<String, dynamic> data = {
        'dailyTarget': dailyTarget.value,
        'meals': mealsList.map((m) => {
          'name': m.name,
          'time': m.time,
          'type': m.type,
          'isLogged': m.isLogged,
          'isPlanned': m.isPlanned,
        }).toList(),
      };
      await SharedPreferencesHelper.saveMeals(jsonEncode(data));
      await SharedPreferencesHelper.saveNutritionNotes(notesList);

      try {
        final dashboardController = Get.find<DashboardController>();
        await dashboardController.fetchDashboardData();
      } catch (_) {}
    } catch (e) {
      debugPrint('Error saving nutrition data: $e');
    }
  }

  void selectMealType(String type) {
    selectedMealType.value = type;
  }

  void incrementTarget() async {
    dailyTarget.value++;
    final newIndex = mealsList.length + 1;
    String nextTime = '22:00';
    if (mealsList.isNotEmpty) {
      final lastTimeStr = mealsList.last.time.split(' ')[0];
      final timeParts = lastTimeStr.split(':');
      if (timeParts.length == 2) {
        int hour = int.tryParse(timeParts[0]) ?? 22;
        int minute = int.tryParse(timeParts[1]) ?? 0;
        hour = (hour + 3) % 24;
        nextTime = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      }
    }
    mealsList.add(
      MealItem(
        name: 'Meal $newIndex',
        time: nextTime,
        type: 'Light',
        isLogged: false,
        isPlanned: true,
      ),
    );
    await saveNutritionData();
  }

  void decrementTarget() async {
    if (dailyTarget.value > 1) {
      dailyTarget.value--;
      int lastUnloggedIdx = mealsList.lastIndexWhere((m) => !m.isLogged);
      if (lastUnloggedIdx != -1) {
        mealsList.removeAt(lastUnloggedIdx);
      } else {
        mealsList.removeLast();
      }
      await saveNutritionData();
    }
  }

  void saveMeal() async {
    int firstUnloggedIdx = mealsList.indexWhere((m) => !m.isLogged);
    final now = DateTime.now();
    final formattedTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    if (firstUnloggedIdx != -1) {
      final oldMeal = mealsList[firstUnloggedIdx];
      mealsList[firstUnloggedIdx] = oldMeal.copyWith(
        type: selectedMealType.value,
        isLogged: true,
        isPlanned: false,
        time: formattedTime,
      );
    } else {
      final newIndex = mealsList.length + 1;
      mealsList.add(
        MealItem(
          name: 'Meal $newIndex',
          time: formattedTime,
          type: selectedMealType.value,
          isLogged: true,
          isPlanned: false,
        ),
      );
    }
    await saveNutritionData();
  }

  void addNote(String note) async {
    if (note.trim().isNotEmpty) {
      notesList.add(note.trim());
      await saveNutritionData();
    }
  }
}