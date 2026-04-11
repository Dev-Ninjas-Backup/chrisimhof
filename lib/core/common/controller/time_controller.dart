import 'package:get/get.dart';

class TimeController extends GetxController {
  final RxInt hour = 6.obs;
  final RxInt minute = 11.obs;
  final RxString period = 'PM'.obs;

  void increaseHour() {
    hour.value = hour.value == 12 ? 1 : hour.value + 1;
  }

  void decreaseHour() {
    hour.value = hour.value == 1 ? 12 : hour.value - 1;
  }

  void increaseMinute() {
    minute.value = minute.value == 59 ? 0 : minute.value + 1;
  }

  void decreaseMinute() {
    minute.value = minute.value == 0 ? 59 : minute.value - 1;
  }

  void togglePeriod() {
    period.value = period.value == 'AM' ? 'PM' : 'AM';
  }

  String get formattedHour => hour.value.toString().padLeft(2, '0');
  String get formattedMinute => minute.value.toString().padLeft(2, '0');
}
