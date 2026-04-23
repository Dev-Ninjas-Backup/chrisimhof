import 'package:get/get.dart';

class TimeController extends GetxController {
  // store hour in 24-hour format (0-23). default was 6 PM previously so use 18
  final RxInt hour = 18.obs;
  final RxInt minute = 11.obs;
  final RxString period = 'PM'.obs;

  // accumulators for drag-based scrolling (handled from UI via controller)
  double _hourDragAcc = 0.0;
  double _minuteDragAcc = 0.0;
  static const double _dragThreshold = 20.0;

  void increaseHour() {
    hour.value = (hour.value + 1) % 24;
    period.value = hour.value >= 12 ? 'PM' : 'AM';
  }

  void decreaseHour() {
    hour.value = (hour.value - 1 + 24) % 24;
    period.value = hour.value >= 12 ? 'PM' : 'AM';
  }

  void increaseMinute() {
    if (minute.value == 59) {
      minute.value = 0;
      increaseHour();
    } else {
      minute.value = minute.value + 1;
    }
  }

  void decreaseMinute() {
    if (minute.value == 0) {
      minute.value = 59;
      decreaseHour();
    } else {
      minute.value = minute.value - 1;
    }
  }

  void togglePeriod() {
    // convert between AM/PM by adding/subtracting 12 hours
    hour.value = (hour.value + 12) % 24;
    period.value = hour.value >= 12 ? 'PM' : 'AM';
  }

  // Called by UI when the user drags the hour column. `dy` is details.delta.dy
  void handleHourDrag(double dy) {
    _hourDragAcc += dy;
    if (_hourDragAcc.abs() >= _dragThreshold) {
      if (_hourDragAcc < 0) {
        increaseHour();
      } else {
        decreaseHour();
      }
      _hourDragAcc = 0.0;
    }
  }

  void handleHourDragEnd() {
    _hourDragAcc = 0.0;
  }

  // Called by UI when the user drags the minute column. `dy` is details.delta.dy
  void handleMinuteDrag(double dy) {
    _minuteDragAcc += dy;
    if (_minuteDragAcc.abs() >= _dragThreshold) {
      if (_minuteDragAcc < 0) {
        increaseMinute();
      } else {
        decreaseMinute();
      }
      _minuteDragAcc = 0.0;
    }
  }

  void handleMinuteDragEnd() {
    _minuteDragAcc = 0.0;
  }

  String get formattedHour => hour.value.toString().padLeft(2, '0');
  String get formattedMinute => minute.value.toString().padLeft(2, '0');
  String get formattedTime => '$formattedHour:$formattedMinute';

  String get to24HourFormat => formattedTime;

  void reset() {
    hour.value = 18;
    minute.value = 11;
    period.value = 'PM';
  }
}
