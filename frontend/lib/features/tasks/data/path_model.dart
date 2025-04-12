import 'package:frontend/features/tasks/data/task_model.dart';

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

class PathModelWithTasks {
  final String title;
  final String description;
  final String backgroundType;
  final String backgroundValue;
  final List<TaskModel> tasks;
  final bool isSaved;

  PathModelWithTasks({
    required this.title,
    this.description = "",
    required this.backgroundType,
    required this.backgroundValue,
    required this.tasks,
    this.isSaved = false
  });

  factory PathModelWithTasks.fromJson(Map<String, dynamic> json) {
    print(json);
    final path = json['path'];
    final tasks = (json['tasks'] as List)
        .map((task) => TaskModel.fromJson(task))
        .toList();
    final isSaved = json['is_saved'];

    return PathModelWithTasks(
      title: path['title'] ?? "",
      description: path['description'] ?? "",
      backgroundType: path['background_type'] ?? 'default',
      backgroundValue: path['background_value'] ?? '#FFFFFF',
      tasks: tasks,
      isSaved: isSaved
    );
  }

  bool get isImage => backgroundType == 'image';
  bool get isColor => backgroundType == 'color';
  bool get isDefault => backgroundType == 'default';
}
