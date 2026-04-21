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
    // Handle amountMg as both int and string from API
    int parsedAmountMg = 0;
    final amountMgValue = json['amountMg'];
    if (amountMgValue != null) {
      if (amountMgValue is int) {
        parsedAmountMg = amountMgValue;
      } else if (amountMgValue is String) {
        parsedAmountMg = int.tryParse(amountMgValue) ?? 0;
      }
    }

    // API uses 'drinkName' but we store it as 'label' for UI consistency
    return CaffeinePreset(
      drinkType: json['drinkType'] ?? '',
      label: json['drinkName'] ?? '', // Map drinkName -> label
      defaultMg: parsedAmountMg, // Map amountMg -> defaultMg
    );
  }

  Map<String, dynamic> toJson() {
    return {'drinkType': drinkType, 'label': label, 'defaultMg': defaultMg};
  }
}
