import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../const/icon_path.dart';

// ─────────────────────────────────────────────
// Controller
// ─────────────────────────────────────────────

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

  double get _hours =>
      currentTime.value.hour +
      (currentTime.value.minute / 60.0) +
      (currentTime.value.second / 3600.0);

  double get sunAngle => (math.pi / 2) + (_hours / 24.0) * 2 * math.pi;

  double get moonAngle => sunAngle + math.pi;
}

// ─────────────────────────────────────────────
// Widget
// ─────────────────────────────────────────────

class CircadianAvatar extends StatelessWidget {
  final String imagePath;
  final double avatarSize;
  final DateTime? customTime;
  final String tag;

  /// Ring radius in actual pixels (not a fraction).
  /// Tune this directly: try 70–110 for avatarSize=350.
  final double orbitRadius;

  /// Vertical center of ring from top of widget, in pixels.
  /// Tune this directly: try 60–110 for avatarSize=350.
  final double orbitCenterY;

  const CircadianAvatar({
    super.key,
    required this.imagePath,
    this.avatarSize = 350,
    this.customTime,
    this.tag = 'default',
    this.orbitRadius = 90,
    this.orbitCenterY = 85,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      CircadianController(customTime: customTime),
      tag: tag,
      permanent: false,
    );

    final double r = orbitRadius;

    return SizedBox(
      width: avatarSize,
      height: avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── PNG image: no clip, full image visible ───
          Positioned.fill(
            child: Image.asset(
              imagePath,
              width: avatarSize,
              height: avatarSize,
              fit: BoxFit.contain,
            ),
          ),

          // ── Orbit ring + orbs ───────────────────────
          Positioned(
            top: orbitCenterY - r,
            left: (avatarSize / 2) - r,
            child: SizedBox(
              width: r * 2,
              height: r * 2,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // orbit ring
                  DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE9F7E7).withValues(alpha: .18),
                        width: 2.5,
                      ),
                    ),
                    child: SizedBox(width: r * 2, height: r * 2),
                  ),

                  // orbs
                  Obx(() {
                    final _ = controller.currentTime.value;

                    final sunX = r * math.cos(controller.sunAngle);
                    final sunY = r * math.sin(controller.sunAngle);
                    final moonX = r * math.cos(controller.moonAngle);
                    final moonY = r * math.sin(controller.moonAngle);

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.translate(
                          offset: Offset(sunX, sunY),
                          child: _buildOrb(
                            icon: IconPath.sun,
                            color: Colors.white,
                            glowColor:
                                Colors.yellowAccent.withValues(alpha: .65),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(moonX, moonY),
                          child: _buildOrb(
                            icon: IconPath.moon1,
                            color: const Color(0xFF00E5BF),
                            glowColor:
                                const Color(0xFF00E5BF).withValues(alpha: .35),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrb({
    required String icon,
    required Color color,
    required Color glowColor,
  }) {
    return Container(
      width: 32,
      height: 32,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: glowColor, blurRadius: 12, spreadRadius: 2),
        ],
      ),
      child: Image.asset(
        icon,
        color: color,
        width: 30,
        height: 30,
      ),
    );
  }
}