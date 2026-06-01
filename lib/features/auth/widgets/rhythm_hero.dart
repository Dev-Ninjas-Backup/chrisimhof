import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:flutter/material.dart';

class RyvenzaRhythmHero extends StatelessWidget {
  const RyvenzaRhythmHero({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size.square(190),
      painter: RhythmHeroPainter(),
    );
  }
}

class RhythmHeroPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = size.width / 2;
    final Paint glow = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.mint.withValues(alpha: 0.55),
          AppColors.primaryButtonColor.withValues(alpha: 0.18),
          AppColors.primaryButtonColor.withValues(alpha: 0),
        ],
        stops: const [0, 0.55, 1],
      ).createShader(Offset.zero & size);

    canvas.drawCircle(center, radius * 1.9, glow);

    final Paint outer = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.primaryButtonColor.withValues(alpha: 0.2);
    canvas.drawCircle(center, radius * 0.68, outer);
    canvas.drawCircle(
      center,
      radius * 0.48,
      outer..color = AppColors.primaryButtonColor.withValues(alpha: 0.28),
    );

    final Paint figure = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = AppColors.mint;
    final Paint head = Paint()..color = AppColors.mint;
    canvas.drawCircle(Offset(center.dx, center.dy - radius * 0.28), 11, head);
    canvas.drawLine(
      Offset(center.dx, center.dy - radius * 0.16),
      Offset(center.dx, center.dy + radius * 0.26),
      figure,
    );
    canvas.drawLine(
      Offset(center.dx - radius * 0.17, center.dy - radius * 0.03),
      Offset(center.dx + radius * 0.17, center.dy - radius * 0.03),
      figure,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + radius * 0.26),
      Offset(center.dx - radius * 0.12, center.dy + radius * 0.48),
      figure,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + radius * 0.26),
      Offset(center.dx + radius * 0.12, center.dy + radius * 0.48),
      figure,
    );

    final Paint pulse = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = AppColors.primaryButtonColor.withValues(alpha: 0.75);
    final Path pulsePath = Path()
      ..moveTo(center.dx - radius * 0.50, center.dy)
      ..quadraticBezierTo(
        center.dx - radius * 0.34,
        center.dy - 10,
        center.dx - radius * 0.13,
        center.dy,
      )
      ..quadraticBezierTo(
        center.dx,
        center.dy + 10,
        center.dx + radius * 0.13,
        center.dy,
      )
      ..quadraticBezierTo(
        center.dx + radius * 0.34,
        center.dy - 10,
        center.dx + radius * 0.50,
        center.dy,
      );
    canvas.drawPath(pulsePath, pulse);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
