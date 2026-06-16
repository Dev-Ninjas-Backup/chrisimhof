class CaffeineEntry {
  final String id;
  final String title;
  final DateTime timestamp;
  final int amountMg;

  CaffeineEntry({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.amountMg,
  });

  String get timeFormatted {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  CaffeineEntry copyWith({
    String? id,
    String? title,
    DateTime? timestamp,
    int? amountMg,
  }) {
    return CaffeineEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      timestamp: timestamp ?? this.timestamp,
      amountMg: amountMg ?? this.amountMg,
    );
  }
}
