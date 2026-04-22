import 'dart:math' as math;
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:flutter/material.dart';

class VitalityProgressPainter extends CustomPainter {
  final double progress;
  final int percentage;

  VitalityProgressPainter({required this.progress, required this.percentage});

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
    final startAngle = -math.pi / 2;
    final sweepAngle = math.pi * 2 * progress;

    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);

    // Draw percentage text dynamically inside the circle
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$percentage%',
        style: const TextStyle(
          color: AppColors.primaryTextColor,
          fontSize: 32,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final offset = Offset(
      size.width / 2 - textPainter.width / 2,
      size.height / 2 - textPainter.height / 2,
    );
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant VitalityProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.percentage != percentage;
  }
}
