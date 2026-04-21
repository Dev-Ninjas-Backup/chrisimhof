enum ActivityType {
  rest('REST', 'Rest'),
  walk('WALK', 'Walking'),
  gym('GYM', 'Gym'),
  run('RUN', 'Running'),
  cycle('CYCLE', 'Cycle'),
  sport('SPORT', 'Sport');

  final String apiValue;
  final String displayName;

  const ActivityType(this.apiValue, this.displayName);

  static ActivityType fromApiValue(String value) {
    return ActivityType.values.firstWhere(
      (type) => type.apiValue == value.toUpperCase(),
      orElse: () => ActivityType.sport,
    );
  }

  static ActivityType fromDisplayName(String name) {
    return ActivityType.values.firstWhere(
      (type) => type.displayName.toLowerCase() == name.toLowerCase(),
      orElse: () => ActivityType.sport,
    );
  }
}
