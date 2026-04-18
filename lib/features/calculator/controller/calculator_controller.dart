import 'package:get/state_manager.dart';

class CalculatorController extends GetxController {
  final tabs = ['Sleep', 'Work', 'Nutrition', 'Hydration', 'Caffeine', 'Sport'];

  final selectedTabIndex = 0.obs;

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
