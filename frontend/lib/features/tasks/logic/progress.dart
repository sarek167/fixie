import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/tasks/presentation/task_path.dart';

class Progress {
  double calculateProgress(List<TaskNode> nodes) {
    final done = nodes.where((n) => n.color == ColorConstants.lightBackground).length;
    final total = nodes.where((n) => n.isTrophy == false).length;
    return total > 0 ? done / total : 0;
  }
}