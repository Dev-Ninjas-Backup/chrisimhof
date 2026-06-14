import 'package:get/get.dart';

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

  final RxList<MealItem> mealsList = <MealItem>[
    MealItem(name: 'Meal 1', time: '07:30', type: 'Light', isLogged: true, isPlanned: false),
    MealItem(name: 'Meal 2', time: '12:00', type: 'Medium', isLogged: true, isPlanned: false),
    MealItem(name: 'Snack', time: '15:30', type: 'Light', isLogged: true, isPlanned: false),
    MealItem(name: 'Pre-shift meal', time: '19:00', type: 'Medium', isLogged: false, isPlanned: true),
    MealItem(name: 'Night meal', time: '02:00', type: 'Light', isLogged: false, isPlanned: true),
  ].obs;

  final RxList<String> notesList = <String>[
    'Energy dip around 14:00 — try logging the snack 30 min earlier tomorrow.'
  ].obs;

  int get loggedMealsCount => mealsList.where((m) => m.isLogged).length;

  void selectMealType(String type) {
    selectedMealType.value = type;
  }

  void incrementTarget() {
    dailyTarget.value++;
    // Add a planned meal for the new target slot
    final newIndex = mealsList.length + 1;
    // Calculate a dummy planned time based on previous items or simple pattern
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
  }

  void decrementTarget() {
    if (dailyTarget.value > 1) {
      dailyTarget.value--;
      // Try to remove the last unlogged meal
      int lastUnloggedIdx = mealsList.lastIndexWhere((m) => !m.isLogged);
      if (lastUnloggedIdx != -1) {
        mealsList.removeAt(lastUnloggedIdx);
      } else {
        // If all are logged, remove the last one anyway
        mealsList.removeLast();
      }
    }
  }

  void saveMeal() {
    // Find the first unlogged planned meal
    int firstUnloggedIdx = mealsList.indexWhere((m) => !m.isLogged);
    
    // Get current time formatted as HH:mm
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
      // If no unlogged meals exist, append a new one
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
  }

  void addNote(String note) {
    if (note.trim().isNotEmpty) {
      notesList.add(note.trim());
    }
  }
}