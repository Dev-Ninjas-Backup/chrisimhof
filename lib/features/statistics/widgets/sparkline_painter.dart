import 'package:flutter/material.dart';

class SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  final Color fillColor;

  const SparklinePainter({
    required this.data,
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final Paint linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final double width = size.width;
    final double height = size.height;
    final int len = data.length;
    final double stepX = width / (len - 1);

    final Path path = Path();
    final List<Offset> points = [];

    for (int i = 0; i < len; i++) {
      final double x = i * stepX;
      // Map data normalized from 0.0 to 1.0 into height constraints
      final double y = height - (data[i] * height * 0.55 + height * 0.2);
      points.add(Offset(x, y));
    }

    // Connect points using a smooth cubic Bezier curve
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < len - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final controlPoint1 = Offset(p1.dx + stepX / 2.2, p1.dy);
      final controlPoint2 = Offset(p2.dx - stepX / 2.2, p2.dy);
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p2.dx,
        p2.dy,
      );
    }

    canvas.drawPath(path, linePaint);

    // Fill the path under the curve
    final Path fillPath = Path.from(path);
    fillPath.lineTo(width, height);
    fillPath.lineTo(0, height);
    fillPath.close();

    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          fillColor.withValues(alpha: 0.18),
          fillColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant SparklinePainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor;
  }
}

