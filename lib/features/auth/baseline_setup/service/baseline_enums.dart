class BaselineEnums {
  static const String chronotypeMorning = 'morning';
  static const String chronotypeIntermediate = 'intermediate';
  static const String chronotypeEvening = 'evening';

  static const String caffeineSensitivityLow = 'low';
  static const String caffeineSensitivityMedium = 'medium';
  static const String caffeineSensitivityHigh = 'high';

  static const String sportProfileSedentary = 'sedentary';
  static const String sportProfileLight = 'light';
  static const String sportProfileCardio = 'cardio';
  static const String sportProfileStrength = 'strength';
  static const String sportProfileMixed = 'mixed';
  static const String sportProfileEndurance = 'endurance';

  static const String defaultChronotype = chronotypeIntermediate;
  static const String defaultCaffeineSensitivity = caffeineSensitivityMedium;
  static const String defaultSportProfile = sportProfileLight;

  // CHRONOTYPE (STRICT 1:1)
  static const Map<String, String> chronotype = {
    chronotypeMorning: 'Early Bird',
    chronotypeIntermediate: 'Intermediate',
    chronotypeEvening: 'Night Owl',
  };

  // CAFFEINE (STRICT 1:1)
  static const Map<String, String> caffeineSensitivity = {
    caffeineSensitivityLow: 'Low sensitivity',
    caffeineSensitivityMedium: 'Medium sensitivity',
    caffeineSensitivityHigh: 'High sensitivity',
  };

  // SPORT PROFILE (STRICT 1:1)
  static const Map<String, String> sportProfile = {
    sportProfileSedentary: 'Sedentary',
    sportProfileLight: 'Lightly active',
    sportProfileCardio: 'Active',
    sportProfileStrength: 'Very active',
    sportProfileMixed: 'Varied training',
    sportProfileEndurance: 'Intensive',
  };

  static String normalizeChronotype(dynamic value) {
    final str = value?.toString().toLowerCase().trim();
    if (str == null || str.isEmpty) return defaultChronotype;
    if (str == 'morning' || str == 'early bird' || str == 'matinal') {
      return chronotypeMorning;
    }
    if (str == 'intermediate' ||
        str == 'intermédiaire' ||
        str == 'intermediaire') {
      return chronotypeIntermediate;
    }
    if (str == 'evening' ||
        str == 'night owl' ||
        str == 'couche-tard' ||
        str == 'couche tard') {
      return chronotypeEvening;
    }
    return _normalize(value, chronotype, defaultChronotype);
  }

  static String normalizeCaffeineSensitivity(dynamic value) {
    final str = value?.toString().toLowerCase().trim();
    if (str == null || str.isEmpty) return defaultCaffeineSensitivity;
    if (str == 'low' ||
        str == 'low sensitivity' ||
        str == 'faible' ||
        str == 'sensibilité faible') {
      return caffeineSensitivityLow;
    }
    if (str == 'medium' ||
        str == 'moderate' ||
        str == 'medium sensitivity' ||
        str == 'modérée' ||
        str == 'moderee' ||
        str == 'sensibilité modérée') {
      return caffeineSensitivityMedium;
    }
    if (str == 'high' ||
        str == 'high sensitivity' ||
        str == 'élevée' ||
        str == 'elevee' ||
        str == 'sensibilité élevée') {
      return caffeineSensitivityHigh;
    }
    return _normalize(value, caffeineSensitivity, defaultCaffeineSensitivity);
  }

  static String normalizeSportProfile(dynamic value) {
    final str = value?.toString().toLowerCase().trim();
    if (str == null || str.isEmpty) return defaultSportProfile;
    if (str == 'sedentary' || str == 'sédentaire') {
      return sportProfileSedentary;
    }
    if (str == 'light' ||
        str == 'lightly active' ||
        str == 'peu actif' ||
        str == 'light activity') {
      return sportProfileLight;
    }
    if (str == 'cardio' || str == 'active' || str == 'actif') {
      return sportProfileCardio;
    }
    if (str == 'strength' ||
        str == 'very active' ||
        str == 'très actif' ||
        str == 'tres actif' ||
        str == 'force') {
      return sportProfileStrength;
    }
    if (str == 'mixed' ||
        str == 'varied training' ||
        str == 'pratique variée' ||
        str == 'pratique variee' ||
        str == 'mixte') {
      return sportProfileMixed;
    }
    if (str == 'endurance' || str == 'intensive' || str == 'intensif') {
      return sportProfileEndurance;
    }
    return _normalize(value, sportProfile, defaultSportProfile);
  }

  static String _normalize(
    dynamic value,
    Map<String, String> allowedValues,
    String fallback,
  ) {
    final enumValue = value?.toString();
    if (enumValue != null && allowedValues.containsKey(enumValue)) {
      return enumValue;
    }

    final displayValue = enumValue?.toLowerCase().trim();
    if (displayValue != null) {
      for (final entry in allowedValues.entries) {
        if (entry.value.toLowerCase() == displayValue) {
          return entry.key;
        }
      }
    }

    return fallback;
  }
}
