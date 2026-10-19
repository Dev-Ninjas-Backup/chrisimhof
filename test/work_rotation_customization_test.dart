import 'package:chrisimhof/core/service/helper/shift_display_helper.dart';
import 'package:chrisimhof/features/work_schedule_settings/controller/work_schedule_settings_controller.dart';
import 'package:chrisimhof/features/work_schedule_settings/model/work_rotation_preset_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Work Rotation Customization & Color Tests', () {
    test('Custom shift color assignment and resolution', () {
      ShiftDisplayHelper.setCustomShiftColor('Morning 12h', '#8B5CF6');

      final resolvedBg = ShiftDisplayHelper.getShiftColor('Morning 12h', bg: true);
      final resolvedText = ShiftDisplayHelper.getShiftColor('Morning 12h', bg: false);

      expect(resolvedText, const Color(0xFF8B5CF6));
      expect(resolvedBg, const Color(0xFF8B5CF6).withValues(alpha: 0.16));

      // Reset
      ShiftDisplayHelper.setCustomShiftColor('Morning 12h', null);
    });

    test('WorkRotationPresetModel parses custom template from backend JSON', () {
      final json = {
        'id': 'template_abc123',
        'name': 'My Custom 4-Week Schedule',
        'cycleWeeks': 4,
        'shiftTimesJson': {
          'Day': {'start': '07:00', 'end': '15:30'},
          'Evening': {'start': '15:00', 'end': '23:30'},
          'Night': {'start': '23:00', 'end': '07:30'},
          'Patrol': {'start': '10:00', 'end': '18:00'}
        },
        'patternJson': [
          {'dayIndex': 0, 'shiftCode': 'Day'},
          {'dayIndex': 1, 'shiftCode': 'Patrol'},
          {'dayIndex': 2, 'shiftCode': 'Off'}
        ],
        'isCustom': true,
      };

      final preset = WorkRotationPresetModel.fromJson(json);

      expect(preset.id, 'template_abc123');
      expect(preset.label, 'My Custom 4-Week Schedule');
      expect(preset.cycleWeeks, 4);
      expect(preset.isCustom, true);
      expect(preset.shiftTimes.containsKey('Patrol'), isTrue);
      expect(preset.pattern.length, 28);
      expect(preset.pattern[0], 'Day');
      expect(preset.pattern[1], 'Patrol');
      expect(preset.pattern[2], 'Off');
    });

    test('Controller manages dynamic custom shifts and weeks correctly', () {
      final controller = WorkScheduleSettingsController();

      // Start new rotation
      controller.startNewRotation();
      expect(controller.isCreatingNewRotation.value, isTrue);

      // Adjust cycle weeks
      final initialWeeks = controller.weeks.value;
      controller.setWeeks(initialWeeks + 1);
      expect(controller.weeks.value, initialWeeks + 1);
      expect(controller.pattern.length, (initialWeeks + 1) * 7);

      // Add a custom shift
      controller.addCustomShift('Support', '09:00', '17:00');
      expect(controller.shiftTimes.containsKey('Support'), isTrue);
      expect(controller.shiftTimes['Support']?['start'], '09:00');
      expect(controller.shiftTimes['Support']?['end'], '17:00');

      // Assign to day 0
      controller.updateDayPattern(0, 'Support');
      expect(controller.pattern[0], 'Support');

      // Rename custom shift
      controller.renameCustomShift('Support', 'Tech Support');
      expect(controller.shiftTimes.containsKey('Tech Support'), isTrue);
      expect(controller.shiftTimes.containsKey('Support'), isFalse);
      expect(controller.pattern[0], 'Tech Support');

      // Delete custom shift
      controller.deleteCustomShift('Tech Support');
      expect(controller.shiftTimes.containsKey('Tech Support'), isFalse);
      expect(controller.pattern[0], 'Off');
    });

    test('editRotation loads preset into builder for editing', () {
      final controller = WorkScheduleSettingsController();

      final preset = WorkRotationPresetModel(
        key: 'custom_123',
        id: 'tmpl_123',
        label: 'My 3-Week Shift',
        description: 'Custom rotation',
        cycleWeeks: 3,
        shiftTimes: {
          'Day': {'start': '06:00', 'end': '14:00'},
          'Evening': {'start': '14:00', 'end': '22:00'},
          'Night': {'start': '22:00', 'end': '06:00'},
          'On-Call': {'start': '08:00', 'end': '20:00'},
        },
        pattern: List.generate(21, (i) => i % 2 == 0 ? 'On-Call' : 'Off'),
        isCustom: true,
      );

      controller.editRotation(preset);

      expect(controller.isCreatingNewRotation.value, isTrue);
      expect(controller.rotationName.value, 'My 3-Week Shift');
      expect(controller.weeks.value, 3);
      expect(controller.pattern.length, 21);
      expect(controller.pattern[0], 'On-Call');
      expect(controller.shiftTimes.containsKey('On-Call'), isTrue);
    });
  });
}
