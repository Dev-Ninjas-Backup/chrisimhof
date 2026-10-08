class AppNotificationItem {
  final String id;
  final String title;
  final String body;
  final String channel;
  final bool isRead;
  final DateTime sentAt;

  AppNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.channel,
    required this.isRead,
    required this.sentAt,
  });

  factory AppNotificationItem.fromJson(Map<String, dynamic> json) {
    DateTime parsedSentAt;
    try {
      parsedSentAt = DateTime.parse(json['sentAt'] ?? json['createdAt'] ?? DateTime.now().toIso8601String()).toLocal();
    } catch (_) {
      parsedSentAt = DateTime.now();
    }

    String channelStr = 'system_alert';
    if (json['data'] is Map && (json['data'] as Map)['channel'] != null) {
      channelStr = (json['data'] as Map)['channel'].toString();
    } else if (json['channel'] != null) {
      channelStr = json['channel'].toString();
    }

    return AppNotificationItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      channel: channelStr,
      isRead: json['isRead'] ?? false,
      sentAt: parsedSentAt,
    );
  }
}
