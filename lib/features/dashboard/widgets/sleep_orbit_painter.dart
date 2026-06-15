import 'dart:math' as math;
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:flutter/material.dart';

/// Paints the circadian orbit visualization for the Ryvenza bedtime card.
///
/// Orbit philosophy:
///   - The orbit represents a 24-hour clock face.
///     00:00 (midnight) = 12-o'clock (top). Time increases clockwise.
///   - [currentTimeAngle] drives the celestial orb POSITION — always from
///     the real device clock, so the sun/moon moves continuously around the orbit.
///   - [beaconAngle] is derived from the user's selected optimal bedtime.
///     The beacon stays fixed at that clock position on the orbit.
///   - The highlighted arc = remaining journey (current position → beacon).
///   - Sun vs moon APPEARANCE is driven by [minutesToBedtime] proximity.
class SleepOrbitPainter extends CustomPainter {
  final double breathValue; // 0.0–1.0, ambient breathing cycle
  final double beaconPulse; // 0.0–1.0, beacon pulsing animation
  final double rippleValue; // 0.0–1.0, completion ripple (0 = inactive)
  final double currentTimeAngle; // radians — from DateTime.now() (device clock)
  final double beaconAngle; // radians — from user's optimalBedtime setting
  final int
  minutesToBedtime; // signed; negative = past bedtime (for appearance)
  final bool isSleepLogged;
  final bool isSleepPrep;
  final bool isMissedBedtime;
  final double missedOverdueRatio; // 0.0–1.0 (0=just missed, 1=60+ min past)

  SleepOrbitPainter({
    required this.breathValue,
    required this.beaconPulse,
    required this.rippleValue,
    required this.currentTimeAngle,
    required this.beaconAngle,
    required this.minutesToBedtime,
    required this.isSleepLogged,
    required this.isSleepPrep,
    required this.isMissedBedtime,
    required this.missedOverdueRatio,
  });

  // ── Shared Paint objects (reused to avoid allocations per frame) ─────────────
  final _arcPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  final _glowPaint = Paint();
  final _fillPaint = Paint()..style = PaintingStyle.fill;
  final _strokePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  final _wavePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.2;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    // ── Arc sweep: remaining journey from current clock time → bedtime beacon ───
    // Always clockwise. If missed bedtime → no remaining arc.
    double remainingSweep;
    if (isMissedBedtime || isSleepLogged) {
      remainingSweep = 0.0;
    } else {
      remainingSweep = beaconAngle - currentTimeAngle;
      if (remainingSweep < 0) remainingSweep += 2 * math.pi;
    }

    // ── Draw layers (painter's algorithm: back → front) ─────────────────────────
    _drawFullOrbitTrack(canvas, center, radius);
    if (remainingSweep > 0.01) {
      _drawActiveArc(canvas, center, radius, remainingSweep);
    }
    _drawMidnightTick(canvas, center, radius); // reference tick at 00:00 (top)
    _drawFlowingWaves(canvas, center, radius);
    _drawAmbientParticles(canvas, center, radius);

    // Beacon — at the bedtime clock position
    final beaconPos = Offset(
      center.dx + radius * math.cos(beaconAngle),
      center.dy + radius * math.sin(beaconAngle),
    );
    _drawBeacon(canvas, beaconPos);

    // Celestial orb — at the current device-clock position
    final celestialPos = Offset(
      center.dx + radius * math.cos(currentTimeAngle),
      center.dy + radius * math.sin(currentTimeAngle),
    );
    _drawCelestialOrb(canvas, celestialPos);
  }

  // ── 1. Full orbit background track ──────────────────────────────────────────
  void _drawFullOrbitTrack(Canvas canvas, Offset center, double radius) {
    _arcPaint
      ..color = AppColors.white.withValues(alpha: 0.18)
      ..strokeWidth = 0.8;
    canvas.drawCircle(center, radius, _arcPaint);
  }

  // ── 2. Active arc: current position → beacon (clockwise, remaining journey) ──
  void _drawActiveArc(
    Canvas canvas,
    Offset center,
    double radius,
    double sweep,
  ) {
    final rect = Rect.fromCircle(center: center, radius: radius);

    const Color arcColor = AppColors.white;

    // Outer glow layer
    _arcPaint
      ..color = arcColor.withValues(alpha: 0.10)
      ..strokeWidth = 3.5;
    canvas.drawArc(rect, currentTimeAngle, sweep, false, _arcPaint);

    // Core arc
    _arcPaint
      ..color = arcColor.withValues(alpha: 0.75)
      ..strokeWidth = 1.2;
    canvas.drawArc(rect, currentTimeAngle, sweep, false, _arcPaint);
  }

  // ── 3. Midnight reference tick at 12-o'clock (00:00) ─────────────────────────
  void _drawMidnightTick(Canvas canvas, Offset center, double radius) {
    const double tickAngle = -math.pi / 2; // 00:00 = top
    _strokePaint
      ..color = AppColors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(
        center.dx + (radius - 4) * math.cos(tickAngle),
        center.dy + (radius - 4) * math.sin(tickAngle),
      ),
      Offset(
        center.dx + (radius + 4) * math.cos(tickAngle),
        center.dy + (radius + 4) * math.sin(tickAngle),
      ),
      _strokePaint,
    );
  }

  // ── 4. Flowing concentric wave rings ─────────────────────────────────────────
  void _drawFlowingWaves(Canvas canvas, Offset center, double radius) {
    final double speed = isSleepPrep ? 0.5 : 1.0;
    final double r1 =
        radius * 0.70 + 6.0 * math.sin(breathValue * 2 * math.pi * speed);
    final double r2 =
        radius * 0.50 - 4.0 * math.cos(breathValue * 2 * math.pi * speed + 1.0);

    _wavePaint.color =
        (isSleepPrep ? AppColors.tealBright : AppColors.secondaryButtonColor)
            .withValues(alpha: 0.08);
    canvas.drawCircle(center, r1, _wavePaint);

    _wavePaint.color =
        (isSleepPrep ? AppColors.tealBright : AppColors.mintLight).withValues(
          alpha: 0.05,
        );
    canvas.drawCircle(center, r2, _wavePaint);
  }

  // ── 5. Ambient floating particles ────────────────────────────────────────────
  void _drawAmbientParticles(Canvas canvas, Offset center, double radius) {
    const int count = 4;
    final double speed = isSleepPrep ? 0.4 : 1.0;
    final double maxDrift = isSleepPrep ? 3.0 : 8.0;

    for (int i = 0; i < count; i++) {
      final double phase = i * (math.pi / 2);
      final double angle = phase + breathValue * 2 * math.pi * 0.3 * speed;
      final double drift =
          maxDrift * math.sin(breathValue * 2 * math.pi * speed + phase);
      final double dist = radius * 0.6 + drift;
      final double opacity =
          0.15 + 0.15 * math.sin(breathValue * 2 * math.pi * speed + phase);
      final double pSize =
          1.5 + 0.80 * math.cos(breathValue * 2 * math.pi * speed + phase);

      _fillPaint.color = (isSleepPrep ? AppColors.tealBright : AppColors.white)
          .withValues(alpha: opacity.clamp(0.0, 1.0));
      canvas.drawCircle(
        Offset(
          center.dx + dist * math.cos(angle),
          center.dy + dist * math.sin(angle),
        ),
        pSize.clamp(0.5, 4.0),
        _fillPaint,
      );
    }
  }

  // ── 6. Bedtime Beacon ─────────────────────────────────────────────────────────
  void _drawBeacon(Canvas canvas, Offset pos) {
    Color beaconColor;
    Color glowColor;
    double glowBaseAlpha;

    if (isSleepLogged) {
      beaconColor = AppColors.secondaryButtonColor;
      glowColor = AppColors.secondaryButtonColor;
      glowBaseAlpha = 0.20;
    } else if (isMissedBedtime) {
      beaconColor = _missedBeaconColor(missedOverdueRatio);
      glowColor = beaconColor;
      glowBaseAlpha = 0.40;
    } else {
      beaconColor = AppColors.primaryButtonColor;
      glowColor = AppColors.primaryButtonColor;
      glowBaseAlpha = isSleepPrep ? 0.50 : 0.30;
    }

    final double pulseExp =
        beaconPulse * (isSleepPrep || isMissedBedtime ? 4.5 : 2.5);

    // Outer halo (breathing)
    final double haloR = 22.0 + pulseExp;
    _glowPaint.shader = RadialGradient(
      colors: [
        glowColor.withValues(
          alpha: (glowBaseAlpha * 0.35 * (1 - beaconPulse * 0.25)).clamp(0, 1),
        ),
        AppColors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: pos, radius: haloR));
    canvas.drawCircle(pos, haloR, _glowPaint);

    // Inner glow disc
    final double glowR = 14.0 + pulseExp * 0.5;
    _glowPaint.shader = RadialGradient(
      colors: [
        glowColor.withValues(alpha: glowBaseAlpha.clamp(0, 1)),
        AppColors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: pos, radius: glowR));
    canvas.drawCircle(pos, glowR, _glowPaint);

    // Completion ripple
    if (rippleValue > 0 && isSleepLogged) {
      final double rippleR = 6.0 + rippleValue * 40.0;
      final double rippleAlpha = (0.60 * (1.0 - rippleValue)).clamp(0.0, 0.6);
      _strokePaint
        ..color = AppColors.secondaryButtonColor.withValues(alpha: rippleAlpha)
        ..strokeWidth = 1.5;
      canvas.drawCircle(pos, rippleR, _strokePaint);
    }

    // Core: checkmark (logged) or dot
    if (isSleepLogged) {
      _strokePaint
        ..color = beaconColor
        ..strokeWidth = 1.8
        ..strokeJoin = StrokeJoin.round;
      final path = Path()
        ..moveTo(pos.dx - 4.0, pos.dy)
        ..lineTo(pos.dx - 1.0, pos.dy + 3.0)
        ..lineTo(pos.dx + 4.0, pos.dy - 3.0);
      canvas.drawPath(path, _strokePaint);
    } else {
      _fillPaint.color = beaconColor;
      canvas.drawCircle(pos, 5.0, _fillPaint);
      _fillPaint.color = AppColors.white.withValues(alpha: 0.75);
      canvas.drawCircle(pos, 2.2, _fillPaint);
    }
  }

  // ── 7. Celestial Orb ──────────────────────────────────────────────────────────
  //
  //  POSITION = currentTimeAngle (real device clock).
  //  APPEARANCE = driven by minutesToBedtime proximity:
  //    > 20 min away  → full sun (white + rays)
  //    20 → 0 min     → sun fades, moon emerges
  //    ≤ 0 (missed)   → moon with warm amber cast
  void _drawCelestialOrb(Canvas canvas, Offset pos) {
    // t: 0.0 = full sun (far from bedtime), 1.0 = full moon (at bedtime)
    final double t = ((20.0 - minutesToBedtime.toDouble()) / 20.0).clamp(
      0.0,
      1.0,
    );

    const Color iconColor = AppColors.white;
    const Color glowColor = AppColors.white;
    final double glowRadius = 18.0 + t * 4.0;

    // Glow disc
    _glowPaint.shader = RadialGradient(
      colors: [glowColor.withValues(alpha: 0.25), AppColors.transparent],
    ).createShader(Rect.fromCircle(center: pos, radius: glowRadius));
    canvas.drawCircle(pos, glowRadius, _glowPaint);

    if (t < 0.25 && !isSleepLogged && !isMissedBedtime) {
      // ── Full sun — Figma: prominent glowing dot ───────────────────────────────
      _fillPaint.color = iconColor;
      canvas.drawCircle(pos, 9.0, _fillPaint); // larger core dot

      final double rayAlpha = (0.60 * (1.0 - t / 0.25)).clamp(0.0, 0.60);
      _strokePaint
        ..color = iconColor.withValues(alpha: rayAlpha)
        ..strokeWidth = 1.5;
      for (int i = 0; i < 8; i++) {
        final double a = i * math.pi / 4;
        canvas.drawLine(
          Offset(pos.dx + 12.5 * math.cos(a), pos.dy + 12.5 * math.sin(a)),
          Offset(pos.dx + 17.5 * math.cos(a), pos.dy + 17.5 * math.sin(a)),
          _strokePaint,
        );
      }
    } else {
      // ── Moon (partial or full) ───────────────────────────────────────────────
      final double moonAlpha = isSleepLogged
          ? 0.85
          : (t >= 0.25 ? 1.0 : (t / 0.25));
      _fillPaint.color = iconColor.withValues(alpha: moonAlpha.clamp(0.0, 1.0));
      final moonPath = Path()
        ..moveTo(pos.dx - 5.6, pos.dy - 8.4)
        ..quadraticBezierTo(pos.dx + 8.4, pos.dy, pos.dx - 5.6, pos.dy + 8.4)
        ..quadraticBezierTo(pos.dx + 2.8, pos.dy, pos.dx - 5.6, pos.dy - 8.4);
      canvas.drawPath(moonPath, _fillPaint);

      // Tiny star when fully moon (t > 0.70)
      if (t > 0.70 && !isSleepLogged) {
        final double starAlpha = ((t - 0.70) / 0.30).clamp(0.0, 1.0) * 0.80;
        _fillPaint.color = iconColor.withValues(alpha: starAlpha);
        canvas.drawCircle(Offset(pos.dx + 8.0, pos.dy - 7.0), 1.8, _fillPaint);
      }
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────

  /// Beacon/arc color for missed-bedtime: Teal (0.0) -> MintLight (0.5) -> Mint (1.0)
  Color _missedBeaconColor(double ratio) {
    if (ratio < 0.5) {
      return Color.lerp(
        AppColors.primaryButtonColor,
        AppColors.mintLight,
        ratio * 2,
      )!;
    } else {
      return Color.lerp(
        AppColors.mintLight,
        AppColors.mint,
        (ratio - 0.5) * 2,
      )!;
    }
  }

  @override
  bool shouldRepaint(covariant SleepOrbitPainter old) {
    return old.breathValue != breathValue ||
        old.beaconPulse != beaconPulse ||
        old.rippleValue != rippleValue ||
        old.currentTimeAngle != currentTimeAngle ||
        old.beaconAngle != beaconAngle ||
        old.minutesToBedtime != minutesToBedtime ||
        old.isSleepLogged != isSleepLogged ||
        old.isSleepPrep != isSleepPrep ||
        old.isMissedBedtime != isMissedBedtime ||
        old.missedOverdueRatio != missedOverdueRatio;
  }
}
