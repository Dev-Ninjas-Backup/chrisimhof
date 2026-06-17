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
    sportProfileLight: 'Light activity',
    sportProfileCardio: 'Cardio',
    sportProfileStrength: 'Strength',
    sportProfileMixed: 'Mixed',
    sportProfileEndurance: 'Endurance',
  };

  static String normalizeChronotype(dynamic value) {
    return _normalize(value, chronotype, defaultChronotype);
  }

  static String normalizeCaffeineSensitivity(dynamic value) {
    return _normalize(value, caffeineSensitivity, defaultCaffeineSensitivity);
  }

  static String normalizeSportProfile(dynamic value) {
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
