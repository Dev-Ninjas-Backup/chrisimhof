enum ActivityType {
  walk('WALKING', 'Walking'),
  cardio('CARDIO', 'Cardio'),
  strength('STRENGTH', 'Strength Training');

  final String apiValue;
  final String displayName;

  const ActivityType(this.apiValue, this.displayName);

  static ActivityType fromApiValue(String value) {
    return ActivityType.values.firstWhere(
      (type) => type.apiValue == value.toUpperCase(),
      orElse: () => ActivityType.walk,
    );
  }

  static ActivityType fromDisplayName(String name) {
    return ActivityType.values.firstWhere(
      (type) => type.displayName.toLowerCase() == name.toLowerCase(),
      orElse: () => ActivityType.walk,
    );
  }
}
