import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';

/// Fatigue Prediction Bar Chart
class FatigueWeekChart extends StatelessWidget {
  final List<double> weeklyData;

  const FatigueWeekChart({super.key, required this.weeklyData});

  @override
  Widget build(BuildContext context) {
    final List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    const double maxBarHeight = 65.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(weeklyData.length, (index) {
        final val = weeklyData[index];
        final barHeight = val * maxBarHeight;

        // Choose color based on height/value
        Color barColor = AppColors.orangeAccent; // Default orange
        if (val >= 0.7) {
          barColor = AppColors.primaryButtonColor; // Green/teal
        } else if (val < 0.3) {
          barColor = AppColors.redBright; // Pink/red
        }

        return Column(
          children: [
            SizedBox(
              height: maxBarHeight,
              width: 32,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutBack,
                    height: barHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              days[index],
              style: getTextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSoft,
              ),
            ),
          ],
        );
      }),
    );
  }
}
