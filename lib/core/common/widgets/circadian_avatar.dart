import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  /// 0.0 = image centered on circle, 0.22 = image shifted down by 22%
  final double imageShiftFactor;

  const CircadianAvatar({
    super.key,
    required this.imagePath,
    this.avatarSize = 250,
    this.customTime,
    this.tag = 'default',
    this.imageShiftFactor = 0.22,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      CircadianController(customTime: customTime),
      tag: tag,
      permanent: false,
    );

    final double r = avatarSize / 2;
    final double imageShift = avatarSize * imageShiftFactor;

    return SizedBox(
      width: avatarSize,
      height: avatarSize + imageShift,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Image: shifted down ───────────────
          Positioned(
            top: imageShift,
            left: 0,
            right: 0,
            child: ClipOval(
              child: Image.asset(
                imagePath,
                width: avatarSize,
                height: avatarSize,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ── Orbit ring + orbs: fixed at top ───
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              width: avatarSize,
              height: avatarSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // orbit ring
                  DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF00E5BF).withValues(alpha: .18),
                        width: 1.5,
                      ),
                    ),
                    child: SizedBox(
                      width: avatarSize,
                      height: avatarSize,
                    ),
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
                            icon: Icons.wb_sunny,
                            color: Colors.white,
                            glowColor: Colors.yellowAccent.withValues(alpha: .65),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(moonX, moonY),
                          child: _buildOrb(
                            icon: Icons.nightlight_round,
                            color: const Color(0xFF00E5BF),
                            glowColor: const Color(0xFF00E5BF).withValues(alpha: .35),
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
    required IconData icon,
    required Color color,
    required Color glowColor,
  }) {
    return Container(
      width: 32,
      height: 32,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1117),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: glowColor, blurRadius: 12, spreadRadius: 2),
        ],
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }
}