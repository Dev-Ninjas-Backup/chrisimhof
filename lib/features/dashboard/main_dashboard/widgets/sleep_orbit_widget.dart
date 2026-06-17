import 'dart:math' as math;
import 'package:chrisimhof/features/dashboard/main_dashboard/widgets/sleep_orbit_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SleepOrbitController extends GetxController
    with GetTickerProviderStateMixin {
  late final AnimationController breathController;
  late final Animation<double> breathAnimation;

  late AnimationController beaconPulseController;
  late final Animation<double> beaconPulseAnimation;

  late final AnimationController rippleController;
  late final Animation<double> rippleAnimation;

  bool _isSleepLogged = false;
  bool _isSleepPrep = false;
  bool _isMissedBedtime = false;
  int _minutesToBedtime = 0;

  @override
  void onInit() {
    super.onInit();

    // 1. Ambient breath
    breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );
    breathAnimation = Tween<double>(begin: 0.25, end: 1.0).animate(
      CurvedAnimation(parent: breathController, curve: Curves.easeInOutCubic),
    );
    breathController.repeat(reverse: true);

    // 2. Beacon pulse
    beaconPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    beaconPulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: beaconPulseController, curve: Curves.easeInOut),
    );
    beaconPulseController.repeat(reverse: true);

    // 3. Completion ripple (one-shot)
    rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: rippleController, curve: Curves.easeOut));
  }

  void updateState({
    required bool isSleepLogged,
    required bool isSleepPrep,
    required bool isMissedBedtime,
    required int minutesToBedtime,
  }) {
    final bool durationChanged =
        (isMissedBedtime != _isMissedBedtime) || (isSleepPrep != _isSleepPrep);
    _isSleepPrep = isSleepPrep;
    _isMissedBedtime = isMissedBedtime;

    if (durationChanged) {
      final Duration newDuration = _beaconDuration();
      if (beaconPulseController.duration != newDuration) {
        beaconPulseController
          ..duration = newDuration
          ..repeat(reverse: true);
      }
    }

    if (!_isSleepLogged && isSleepLogged) {
      rippleController.forward(from: 0.0);
    }
    _isSleepLogged = isSleepLogged;

    if (_minutesToBedtime > 0 && minutesToBedtime <= 0 && !isSleepLogged) {
      HapticFeedback.lightImpact();
    }
    _minutesToBedtime = minutesToBedtime;
  }

  Duration _beaconDuration() {
    if (_isMissedBedtime) return const Duration(milliseconds: 1500);
    if (_isSleepPrep) return const Duration(seconds: 2);
    return const Duration(seconds: 6);
  }

  @override
  void onClose() {
    breathController.dispose();
    beaconPulseController.dispose();
    rippleController.dispose();
    super.onClose();
  }
}

class SleepOrbitWidget extends StatelessWidget {
  final String imagePath;
  final double avatarSize;
  final double imageShiftFactor;
  final String optimalBedtime;
  final int minutesToBedtime;
  final bool isSleepLogged;
  final bool isSleepPrep;
  final bool isMissedBedtime;

  const SleepOrbitWidget({
    super.key,
    required this.imagePath,
    this.avatarSize = 110,
    this.imageShiftFactor = 0.42,
    required this.optimalBedtime,
    required this.minutesToBedtime,
    required this.isSleepLogged,
    required this.isSleepPrep,
    required this.isMissedBedtime,
  });

  static double _timeToAngle(int hour, int minute) {
    final double totalHours = hour + minute / 60.0;
    return -math.pi / 2 + (totalHours / 24.0) * 2 * math.pi;
  }

  static double _beaconAngleFromBedtime(String bedtime) {
    final parts = bedtime.split(':');
    if (parts.length != 2) return -math.pi / 2;
    final int h = int.tryParse(parts[0]) ?? 0;
    final int m = int.tryParse(parts[1]) ?? 0;
    return _timeToAngle(h, m);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SleepOrbitController());
    controller.updateState(
      isSleepLogged: isSleepLogged,
      isSleepPrep: isSleepPrep,
      isMissedBedtime: isMissedBedtime,
      minutesToBedtime: minutesToBedtime,
    );

    final double imageShift = avatarSize * imageShiftFactor;
    final double missedOverdueRatio = ((-minutesToBedtime) / 60.0).clamp(
      0.0,
      1.0,
    );
    final double beaconAngle = _beaconAngleFromBedtime(optimalBedtime);

    return SizedBox(
      width: avatarSize,
      height: avatarSize + imageShift,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── 1. Human silhouette (breathing opacity) ─────────────────────────
          Positioned(
            top: imageShift,
            left: -19,
            right: 0,
            child: AnimatedBuilder(
              animation: controller.breathAnimation,
              builder: (context, _) {
                final double minOp = isSleepPrep ? 0.60 : 0.55;
                final double maxOp = isSleepPrep ? 0.90 : 0.82;
                final double opacity =
                    (minOp +
                            (controller.breathAnimation.value - 0.25) /
                                0.75 *
                                (maxOp - minOp))
                        .clamp(0.0, 1.0);
                return Opacity(
                  opacity: opacity,
                  child: Image.asset(
                    imagePath,
                    width: avatarSize,
                    height: avatarSize,
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ),

          // ── 2. Orbit canvas ─────────────────────────────────────────────────
          Positioned(
            top: 20,
            left: -8,
            child: SizedBox(
              width: avatarSize,
              height: avatarSize,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  controller.breathAnimation,
                  controller.beaconPulseAnimation,
                  controller.rippleAnimation,
                ]),
                builder: (context, _) {
                  final now = DateTime.now();
                  final double currentTimeAngle = _timeToAngle(
                    now.hour,
                    now.minute,
                  );

                  return CustomPaint(
                    painter: SleepOrbitPainter(
                      breathValue: controller.breathAnimation.value,
                      beaconPulse: controller.beaconPulseAnimation.value,
                      rippleValue: controller.rippleAnimation.value,
                      currentTimeAngle: currentTimeAngle,
                      beaconAngle: beaconAngle,
                      minutesToBedtime: minutesToBedtime,
                      isSleepLogged: isSleepLogged,
                      isSleepPrep: isSleepPrep,
                      isMissedBedtime: isMissedBedtime,
                      missedOverdueRatio: missedOverdueRatio,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
