import 'package:chrisimhof/core/common/widgets/app_translations.dart';
import 'package:chrisimhof/features/auth/baseline_setup/service/baseline_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BaselineEnums Normalization Tests', () {
    test('Chronotype normalizer handles English, French, and enum keys', () {
      expect(BaselineEnums.normalizeChronotype('morning'), 'morning');
      expect(BaselineEnums.normalizeChronotype('Early Bird'), 'morning');
      expect(BaselineEnums.normalizeChronotype('matinal'), 'morning');

      expect(BaselineEnums.normalizeChronotype('intermediate'), 'intermediate');
      expect(BaselineEnums.normalizeChronotype('Intermediate'), 'intermediate');
      expect(BaselineEnums.normalizeChronotype('intermédiaire'), 'intermediate');

      expect(BaselineEnums.normalizeChronotype('evening'), 'evening');
      expect(BaselineEnums.normalizeChronotype('Night Owl'), 'evening');
      expect(BaselineEnums.normalizeChronotype('couche-tard'), 'evening');
    });

    test('Caffeine sensitivity normalizer handles English, French, and enum keys', () {
      expect(BaselineEnums.normalizeCaffeineSensitivity('low'), 'low');
      expect(BaselineEnums.normalizeCaffeineSensitivity('Low'), 'low');
      expect(BaselineEnums.normalizeCaffeineSensitivity('faible'), 'low');

      expect(BaselineEnums.normalizeCaffeineSensitivity('medium'), 'medium');
      expect(BaselineEnums.normalizeCaffeineSensitivity('Medium sensitivity'), 'medium');
      expect(BaselineEnums.normalizeCaffeineSensitivity('modérée'), 'medium');

      expect(BaselineEnums.normalizeCaffeineSensitivity('high'), 'high');
      expect(BaselineEnums.normalizeCaffeineSensitivity('High sensitivity'), 'high');
      expect(BaselineEnums.normalizeCaffeineSensitivity('élevée'), 'high');
    });

    test('Sport profile normalizer handles English, French, and legacy keys', () {
      expect(BaselineEnums.normalizeSportProfile('sedentary'), 'sedentary');
      expect(BaselineEnums.normalizeSportProfile('Sédentaire'), 'sedentary');

      expect(BaselineEnums.normalizeSportProfile('light'), 'light');
      expect(BaselineEnums.normalizeSportProfile('Lightly active'), 'light');
      expect(BaselineEnums.normalizeSportProfile('Peu actif'), 'light');

      expect(BaselineEnums.normalizeSportProfile('cardio'), 'cardio');
      expect(BaselineEnums.normalizeSportProfile('Active'), 'cardio');
      expect(BaselineEnums.normalizeSportProfile('Actif'), 'cardio');

      expect(BaselineEnums.normalizeSportProfile('strength'), 'strength');
      expect(BaselineEnums.normalizeSportProfile('Very active'), 'strength');
      expect(BaselineEnums.normalizeSportProfile('Très actif'), 'strength');
      expect(BaselineEnums.normalizeSportProfile('Force'), 'strength');

      expect(BaselineEnums.normalizeSportProfile('mixed'), 'mixed');
      expect(BaselineEnums.normalizeSportProfile('Varied training'), 'mixed');
      expect(BaselineEnums.normalizeSportProfile('Pratique variée'), 'mixed');
      expect(BaselineEnums.normalizeSportProfile('Mixte'), 'mixed');

      expect(BaselineEnums.normalizeSportProfile('endurance'), 'endurance');
      expect(BaselineEnums.normalizeSportProfile('Intensive'), 'endurance');
      expect(BaselineEnums.normalizeSportProfile('Intensif'), 'endurance');
    });
  });

  group('AppTranslations French Baseline Tests', () {
    final translations = AppTranslations();
    final fr = translations.keys['fr_FR']!;

    test('French Chronotype translations match PDF spec', () {
      expect(fr['Early Bird'], 'Matinal');
      expect(fr['Intermediate'], 'Intermédiaire');
      expect(fr['Night Owl'], 'Couche-tard');
      expect(fr['Your chronotype affects when you should ideally sleep and wake.'],
          'Votre chronotype influence vos heures idéales de coucher et de réveil.');
      expect(fr['05:00 - 21:00'], '05:00 - 21:00');
      expect(fr['07:00 - 23:00'], '07:00 - 23:00');
      expect(fr['10:00 - 02:00'], '10:00 - 02:00');
    });

    test('French Caffeine translations match PDF spec', () {
      expect(fr['Low'], 'Faible');
      expect(fr['Moderate'], 'Modérée');
      expect(fr['High'], 'Élevée');
      expect(fr['Low sensitivity'], 'Sensibilité faible');
      expect(fr['Medium sensitivity'], 'Sensibilité modérée');
      expect(fr['High sensitivity'], 'Sensibilité élevée');
      expect(fr['Minimal sleep disruption'], 'Peu de perturbations du sommeil');
      expect(fr['Some sleep impact after 14:00'], 'Effet sur le sommeil après 14:00');
      expect(fr['Avoid caffeine after 12:00'], 'Éviter la caféine après 12:00');
    });

    test('French Sport profile translations match PDF spec', () {
      expect(fr['Sedentary'], 'Sédentaire');
      expect(fr['Lightly active'], 'Peu actif');
      expect(fr['Active'], 'Actif');
      expect(fr['Very active'], 'Très actif');
      expect(fr['Varied training'], 'Pratique variée');
      expect(fr['Intensive'], 'Intensif');
      expect(fr['Little to no exercise'], 'Peu ou pas d’activité physique');
      expect(fr['1-2x per week'], '1 à 2 fois par semaine');
      expect(fr['3-4x per week'], '3 à 4 fois par semaine');
      expect(fr['5-6x per week'], '5 à 6 fois par semaine');
      expect(fr['Mixed training'], 'Entraînements variés');
      expect(fr['Intense training daily'], 'Entraînement intense quotidien');
    });

    test('French Weekly workout goal and Wearables match PDF spec', () {
      expect(fr['workout / week'], 'séance par semaine');
      expect(fr['workouts / week'], 'séances par semaine');
      expect(fr['Sync sleep + workouts'], 'Synchroniser sommeil et entraînements');
      expect(fr['Soon'], 'Bientôt');
    });
  });
}
