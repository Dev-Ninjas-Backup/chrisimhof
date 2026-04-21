class CaffeinePreset {
  final String drinkType;
  final String label;
  final int defaultMg;

  CaffeinePreset({
    required this.drinkType,
    required this.label,
    required this.defaultMg,
  });

  factory CaffeinePreset.fromJson(Map<String, dynamic> json) {
    return CaffeinePreset(
      drinkType: json['drinkType'] ?? '',
      label: json['label'] ?? '',
      defaultMg: json['defaultMg'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'drinkType': drinkType, 'label': label, 'defaultMg': defaultMg};
  }
}
