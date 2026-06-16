import 'dart:math' as math;
import 'package:flutter/material.dart';

class GlobalRhythmRingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double trackStrokeWidth;
  final double progressStrokeWidth;
  final double offset;

  const GlobalRhythmRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    this.trackStrokeWidth = 6.0,
    this.progressStrokeWidth = 10.0,
    this.offset = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = math.min(size.width, size.height) / 2 - offset;

    final Paint trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackStrokeWidth
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = progressStrokeWidth
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
  bool shouldRepaint(covariant GlobalRhythmRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.trackStrokeWidth != trackStrokeWidth ||
        oldDelegate.progressStrokeWidth != progressStrokeWidth ||
        oldDelegate.offset != offset;
  }
}
