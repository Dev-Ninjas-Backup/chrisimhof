import 'package:chrisimhof/features/tutorial/controller/tutorial_controller.dart';
import 'package:chrisimhof/features/tutorial/model/tutorial_step.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('12 Tutorial Steps Model & Data Tests', () {
    test('TutorialData has exactly 12 steps numbered 1 through 12', () {
      expect(TutorialData.steps.length, 12);
      for (int i = 0; i < 12; i++) {
        expect(TutorialData.steps[i].stepIndex, i + 1);
      }
    });

    test('Each step has valid French and English content and action buttons', () {
      for (final step in TutorialData.steps) {
        expect(step.titleFr.isNotEmpty, true);
        expect(step.titleEn.isNotEmpty, true);
        expect(step.messageFr.isNotEmpty, true);
        expect(step.messageEn.isNotEmpty, true);
        expect(step.actionLabelFr.isNotEmpty, true);
        expect(step.actionLabelEn.isNotEmpty, true);
      }
    });

    test('Step 1 action is Commencer / Start and Step 12 is Terminer / Finish', () {
      final step1 = TutorialData.steps.first;
      expect(step1.actionLabelFr, 'Commencer');
      expect(step1.actionLabelEn, 'Start');

      final step12 = TutorialData.steps.last;
      expect(step12.actionLabelFr, 'Terminer');
      expect(step12.actionLabelEn, 'Finish');
    });

    test('TutorialController handles completion persistence correctly', () async {
      SharedPreferences.setMockInitialValues({});
      final controller = TutorialController();

      expect(await controller.hasCompletedTutorial(), false);
      await controller.markTutorialCompleted();
      expect(await controller.hasCompletedTutorial(), true);
    });
  });
}
