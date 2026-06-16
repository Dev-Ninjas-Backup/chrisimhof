import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class PulsingRhythmBadgeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController ctrl;
  late final Animation<double> anim;
  bool _initialized = false;
  bool _isSleepPrep = false;

  @override
  void onInit() {
    super.onInit();
    ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    anim = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeInOut));
  }

  void updateState({required bool isSleepPrep}) {
    if (!_initialized) {
      _initialized = true;
      _isSleepPrep = isSleepPrep;
      if (isSleepPrep) {
        ctrl.repeat(reverse: true);
      }
      return;
    }
    if (isSleepPrep != _isSleepPrep) {
      _isSleepPrep = isSleepPrep;
      if (isSleepPrep) {
        ctrl.repeat(reverse: true);
      } else {
        ctrl.stop();
        ctrl.value = 1.0;
      }
    }
  }

  @override
  void onClose() {
    ctrl.dispose();
    super.onClose();
  }
}
