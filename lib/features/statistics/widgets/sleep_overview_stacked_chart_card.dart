import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/statistics/controller/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SleepOverviewStackedChartCard extends StatelessWidget {
  final StatisticsController controller;

  const SleepOverviewStackedChartCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final avgDisplay = controller.sleepDurationValue.value.isNotEmpty
          ? controller.sleepDurationValue.value
          : '7 h 30';
      final napsCount = controller.totalNapsInPeriod.value;
      final _ = controller.selectedPeriod.value;
      final bars = controller.sleepBarsList.toList();

      return Container(
        padding: const EdgeInsets.all(20),
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
                  Icons.bedtime_outlined,
                  size: 20,
                  color: Color(0xFF10B981),
                ),
                const SizedBox(width: 8),
                Text(
                  'Sommeil'.tr,
                  style: getTextStyle2(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Stats & Legend
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        avgDisplay,
                        style: getTextStyle2(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'en moyenne par jour'.tr,
                        style: getTextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '$napsCount ${'siestes sur la période'.tr}',
                        style: getTextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Legend
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFF047857),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Sommeil principal'.tr,
                              style: getTextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFFA7F3D0),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Siestes'.tr,
                              style: getTextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Right Column: Stacked Bar Chart
                Expanded(
                  flex: 7,
                  child: SizedBox(
                    height: 140,
                    child: CustomPaint(
                      painter: _SleepStackedBarPainter(bars: bars),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _SleepStackedBarPainter extends CustomPainter {
  final List<Map<String, dynamic>> bars;

  _SleepStackedBarPainter({required this.bars});

  @override
  void paint(Canvas canvas, Size size) {
    const leftMargin = 30.0;
    const bottomMargin = 20.0;
    const topMargin = 6.0;

    final chartWidth = size.width - leftMargin;
    final chartHeight = size.height - bottomMargin - topMargin;

    // Draw Y-axis gridlines & labels (0h, 3h, 6h, 9h, 12h)
    final gridPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..strokeWidth = 0.8;

    final labelStyle = getTextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF94A3B8),
    );

    final ySteps = [0, 3, 6, 9, 12];
    for (final val in ySteps) {
      final y = topMargin + chartHeight * (1.0 - val / 12.0);

      canvas.drawLine(
        Offset(leftMargin, y),
        Offset(size.width, y),
        gridPaint,
      );

      final textSpan = TextSpan(text: '${val}h', style: labelStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(leftMargin - textPainter.width - 4, y - textPainter.height / 2),
      );
    }

    if (bars.isEmpty) return;

    final n = bars.length;
    const barWidth = 14.0;
    final slotWidth = chartWidth / n;

    final mainPaint = Paint()..color = const Color(0xFF047857);
    final napPaint = Paint()..color = const Color(0xFFA7F3D0);

    for (int i = 0; i < n; i++) {
      final bar = bars[i];
      final centerX = leftMargin + i * slotWidth + slotWidth / 2;
      final mainH = (bar['mainHours'] as num?)?.toDouble() ?? 0.0;
      final napH = (bar['napHours'] as num?)?.toDouble() ?? 0.0;

      final mainPixelHeight = (mainH / 12.0).clamp(0.0, 1.0) * chartHeight;
      final napPixelHeight = (napH / 12.0).clamp(0.0, 1.0) * chartHeight;

      final bottomY = topMargin + chartHeight;
      final mainTopY = bottomY - mainPixelHeight;
      final napTopY = mainTopY - napPixelHeight;

      final radius = const Radius.circular(3);

      // Draw Main Sleep Bar
      final mainRect = Rect.fromLTRB(
        centerX - barWidth / 2,
        mainTopY,
        centerX + barWidth / 2,
        bottomY,
      );
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          mainRect,
          topLeft: napH > 0 ? Radius.zero : radius,
          topRight: napH > 0 ? Radius.zero : radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        mainPaint,
      );

      // Draw Nap Bar on top if present
      if (napH > 0) {
        final napRect = Rect.fromLTRB(
          centerX - barWidth / 2,
          napTopY,
          centerX + barWidth / 2,
          mainTopY,
        );
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            napRect,
            topLeft: radius,
            topRight: radius,
          ),
          napPaint,
        );
      }

      // Draw X-axis day label
      final dayLabel = (bar['day'] as String?) ?? '';
      final daySpan = TextSpan(
        text: dayLabel,
        style: getTextStyle(
          fontSize: 10,
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
        Offset(centerX - dayPainter.width / 2, size.height - bottomMargin + 4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SleepStackedBarPainter oldDelegate) => true;
}
