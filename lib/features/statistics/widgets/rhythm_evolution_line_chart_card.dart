import 'dart:math' as math;
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/statistics/controller/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RhythmEvolutionLineChartCard extends StatelessWidget {
  final StatisticsController controller;

  const RhythmEvolutionLineChartCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final points = controller.rhythmTrendList;

      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.show_chart_rounded,
                  size: 20,
                  color: Color(0xFF10B981),
                ),
                const SizedBox(width: 8),
                Text(
                  'Évolution du rythme'.tr,
                  style: getTextStyle2(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 170,
              width: double.infinity,
              child: CustomPaint(
                painter: _RhythmChartPainter(points: points),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _RhythmChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> points;

  _RhythmChartPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    const leftMargin = 38.0;
    const bottomMargin = 22.0;
    const topMargin = 8.0;

    final chartWidth = size.width - leftMargin;
    final chartHeight = size.height - bottomMargin - topMargin;

    // Draw Y-axis labels & dashed gridlines
    final gridPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    final textStyle = getTextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF94A3B8),
    );

    final ySteps = [0, 20, 40, 60, 80, 100];
    for (final val in ySteps) {
      final y = topMargin + chartHeight * (1.0 - val / 100.0);

      // Dashed horizontal line
      const dashWidth = 4.0;
      const dashSpace = 4.0;
      double startX = leftMargin;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, y),
          Offset(math.min(startX + dashWidth, size.width), y),
          gridPaint,
        );
        startX += dashWidth + dashSpace;
      }

      // Y-axis text
      final textSpan = TextSpan(text: '$val %', style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(leftMargin - textPainter.width - 6, y - textPainter.height / 2),
      );
    }

    if (points.isEmpty) return;

    final n = points.length;
    final stepX = n > 1 ? chartWidth / (n - 1) : chartWidth;

    final List<Offset> chartOffsets = [];
    for (int i = 0; i < n; i++) {
      final x = leftMargin + i * stepX;
      final score = (points[i]['score'] as num?)?.toDouble() ?? 50.0;
      final clampedScore = score.clamp(0.0, 100.0);
      final y = topMargin + chartHeight * (1.0 - clampedScore / 100.0);
      chartOffsets.add(Offset(x, y));

      // Draw X-axis label
      final dayLabel = (points[i]['day'] as String?) ?? '';
      final daySpan = TextSpan(
        text: dayLabel,
        style: getTextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1E3A8A),
        ),
      );
      final dayPainter = TextPainter(
        text: daySpan,
        textDirection: TextDirection.ltr,
      )..layout();
      dayPainter.paint(
        canvas,
        Offset(x - dayPainter.width / 2, size.height - bottomMargin + 6),
      );
    }

    // Build smooth curve path
    final linePath = Path();
    linePath.moveTo(chartOffsets.first.dx, chartOffsets.first.dy);

    for (int i = 0; i < chartOffsets.length - 1; i++) {
      final p0 = chartOffsets[i];
      final p1 = chartOffsets[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      linePath.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    // Gradient fill below path
    final fillPath = Path.from(linePath);
    fillPath.lineTo(chartOffsets.last.dx, topMargin + chartHeight);
    fillPath.lineTo(chartOffsets.first.dx, topMargin + chartHeight);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF10B981).withValues(alpha: 0.22),
          const Color(0xFF10B981).withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(leftMargin, topMargin, chartWidth, chartHeight));
    canvas.drawPath(fillPath, fillPaint);

    // Draw main line
    final linePaint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);

    // Draw point dots
    final dotPaint = Paint()..color = const Color(0xFF10B981);
    final dotInnerPaint = Paint()..color = AppColors.white;

    for (final pt in chartOffsets) {
      canvas.drawCircle(pt, 4.0, dotPaint);
      canvas.drawCircle(pt, 1.8, dotInnerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RhythmChartPainter oldDelegate) => true;
}
