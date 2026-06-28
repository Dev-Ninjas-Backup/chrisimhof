import 'dart:math' as math;
import 'package:chrisimhof/core/common/controller/circadian_controller.dart';
import 'package:flutter/material.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:get/get.dart';

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

    // Update time if customTime changes on rebuild
    if (customTime != null) {
      controller.currentTime.value = customTime!;
    }

    final double r = orbitRadius;

    return SizedBox(
      width: avatarSize,
      height: avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── PNG image: no clip, full image visible ───
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            bottom: 0,

            child: Image.asset(
              imagePath,
              width: avatarSize,
              height: avatarSize,
              fit: BoxFit.contain,
            ),
          ),

          // ── Orbit ring + orbs ───────────────────────
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            child: SizedBox(
              width: r * 1.75,
              height: r * 1.75,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // orbit ring
                  DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE9F7E7).withValues(alpha: .18),
                        width: 1,
                      ),
                    ),
                    child: SizedBox(width: r * 1.5, height: r * 1.5),
                  ),

                  // orbs
                  Obx(() {
                    final _ = controller.currentTime.value;

                    final double ringRadius = (r * 1.5) / 2;
                    final sunX = ringRadius * math.cos(controller.sunAngle);
                    final sunY = ringRadius * math.sin(controller.sunAngle);
                    final moonX = ringRadius * math.cos(controller.moonAngle);
                    final moonY = ringRadius * math.sin(controller.moonAngle);

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.translate(
                          offset: Offset(sunX, sunY),
                          child: _buildOrb(
                            icon: IconPath.sun,
                            color: AppColors.white,
                            glowColor: AppColors.yellowAccent.withValues(
                              alpha: .65,
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(moonX, moonY),
                          child: _buildOrb(
                            icon: IconPath.moon1,
                            color: const Color(0xFF00E5BF),
                            glowColor: const Color(
                              0xFF00E5BF,
                            ).withValues(alpha: .35),
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
      child: Image.asset(icon, color: color, width: 30, height: 30),
    );
  }
}
