import 'dart:ui';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EndDayButton extends StatelessWidget {
  const EndDayButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return GestureDetector(
      onTap: controller.endMyDay,
      child: CustomPaint(
        painter: DashedRectPainter(
          color: AppColors.gray300, // Light grey dash
          radius: 20,
          gap: 6,
        ),
        child: Container(
          width: double.infinity,
          height: 48,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.outlined_flag,
                color: AppColors.greyMedium,
                size: 16,
              ),
              const SizedBox(width: 8),
              RichText(
                text: TextSpan(
                  style: getTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray700, // Cool grey 700
                  ),
                  children: [
                    const TextSpan(text: 'End my day '),
                    TextSpan(
                      text: '(save & reset)',
                      style: getTextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSoft,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;

  DashedRectPainter({
    required this.color,
    required this.radius,
    required this.gap,
    this.strokeWidth = 1.2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashedPath = _buildDashedPath(path, gap);
    canvas.drawPath(dashedPath, paint);
  }

  Path _buildDashedPath(Path source, double gap) {
    final Path dashedPath = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        if (draw) {
          dashedPath.addPath(
            metric.extractPath(
              distance,
              (distance + gap).clamp(0.0, metric.length),
            ),
            Offset.zero,
          );
        }
        distance += gap;
        draw = !draw;
      }
    }
    return dashedPath;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
