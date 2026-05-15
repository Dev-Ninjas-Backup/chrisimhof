import 'package:flutter/material.dart';

class CalculatorTabSwipeDetector extends StatelessWidget {
  const CalculatorTabSwipeDetector({
    super.key,
    required this.child,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    this.swipeVelocityThreshold = 250,
  });

  final Widget child;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final double swipeVelocityThreshold;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;

        if (velocity <= -swipeVelocityThreshold) {
          onSwipeLeft();
          return;
        }

        if (velocity >= swipeVelocityThreshold) {
          onSwipeRight();
        }
      },
      child: child,
    );
  }
}
