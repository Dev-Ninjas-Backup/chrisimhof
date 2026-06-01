import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RyvenzaLogo extends StatelessWidget {
  const RyvenzaLogo({super.key, this.color = AppColors.primaryTextColor});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: const Size.square(30),
          painter: RyvenzaLogoPainter(color: color),
        ),
        const SizedBox(width: 10),
        Text(
          'RYVENZA',
          style: GoogleFonts.outfit(
            color: color,
            fontSize: 28,
            fontWeight: FontWeight.w500,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }
}

class RyvenzaLogoPainter extends CustomPainter {
  RyvenzaLogoPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = color.withValues(alpha: 0.9);
    final Paint wave = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = AppColors.primaryButtonColor;

    canvas.drawCircle(size.center(Offset.zero), size.width * 0.43, ring);

    final Path path = Path()
      ..moveTo(size.width * 0.17, size.height * 0.58)
      ..quadraticBezierTo(
        size.width * 0.31,
        size.height * 0.40,
        size.width * 0.44,
        size.height * 0.53,
      )
      ..quadraticBezierTo(
        size.width * 0.57,
        size.height * 0.68,
        size.width * 0.70,
        size.height * 0.47,
      )
      ..quadraticBezierTo(
        size.width * 0.80,
        size.height * 0.34,
        size.width * 0.87,
        size.height * 0.43,
      );
    canvas.drawPath(path, wave);
  }

  @override
  bool shouldRepaint(covariant RyvenzaLogoPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
