class PathModel {
  final String title;
  final String description;
  final String backgroundType;
  final String backgroundValue;

  PathModel({
    required this.title,
    this.description = "",
    required this.backgroundType,
    required this.backgroundValue,
  });

  factory PathModel.fromJson(Map<String, dynamic> json) {
    return PathModel(
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      backgroundType: json['background_type'] ?? 'default',
      backgroundValue: json['background_value'] ?? '#FFFFFF',
    );
  }

  bool get isImage => backgroundType == 'image';
  bool get isColor => backgroundType == 'color';
  bool get isDefault => backgroundType == 'default';
}