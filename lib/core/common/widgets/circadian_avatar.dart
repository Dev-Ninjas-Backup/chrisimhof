import 'dart:math' as math;
import 'package:chrisimhof/core/common/controller/circadian_controller.dart';
import 'package:flutter/material.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:get/get.dart';

class CircadianAvatar extends StatelessWidget {
  final String imagePath;
  final double avatarSize;
  final DateTime? customTime;
  final String tag;
  final double imageShiftFactor; // 0.0 = centered, 0.22 = shifted down by 22%

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

    // Update time if customTime changes on rebuild
    if (customTime != null) {
      controller.currentTime.value = customTime!;
    }

    final double r = avatarSize / 2;
    final double imageShift = avatarSize * imageShiftFactor;

    return SizedBox(
      width: avatarSize,
      height: avatarSize + imageShift,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipOval(
              child: SizedBox(
                width: avatarSize,
                height: avatarSize,
                child: Stack(
                  children: [
                    Positioned(
                      top: imageShift,
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        imagePath,
                        width: avatarSize,
                        height: avatarSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              width: avatarSize,
              height: avatarSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.tealBright.withValues(alpha: .18),
                        width: 1.5,
                      ),
                    ),
                    child: SizedBox(width: avatarSize, height: avatarSize),
                  ),
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
                            color: AppColors.white,
                            glowColor: AppColors.yellowAccent.withValues(alpha: .65),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(moonX, moonY),
                          child: _buildOrb(
                            icon: Icons.nightlight_round,
                            color: AppColors.tealBright,
                            glowColor: AppColors.tealBright.withValues(alpha: .35),
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
        color: AppColors.darkNavy,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: glowColor, blurRadius: 12, spreadRadius: 2),
        ],
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }
}