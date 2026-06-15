import 'dart:math' as math;
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/statistics/widgets/sparkline_painter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Circle Progress Indicator for Global Rhythm Score card
class GlobalRhythmCircle extends StatelessWidget {
  final int score;

  const GlobalRhythmCircle({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: score / 100),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, animatedProgress, child) {
        return SizedBox(
          width: 110,
          height: 110,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(110, 110),
                painter: _GlobalRhythmRingPainter(progress: animatedProgress),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(animatedProgress * 100).round()}%',
                    style: getTextStyle2(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'GLOBAL'.tr,
                    style: getTextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSoft,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      key: ValueKey(score),
    );
  }
}

class _GlobalRhythmRingPainter extends CustomPainter {
  final double progress;

  const _GlobalRhythmRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = math.min(size.width, size.height) / 2 - 8;

    final Paint trackPaint = Paint()
      ..color =
          AppColors.darkGreenTrack // Dark green track background
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..color = AppColors
          .primaryButtonColor // Mint green progress
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    const double startAngle = -math.pi / 2; // Start from top
    final double maxSweepAngle = math.pi * 2; // Full circle
    final double sweepAngle = maxSweepAngle * progress.clamp(0.0, 1.0);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GlobalRhythmRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Custom sparkline painter for smooth wave charts
class SparklineCurve extends StatelessWidget {
  final List<double> data;
  final Color lineColor;
  final Color fillColor;

  const SparklineCurve({
    super.key,
    required this.data,
    required this.lineColor,
    required this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 80),
      painter: SparklinePainter(
        data: data,
        lineColor: lineColor,
        fillColor: fillColor,
      ),
    );
  }
}
