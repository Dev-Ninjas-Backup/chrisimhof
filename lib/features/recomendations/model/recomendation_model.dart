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
      iconColor: AppColors.indigo,
      badgeBgColor: AppColors.indigoSoft,
      badgeTextColor: AppColors.indigo,
    ),
    'Caffeine': RecomendationStyle(
      iconPath: IconPath.caffeine,
      iconBgColor: AppColors.orangeSoft,
      iconColor: AppColors.amberDark,
      badgeBgColor: AppColors.orangeSoft,
      badgeTextColor: AppColors.amberDark,
    ),
    'Hydration': RecomendationStyle(
      iconPath: IconPath.hydration,
      iconBgColor: AppColors.indigoSoft2,
      iconColor: AppColors.blue,
      badgeBgColor: AppColors.indigoSoft2,
      badgeTextColor: AppColors.blue,
    ),
    'Nutrition': RecomendationStyle(
      iconPath: IconPath.nutrition,
      iconBgColor: AppColors.mintSoft2,
      iconColor: AppColors.secondaryButtonColor,
      badgeBgColor: AppColors.mintSoft2,
      badgeTextColor: AppColors.secondaryButtonColor,
    ),
    'Sport': RecomendationStyle(
      iconPath: IconPath.sport,
      iconBgColor: AppColors.indigoSoft3,
      iconColor: AppColors.violet,
      badgeBgColor: AppColors.indigoSoft3,
      badgeTextColor: AppColors.violet,
    ),
    'Work': RecomendationStyle(
      iconPath: IconPath.work,
      iconBgColor: AppColors.cyanSoft,
      iconColor: AppColors.teal,
      badgeBgColor: AppColors.cyanSoft,
      badgeTextColor: AppColors.teal,
    ),
    'Fatigue': RecomendationStyle(
      iconPath: IconPath.fatigue,
      iconBgColor: AppColors.roseSoft2,
      iconColor: AppColors.redBright,
      badgeBgColor: AppColors.roseSoft2,
      badgeTextColor: AppColors.redBright,
    ),
  };

  /// Returns the specific visual styling based on the recommendation title.
  /// Standardizes design characteristics across components.
  static RecomendationStyle getStyle(String title) {
    return _styles[title] ??
        const RecomendationStyle(
          iconPath: IconPath.vector,
          iconBgColor: AppColors.gray100,
          iconColor: AppColors.textSoft,
          badgeBgColor: AppColors.gray100,
          badgeTextColor: AppColors.textSoft,
        );
  }
}
