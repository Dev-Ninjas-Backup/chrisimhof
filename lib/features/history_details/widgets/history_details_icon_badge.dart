import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class HistoryDetailsIconBadge extends StatelessWidget {
  final String iconKey;
  final double size;

  const HistoryDetailsIconBadge({
    super.key,
    required this.iconKey,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      _resolveIcon(iconKey),
      size: size,
      color: AppColors.primaryButtonColor,
    );
  }

  IconData _resolveIcon(String key) {
    switch (key) {
      case 'sleep':
        return Icons.nightlight_round;
      case 'hydration':
        return Icons.water_drop_rounded;
      case 'caffeine':
        return Icons.local_cafe_rounded;
      case 'nutrition':
        return Icons.apple_rounded;
      case 'sport':
        return Icons.sports_tennis_rounded;
      default:
        return Icons.circle_rounded;
    }
  }
}
