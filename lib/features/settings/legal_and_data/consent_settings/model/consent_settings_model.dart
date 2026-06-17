class ConsentSettingItem {
  final String key;
  final String label;
  final String desc;
  final bool enabled;

  ConsentSettingItem({
    required this.key,
    required this.label,
    required this.desc,
    required this.enabled,
  });

  factory ConsentSettingItem.fromJson(Map<String, dynamic> json) {
    return ConsentSettingItem(
      key: json['key'] as String,
      label: json['label'] as String,
      desc: json['desc'] as String,
      enabled: json['enabled'] as bool,
    );
  }
}

class ConsentSettingsData {
  final String title;
  final String subtitle;
  final List<ConsentSettingItem> settings;
  final String cta;

  ConsentSettingsData({
    required this.title,
    required this.subtitle,
    required this.settings,
    required this.cta,
  });

  factory ConsentSettingsData.fromJson(Map<String, dynamic> json) {
    var settingsList = json['settings'] as List;
    List<ConsentSettingItem> parsedSettings =
        settingsList.map((i) => ConsentSettingItem.fromJson(i as Map<String, dynamic>)).toList();
    return ConsentSettingsData(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      settings: parsedSettings,
      cta: json['cta'] as String,
    );
  }
}

class ConsentSettingsResponseModel {
  final bool success;
  final String message;
  final ConsentSettingsData data;

  ConsentSettingsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ConsentSettingsResponseModel.fromJson(Map<String, dynamic> json) {
    return ConsentSettingsResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ConsentSettingsData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class ConsentSettingsPostData {
  final bool saved;
  final Map<String, dynamic> settings;

  ConsentSettingsPostData({
    required this.saved,
    required this.settings,
  });

  factory ConsentSettingsPostData.fromJson(Map<String, dynamic> json) {
    return ConsentSettingsPostData(
      saved: json['saved'] as bool,
      settings: json['settings'] as Map<String, dynamic>,
    );
  }
}

class ConsentSettingsPostResponseModel {
  final bool success;
  final String message;
  final ConsentSettingsPostData data;

  ConsentSettingsPostResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ConsentSettingsPostResponseModel.fromJson(Map<String, dynamic> json) {
    return ConsentSettingsPostResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ConsentSettingsPostData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
