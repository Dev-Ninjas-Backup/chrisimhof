class SourceItem {
  final String key;
  final String label;
  final String desc;
  final String status;

  SourceItem({
    required this.key,
    required this.label,
    required this.desc,
    required this.status,
  });

  factory SourceItem.fromJson(Map<String, dynamic> json) {
    return SourceItem(
      key: json['key'] as String,
      label: json['label'] as String,
      desc: json['desc'] as String,
      status: json['status'] as String,
    );
  }
}

class ConnectedSourcesData {
  final String title;
  final String subtitle;
  final List<SourceItem> sources;
  final String cta;

  ConnectedSourcesData({
    required this.title,
    required this.subtitle,
    required this.sources,
    required this.cta,
  });

  factory ConnectedSourcesData.fromJson(Map<String, dynamic> json) {
    var sourcesList = json['sources'] as List;
    List<SourceItem> parsedSources =
        sourcesList.map((i) => SourceItem.fromJson(i as Map<String, dynamic>)).toList();
    return ConnectedSourcesData(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      sources: parsedSources,
      cta: json['cta'] as String,
    );
  }
}

class ConnectedSourcesResponseModel {
  final bool success;
  final String message;
  final ConnectedSourcesData data;

  ConnectedSourcesResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ConnectedSourcesResponseModel.fromJson(Map<String, dynamic> json) {
    return ConnectedSourcesResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ConnectedSourcesData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class ConnectSourcesPostData {
  final bool saved;

  ConnectSourcesPostData({
    required this.saved,
  });

  factory ConnectSourcesPostData.fromJson(Map<String, dynamic> json) {
    return ConnectSourcesPostData(
      saved: json['saved'] as bool,
    );
  }
}

class ConnectSourcesPostResponseModel {
  final bool success;
  final String message;
  final ConnectSourcesPostData data;

  ConnectSourcesPostResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ConnectSourcesPostResponseModel.fromJson(Map<String, dynamic> json) {
    return ConnectSourcesPostResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ConnectSourcesPostData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
