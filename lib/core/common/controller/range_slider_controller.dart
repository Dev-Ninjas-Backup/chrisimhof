import 'package:get/get.dart';

class RangeSliderController extends GetxController {
  final RxDouble value = 0.0.obs;
  final double min;
  final double max;

  RangeSliderController({
    this.min = 1.0,
    this.max = 10.0,
    double initialValue = 5.0,
  }) {
    value.value = initialValue;
  }

  void updateValue(double newValue) {
    value.value = newValue.clamp(min, max);
  }

  void increment() {
    if (value.value < max) {
      value.value += 1;
    }
  }

  void decrement() {
    if (value.value > min) {
      value.value -= 1;
    }
  }

  void reset(double resetValue) {
    value.value = resetValue.clamp(min, max);
  }
}
