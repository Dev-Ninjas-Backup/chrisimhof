import 'package:chrisimhof/features/work_schedule_settings/model/work_rotation_preset_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Work Rotation Custom Shifts & Calendar Dates Tests', () {
    test('WorkRotationPresetModel correctly prioritizes custom rotation name', () {
      final json = {
        'id': 'cmvf0szb6001y1wp9getl6tfw',
        'name': 'Team Alpha Schedule',
        'rotationName': 'Team Alpha Schedule',
        'label': '',
        'cycleWeeks': 2,
        'shiftTimesJson': {
          'Day': {'startTime': '07:00', 'endTime': '15:00'},
          'Evening': {'startTime': '15:00', 'endTime': '23:00'},
          'Night': {'startTime': '23:00', 'endTime': '07:00'},
        },
        'patternJson': [
          {'weekIndex': 0, 'dayIndex': 0, 'shiftCode': 'day'},
          {'weekIndex': 0, 'dayIndex': 1, 'shiftCode': 'night'},
        ],
      };

      final model = WorkRotationPresetModel.fromJson(json);

      expect(model.id, 'cmvf0szb6001y1wp9getl6tfw');
      expect(model.label, 'Team Alpha Schedule');
      expect(model.isCustom, true);
      expect(model.cycleWeeks, 2);
    });

    test('WorkRotationPresetModel falls back to rotationName when name is absent', () {
      final json = {
        'id': 'custom-123',
        'rotationName': 'Night Owl Shift',
        'cycleWeeks': 1,
        'shiftTimesJson': {
          'Night': {'startTime': '22:00', 'endTime': '06:00'},
        },
      };

      final model = WorkRotationPresetModel.fromJson(json);

      expect(model.label, 'Night Owl Shift');
      expect(model.isCustom, true);
    });

    test('Calendar date progression from start date aligns each day index exactly', () {
      final startDate = DateTime(2026, 10, 19); // Monday

      // Week 1 Day 0
      final day0 = startDate.add(const Duration(days: 0));
      expect(day0.year, 2026);
      expect(day0.month, 10);
      expect(day0.day, 19);
      expect(day0.weekday, DateTime.monday);

      // Week 1 Day 6 (Sunday)
      final day6 = startDate.add(const Duration(days: 6));
      expect(day6.day, 25);
      expect(day6.weekday, DateTime.sunday);

      // Week 2 Day 0 (Day 7 overall)
      final day7 = startDate.add(const Duration(days: 7));
      expect(day7.day, 26);
      expect(day7.weekday, DateTime.monday);
    });
  });
}
