import 'package:chrisimhof/core/service/helper/shift_display_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShiftDisplayHelper Tests', () {
    test('Automatic language adaptation for French', () {
      // Day -> J in French
      expect(ShiftDisplayHelper.getDisplayCode('Day', isFrench: true), 'J');
      expect(ShiftDisplayHelper.getDisplayCode('day', isFrench: true), 'J');
      expect(ShiftDisplayHelper.getDisplayCode('D', isFrench: true), 'J');
      expect(ShiftDisplayHelper.getDisplayCode('Jour', isFrench: true), 'J');
      expect(ShiftDisplayHelper.getDisplayCode('jour', isFrench: true), 'J');
      expect(ShiftDisplayHelper.getDisplayCode('j', isFrench: true), 'J');

      // Evening -> A in French
      expect(ShiftDisplayHelper.getDisplayCode('Evening', isFrench: true), 'A');
      expect(ShiftDisplayHelper.getDisplayCode('evening', isFrench: true), 'A');
      expect(ShiftDisplayHelper.getDisplayCode('E', isFrench: true), 'A');
      expect(ShiftDisplayHelper.getDisplayCode('Après-midi', isFrench: true), 'A');
      expect(ShiftDisplayHelper.getDisplayCode('apres-midi', isFrench: true), 'A');
      expect(ShiftDisplayHelper.getDisplayCode('a', isFrench: true), 'A');

      // Night -> N in French
      expect(ShiftDisplayHelper.getDisplayCode('Night', isFrench: true), 'N');
      expect(ShiftDisplayHelper.getDisplayCode('night', isFrench: true), 'N');
      expect(ShiftDisplayHelper.getDisplayCode('N', isFrench: true), 'N');
      expect(ShiftDisplayHelper.getDisplayCode('Nuit', isFrench: true), 'N');
      expect(ShiftDisplayHelper.getDisplayCode('nuit', isFrench: true), 'N');
      expect(ShiftDisplayHelper.getDisplayCode('n', isFrench: true), 'N');

      // Off -> Repos in French
      expect(ShiftDisplayHelper.getDisplayCode('Off', isFrench: true), 'Repos');
      expect(ShiftDisplayHelper.getDisplayCode('off', isFrench: true), 'Repos');
      expect(ShiftDisplayHelper.getDisplayCode('Repos', isFrench: true), 'Repos');
      expect(ShiftDisplayHelper.getDisplayCode('repos', isFrench: true), 'Repos');
    });

    test('Automatic language adaptation for English', () {
      // Day -> D in English
      expect(ShiftDisplayHelper.getDisplayCode('Day', isFrench: false), 'D');
      expect(ShiftDisplayHelper.getDisplayCode('day', isFrench: false), 'D');
      expect(ShiftDisplayHelper.getDisplayCode('D', isFrench: false), 'D');
      expect(ShiftDisplayHelper.getDisplayCode('Jour', isFrench: false), 'D');

      // Evening -> E in English
      expect(ShiftDisplayHelper.getDisplayCode('Evening', isFrench: false), 'E');
      expect(ShiftDisplayHelper.getDisplayCode('evening', isFrench: false), 'E');
      expect(ShiftDisplayHelper.getDisplayCode('E', isFrench: false), 'E');
      expect(ShiftDisplayHelper.getDisplayCode('Après-midi', isFrench: false), 'E');

      // Night -> N in English
      expect(ShiftDisplayHelper.getDisplayCode('Night', isFrench: false), 'N');
      expect(ShiftDisplayHelper.getDisplayCode('N', isFrench: false), 'N');

      // Off -> Off in English
      expect(ShiftDisplayHelper.getDisplayCode('Off', isFrench: false), 'Off');
      expect(ShiftDisplayHelper.getDisplayCode('Repos', isFrench: false), 'Off');
    });

    test('Custom named shifts derive first uppercase letter', () {
      expect(ShiftDisplayHelper.getDisplayCode('Matin', isFrench: true), 'M');
      expect(ShiftDisplayHelper.getDisplayCode('Matin', isFrench: false), 'M');
      expect(ShiftDisplayHelper.getDisplayCode('Soir', isFrench: true), 'S');
    });

    test('Explicit custom short codes (e.g. DN) are preserved', () {
      expect(ShiftDisplayHelper.getDisplayCode('DN', isFrench: true), 'DN');
      expect(ShiftDisplayHelper.getDisplayCode('DN', isFrench: false), 'DN');
      expect(
        ShiftDisplayHelper.getDisplayCode('Night', customOverride: 'DN', isFrench: true),
        'DN',
      );
    });

    test('Shift categories and colors', () {
      expect(ShiftDisplayHelper.getShiftCategory('Day'), 'day');
      expect(ShiftDisplayHelper.getShiftCategory('Jour'), 'day');
      expect(ShiftDisplayHelper.getShiftCategory('D'), 'day');
      expect(ShiftDisplayHelper.getShiftCategory('J'), 'day');

      expect(ShiftDisplayHelper.getShiftCategory('Evening'), 'evening');
      expect(ShiftDisplayHelper.getShiftCategory('Après-midi'), 'evening');
      expect(ShiftDisplayHelper.getShiftCategory('E'), 'evening');
      expect(ShiftDisplayHelper.getShiftCategory('A'), 'evening');

      expect(ShiftDisplayHelper.getShiftCategory('Night'), 'night');
      expect(ShiftDisplayHelper.getShiftCategory('Nuit'), 'night');
      expect(ShiftDisplayHelper.getShiftCategory('N'), 'night');
      expect(ShiftDisplayHelper.getShiftCategory('DN'), 'night');

      expect(ShiftDisplayHelper.getShiftCategory('Off'), 'off');
      expect(ShiftDisplayHelper.getShiftCategory('Repos'), 'off');
    });

    test('toCanonicalApiKey isolates backend wire format from French translations', () {
      // Day variants
      expect(ShiftDisplayHelper.toCanonicalApiKey('Day'), 'day');
      expect(ShiftDisplayHelper.toCanonicalApiKey('Jour'), 'day');
      expect(ShiftDisplayHelper.toCanonicalApiKey('jour'), 'day');
      expect(ShiftDisplayHelper.toCanonicalApiKey('J'), 'day');
      expect(ShiftDisplayHelper.toCanonicalApiKey('D'), 'day');

      // Evening variants (must strictly be 'evening', never 'après-midi' or 'a')
      expect(ShiftDisplayHelper.toCanonicalApiKey('Evening'), 'evening');
      expect(ShiftDisplayHelper.toCanonicalApiKey('Après-midi'), 'evening');
      expect(ShiftDisplayHelper.toCanonicalApiKey('apres-midi'), 'evening');
      expect(ShiftDisplayHelper.toCanonicalApiKey('A'), 'evening');
      expect(ShiftDisplayHelper.toCanonicalApiKey('E'), 'evening');

      // Night variants
      expect(ShiftDisplayHelper.toCanonicalApiKey('Night'), 'night');
      expect(ShiftDisplayHelper.toCanonicalApiKey('Nuit'), 'night');
      expect(ShiftDisplayHelper.toCanonicalApiKey('nuit'), 'night');
      expect(ShiftDisplayHelper.toCanonicalApiKey('N'), 'night');
      expect(ShiftDisplayHelper.toCanonicalApiKey('DN'), 'night');

      // Off variants
      expect(ShiftDisplayHelper.toCanonicalApiKey('Off'), 'off');
      expect(ShiftDisplayHelper.toCanonicalApiKey('Repos'), 'off');
      expect(ShiftDisplayHelper.toCanonicalApiKey('repos'), 'off');
      expect(ShiftDisplayHelper.toCanonicalApiKey('R'), 'off');
      expect(ShiftDisplayHelper.toCanonicalApiKey(''), 'off');
    });

    test('toCanonicalPatternCode strictly maps to [D, E, N, Off] and never French initials', () {
      // Evening MUST be 'E', NEVER 'A'
      expect(ShiftDisplayHelper.toCanonicalPatternCode('Evening'), 'E');
      expect(ShiftDisplayHelper.toCanonicalPatternCode('Après-midi'), 'E');
      expect(ShiftDisplayHelper.toCanonicalPatternCode('A'), 'E');
      expect(ShiftDisplayHelper.toCanonicalPatternCode('E'), 'E');

      // Day MUST be 'D', NEVER 'J'
      expect(ShiftDisplayHelper.toCanonicalPatternCode('Day'), 'D');
      expect(ShiftDisplayHelper.toCanonicalPatternCode('Jour'), 'D');
      expect(ShiftDisplayHelper.toCanonicalPatternCode('J'), 'D');
      expect(ShiftDisplayHelper.toCanonicalPatternCode('D'), 'D');

      // Night MUST be 'N'
      expect(ShiftDisplayHelper.toCanonicalPatternCode('Night'), 'N');
      expect(ShiftDisplayHelper.toCanonicalPatternCode('Nuit'), 'N');
      expect(ShiftDisplayHelper.toCanonicalPatternCode('DN'), 'N');

      // Off MUST be 'Off', NEVER 'Repos'
      expect(ShiftDisplayHelper.toCanonicalPatternCode('Off'), 'Off');
      expect(ShiftDisplayHelper.toCanonicalPatternCode('Repos'), 'Off');
      expect(ShiftDisplayHelper.toCanonicalPatternCode(''), 'Off');
    });
  });
}
