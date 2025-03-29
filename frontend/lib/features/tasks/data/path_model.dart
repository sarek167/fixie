class UserPath {
  final String title;
  final String backgroundType;
  final String backgroundValue;

  UserPath({
    required this.title,
    required this.backgroundType,
    required this.backgroundValue
  });

  factory UserPath.fromJson(Map<String, dynamic> json) {
    return UserPath(
      title: json['title'],
      backgroundType: json['background_type'] ?? 'default',
      backgroundValue: json['background_value'] ?? '#FFFFFF',
    );
  }
  bool get isImage => backgroundType == 'image';
  bool get isColor => backgroundType == 'color';
  bool get isDefault => backgroundType == 'default';
}