import 'package:flutter/material.dart';
import 'package:frontend/core/services/task_service.dart';
import 'package:frontend/features/tasks/logic/get_node_color_by_status.dart';
import 'package:frontend/features/tasks/presentation/single_task_screen.dart';
import 'package:frontend/features/tasks/presentation/task_path.dart';

Future<void> navigateToSelectedTask(BuildContext context, DateTime selectedDay) async {
  try {
    String date = "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";
    print("Wybrany dzień $selectedDay");

    final task = await TaskService.getDailyTaskByDate(date);
    print("Task response: $task");

    if (!context.mounted) {
      print("Context not mounted – nie przechodzę do ekranu");
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SingleTaskScreen(
          task: TaskNode(
            id: task.id,
            text: date,
            flag: task.status == "in_progress",
            title: task.title,
            description: task.description,
            category: task.category,
            difficulty: task.difficulty,
            answerType: task.answerType,
            color: getColorByStatus(task.status),
          ),
        ),
      ),
    );
  } catch (e, stack) {
    print("❌ Błąd przy nawigacji: $e");
    print(stack);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nie udało się załadować zadania")),
      );
    }
  }
}
