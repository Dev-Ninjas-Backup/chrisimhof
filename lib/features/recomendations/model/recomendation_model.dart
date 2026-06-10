import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:flutter/material.dart';

class RecomendationModel {
  final String title;
  final String description;
  final int count;

  RecomendationModel({
    required this.title,
    required this.description,
    required this.count,
  });

  // Factory constructor in case they need to deserialize from JSON in the future
  factory RecomendationModel.fromJson(Map<String, dynamic> json) {
    return RecomendationModel(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }
}

class RecomendationStyle {
  final String iconPath;
  final Color iconBgColor;
  final Color iconColor;
  final Color badgeBgColor;
  final Color badgeTextColor;

  const RecomendationStyle({
    required this.iconPath,
    required this.iconBgColor,
    required this.iconColor,
    required this.badgeBgColor,
    required this.badgeTextColor,
  });
}

class RecomendationStyleHelper {
  static const Map<String, RecomendationStyle> _styles = {
    'Sleep': RecomendationStyle(
      iconPath: IconPath.sleep,
      iconBgColor: AppColors.blueSoft,
      iconColor: Color(0xFF6366F1),
      badgeBgColor: AppColors.indigoSoft,
      badgeTextColor: Color(0xFF6366F1),
    ),
    'Caffeine': RecomendationStyle(
      iconPath: IconPath.caffeine,
      iconBgColor: Color(0xFFFFF7ED),
      iconColor: Color(0xFFD97706),
      badgeBgColor: Color(0xFFFFF7ED),
      badgeTextColor: Color(0xFFD97706),
    ),
    'Hydration': RecomendationStyle(
      iconPath: IconPath.hydration,
      iconBgColor: Color(0xFFEFF6FF),
      iconColor: Color(0xFF3B82F6),
      badgeBgColor: Color(0xFFEFF6FF),
      badgeTextColor: Color(0xFF3B82F6),
    ),
    'Nutrition': RecomendationStyle(
      iconPath: IconPath.nutrition,
      iconBgColor: Color(0xFFECFDF5),
      iconColor: Color(0xFF10B981),
      badgeBgColor: Color(0xFFECFDF5),
      badgeTextColor: Color(0xFF10B981),
    ),
    'Sport': RecomendationStyle(
      iconPath: IconPath.sport,
      iconBgColor: Color(0xFFF5F3FF),
      iconColor: Color(0xFF8B5CF6),
      badgeBgColor: Color(0xFFF5F3FF),
      badgeTextColor: Color(0xFF8B5CF6),
    ),
    'Work': RecomendationStyle(
      iconPath: IconPath.work,
      iconBgColor: Color(0xFFECFEFF),
      iconColor: Color(0xFF0D9488),
      badgeBgColor: Color(0xFFECFEFF),
      badgeTextColor: Color(0xFF0D9488),
    ),
    'Fatigue': RecomendationStyle(
      iconPath: IconPath.fatigue,
      iconBgColor: Color(0xFFFEF2F2),
      iconColor: Color(0xFFEF4444),
      badgeBgColor: Color(0xFFFEF2F2),
      badgeTextColor: Color(0xFFEF4444),
    ),
  };

  /// Returns the specific visual styling based on the recommendation title.
  /// Standardizes design characteristics across components.
  static RecomendationStyle getStyle(String title) {
    return _styles[title] ??
        const RecomendationStyle(
          iconPath: IconPath.vector,
          iconBgColor: Color(0xFFF3F4F6),
          iconColor: Color(0xFF9CA3AF),
          badgeBgColor: Color(0xFFF3F4F6),
          badgeTextColor: Color(0xFF9CA3AF),
        );
  }
}
