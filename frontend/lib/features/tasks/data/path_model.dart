class PathCard {
  final String title;
  final String backgroundType;
  final String backgroundValue;

  PathCard({
    required this.title,
    required this.backgroundType,
    required this.backgroundValue
  });

  factory PathCard.fromJson(Map<String, dynamic> json) {
    return PathCard(
      title: json['title'],
      backgroundType: json['background_type'] ?? 'default',
      backgroundValue: json['background_value'] ?? '#FFFFFF',
    );
  }
  bool get isImage => backgroundType == 'image';
  bool get isColor => backgroundType == 'color';
  bool get isDefault => backgroundType == 'default';
}