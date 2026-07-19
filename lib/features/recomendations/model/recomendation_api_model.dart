import 'dart:ui';

import 'package:chrisimhof/core/const/app_colors.dart';

import '../../../core/const/icon_path.dart';

class RecommendationResponse {
  bool? success;
  String? message;
  RecommendationData? data;

  RecommendationResponse({
    this.success,
    this.message,
    this.data,
  });

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) {
    return RecommendationResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? RecommendationData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.toJson(),
      };
}

class RecommendationData {
  String? sessionId;
  bool? ready;
  int? totalActions;
  String? actionsLabel;
  String? contextNote;
  String? message;
  List<RecommendationItem>? recommendations;
  GroupedRecommendations? grouped;

  RecommendationData({
    this.sessionId,
    this.ready,
    this.totalActions,
    this.actionsLabel,
    this.contextNote,
    this.message,
    this.recommendations,
    this.grouped,
  });

  factory RecommendationData.fromJson(Map<String, dynamic> json) {
    return RecommendationData(
      sessionId: json['sessionId'],
      ready: json['ready'],
      totalActions: json['totalActions'],
      actionsLabel: json['actionsLabel'],
      contextNote: json['contextNote'],
      message: json['message'],
      recommendations: (json['recommendations'] as List?)
          ?.map((e) => RecommendationItem.fromJson(e))
          .toList(),
      grouped: json['grouped'] != null
          ? GroupedRecommendations.fromJson(json['grouped'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'ready': ready,
        'totalActions': totalActions,
        'actionsLabel': actionsLabel,
        'contextNote': contextNote,
        'message': message,
        'recommendations':
            recommendations?.map((e) => e.toJson()).toList(),
        'grouped': grouped?.toJson(),
      };
}

class RecommendationItem {
  String? category;
  int? priority;
  bool? isPremium;
  String? title;
  String? body;
  String? titleKey;
  String? bodyKey;
  Map<String, dynamic>? bodyParams;

  RecommendationItem({
    this.category,
    this.priority,
    this.isPremium,
    this.title,
    this.body,
    this.titleKey,
    this.bodyKey,
    this.bodyParams,
  });

  factory RecommendationItem.fromJson(Map<String, dynamic> json) {
    return RecommendationItem(
      category: json['category'],
      priority: json['priority'],
      isPremium: json['isPremium'],
      title: json['title'],
      body: json['body'],
      titleKey: json['titleKey'],
      bodyKey: json['bodyKey'],
      bodyParams: json['bodyParams'] != null
          ? Map<String, dynamic>.from(json['bodyParams'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'category': category,
        'priority': priority,
        'isPremium': isPremium,
        'title': title,
        'body': body,
        'titleKey': titleKey,
        'bodyKey': bodyKey,
        'bodyParams': bodyParams,
      };
}

class GroupedRecommendations {
  List<RecommendationItem>? Sleep;
  List<RecommendationItem>? Caffeine;
  List<RecommendationItem>? Hydration;
  List<RecommendationItem>? Sport;
  List<RecommendationItem>? Nutrition;
  List<RecommendationItem>? Fatigue;
  List<RecommendationItem>? Work;

  GroupedRecommendations({
    this.Sleep,
    this.Caffeine,
    this.Hydration,
    this.Sport,
    this.Nutrition,
    this.Fatigue,
    this.Work,
  });

  factory GroupedRecommendations.fromJson(Map<String, dynamic> json) {
    List<RecommendationItem>? parseList(dynamic value) {
      return (value as List?)
          ?.map((e) => RecommendationItem.fromJson(e))
          .toList();
    }

    return GroupedRecommendations(
      Sleep: parseList(json['sleep']),
      Caffeine: parseList(json['caffeine']),
      Hydration: parseList(json['hydration']),
      Sport: parseList(json['sport']),
      Nutrition: parseList(json['nutrition']),
      Fatigue: parseList(json['fatigue']),
      Work: parseList(json['work']),
    );
  }

  Map<String, dynamic> toJson() => {
        'Sleep': Sleep?.map((e) => e.toJson()).toList(),
        'Caffeine': Caffeine?.map((e) => e.toJson()).toList(),
        'Hydration': Hydration?.map((e) => e.toJson()).toList(),
        'Sport': Sport?.map((e) => e.toJson()).toList(),
        'Nutrition': Nutrition?.map((e) => e.toJson()).toList(),
        'Fatigue': Fatigue?.map((e) => e.toJson()).toList(),
        'Work': Work?.map((e) => e.toJson()).toList(),
      };
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
  static RecomendationStyle getStyle(String? title) {
    if (title == null) {
      return const RecomendationStyle(
        iconPath: IconPath.vector,
        iconBgColor: Color(0xFFF3F4F6),
        iconColor: Color(0xFF9CA3AF),
        badgeBgColor: Color(0xFFF3F4F6),
        badgeTextColor: Color(0xFF9CA3AF),
      );
    }
    final normalized = title.isNotEmpty
        ? title[0].toUpperCase() + title.substring(1).toLowerCase()
        : title;
    return _styles[normalized] ??
        const RecomendationStyle(
          iconPath: IconPath.vector,
          iconBgColor: Color(0xFFF3F4F6),
          iconColor: Color(0xFF9CA3AF),
          badgeBgColor: Color(0xFFF3F4F6),
          badgeTextColor: Color(0xFF9CA3AF),
        );
  }
}





