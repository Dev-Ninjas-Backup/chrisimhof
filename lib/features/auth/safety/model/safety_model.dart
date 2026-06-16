class SafetyItem {
  final int index;
  final String text;
  final bool required;

  SafetyItem({
    required this.index,
    required this.text,
    required this.required,
  });

  factory SafetyItem.fromJson(Map<String, dynamic> json) {
    return SafetyItem(
      index: json['index'] as int,
      text: json['text'] as String,
      required: json['required'] as bool,
    );
  }
}

class SafetyData {
  final String title;
  final String subtitle;
  final List<SafetyItem> items;
  final String cta;

  SafetyData({
    required this.title,
    required this.subtitle,
    required this.items,
    required this.cta,
  });

  factory SafetyData.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<SafetyItem> safetyItems = itemsList.map((i) => SafetyItem.fromJson(i)).toList();
    return SafetyData(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      items: safetyItems,
      cta: json['cta'] as String,
    );
  }
}

class SafetyResponseModel {
  final bool success;
  final String message;
  final SafetyData data;

  SafetyResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SafetyResponseModel.fromJson(Map<String, dynamic> json) {
    return SafetyResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: SafetyData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class SafetyAcknowledgeData {
  final bool acknowledged;
  final bool canProceed;

  SafetyAcknowledgeData({
    required this.acknowledged,
    required this.canProceed,
  });

  factory SafetyAcknowledgeData.fromJson(Map<String, dynamic> json) {
    return SafetyAcknowledgeData(
      acknowledged: json['acknowledged'] as bool,
      canProceed: json['canProceed'] as bool,
    );
  }
}

class SafetyAcknowledgeResponseModel {
  final bool success;
  final String message;
  final SafetyAcknowledgeData data;

  SafetyAcknowledgeResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SafetyAcknowledgeResponseModel.fromJson(Map<String, dynamic> json) {
    return SafetyAcknowledgeResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: SafetyAcknowledgeData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
