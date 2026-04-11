import 'dart:math' as math;
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:flutter/material.dart';

class VitalityProgressPainter extends CustomPainter {
  final double progress;

  VitalityProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const backgroundColor = Color(0xFFF1F3F5);
    const progressColor = AppColors.primaryButtonColor;

    final strokeWidth = 16.0;
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, math.pi * 2, false, backgroundPaint);

    // Start from lower-right side like the design
    const startAngle = math.pi / 12; // 15 degrees
    const maxSweepAngle = math.pi * 1.05; // controlled short arc
    final sweepAngle = maxSweepAngle * progress;

    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant VitalityProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
