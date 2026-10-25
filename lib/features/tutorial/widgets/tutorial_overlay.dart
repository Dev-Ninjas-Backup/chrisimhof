import 'package:chrisimhof/features/tutorial/controller/tutorial_controller.dart';
import 'package:chrisimhof/features/tutorial/widgets/tutorial_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TutorialOverlay extends StatelessWidget {
  const TutorialOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TutorialController>();

    return Obx(() {
      if (!controller.isActive.value) {
        return const SizedBox.shrink();
      }

      final step = controller.currentStep;
      if (step == null) return const SizedBox.shrink();

      final targetRect = controller.targetRect.value;
      final mediaQuery = MediaQuery.of(context);
      final screenHeight = mediaQuery.size.height;
      final safeTop = mediaQuery.padding.top;
      final safeBottom = mediaQuery.padding.bottom;

      // Position bubble relative to target
      double bubbleTop = safeTop + 80;
      const double estimatedBubbleHeight = 150;

      if (targetRect != null) {
        final double spaceAbove = targetRect.top - safeTop;
        final double spaceBelow = (screenHeight - safeBottom - 90) - targetRect.bottom;

        if (step.isAboveTarget) {
          if (spaceAbove >= estimatedBubbleHeight + 16) {
            bubbleTop = targetRect.top - estimatedBubbleHeight - 16;
          } else if (spaceBelow >= estimatedBubbleHeight + 16) {
            bubbleTop = targetRect.bottom + 16;
          } else {
            bubbleTop = (targetRect.top - estimatedBubbleHeight - 16).clamp(
              safeTop + 10,
              screenHeight - estimatedBubbleHeight - safeBottom - 90,
            );
          }
        } else {
          if (spaceBelow >= estimatedBubbleHeight + 16) {
            bubbleTop = targetRect.bottom + 16;
          } else if (spaceAbove >= estimatedBubbleHeight + 16) {
            bubbleTop = targetRect.top - estimatedBubbleHeight - 16;
          } else {
            bubbleTop = (targetRect.bottom + 16).clamp(
              safeTop + 10,
              screenHeight - estimatedBubbleHeight - safeBottom - 90,
            );
          }
        }
      }

      final isNavTarget = controller.currentStepIndex.value == 10;

      return Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            // Dark Backdrop with Spotlight Hole
            CustomPaint(
              size: mediaQuery.size,
              painter: _SpotlightPainter(
                targetRect: targetRect,
                isNavTarget: isNavTarget,
              ),
            ),

            // Absorb background clicks so user doesn't trigger app buttons
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // Consume taps outside bubble
                },
                child: const SizedBox.expand(),
              ),
            ),

            // Speech Bubble with Mascot and Actions
            Positioned(
              left: 16,
              right: 16,
              top: bubbleTop,
              child: TutorialBubble(
                step: step,
                onNext: controller.nextStep,
                onSkip: controller.skipTour,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _SpotlightPainter extends CustomPainter {
  final Rect? targetRect;
  final bool isNavTarget;

  _SpotlightPainter({
    this.targetRect,
    this.isNavTarget = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = const Color(0xD8051713); // Dim semi-transparent dark green/black

    final fullScreenPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    if (targetRect == null) {
      canvas.drawPath(fullScreenPath, backgroundPaint);
      return;
    }

    // Slightly padded target rect with rounded corners, clamped to visible area
    final inflated = targetRect!.inflate(6);
    final clamped = Rect.fromLTRB(
      inflated.left.clamp(0.0, size.width),
      inflated.top.clamp(0.0, size.height),
      inflated.right.clamp(0.0, size.width),
      isNavTarget
          ? inflated.bottom.clamp(0.0, size.height)
          : inflated.bottom.clamp(0.0, size.height - 86),
    );

    final rrect = RRect.fromRectAndRadius(clamped, const Radius.circular(18));

    final holePath = Path()..addRRect(rrect);
    final finalPath = Path.combine(PathOperation.difference, fullScreenPath, holePath);

    canvas.drawPath(finalPath, backgroundPaint);

    // Glowing border around spotlight
    final glowPaint = Paint()
      ..color = const Color(0x552DD4BF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawRRect(rrect, glowPaint);

    final borderPaint = Paint()
      ..color = const Color(0xFF2DD4BF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) {
    return oldDelegate.targetRect != targetRect || oldDelegate.isNavTarget != isNavTarget;
  }
}
