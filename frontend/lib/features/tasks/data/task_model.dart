class TaskModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final int difficulty;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.difficulty = 1,
    this.type = 'daily',
    required this.createdAt,
    required this.updatedAt,
    required this.status
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      difficulty: json['difficulty'] ?? 1,
      type: json['type'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      status: json['status'] ?? 'pending',
    );
  }
}