import 'dart:async';
import 'dart:math' as math;
import 'package:get/get.dart';

class CircadianController extends GetxController {
  final DateTime? customTime;

  CircadianController({this.customTime});

  final Rx<DateTime> currentTime = DateTime.now().obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    currentTime.value = customTime ?? DateTime.now();
    if (customTime == null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        currentTime.value = DateTime.now();
      });
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  double get hours =>
      currentTime.value.hour +
      (currentTime.value.minute / 60.0) +
      (currentTime.value.second / 3600.0);

  double get sunAngle => (math.pi / 2) + (hours / 24.0) * 2 * math.pi;

  double get moonAngle => sunAngle + math.pi;
}
