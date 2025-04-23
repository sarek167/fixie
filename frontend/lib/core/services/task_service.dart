import 'package:frontend/core/constants/api_endpoints.dart';
import 'package:frontend/core/services/token_service.dart';
import 'package:frontend/features/tasks/data/task_model.dart';
import 'package:frontend/features/tasks/presentation/task_path.dart';

class TaskService {
  static Future<bool> submitAnswer(TaskNode task, String? taskAnswer, bool? taskCheck) async {
    final Map<String, dynamic> body = {
      'task_id': task.id,
      'text_answer': task.answerType == 'text' ? taskAnswer : null,
      'checkbox_answer': task.answerType == 'text' ? null : taskCheck,
    };

    try {
      final response = await TokenClient.client.post(
        EndpointConstants.postTaskAnswerEndpoint,
        data: body
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Error ${response.statusCode}: ${response.data}");
        return false;
      }
    } catch (e) {
      print("Dio error $e");
      return false;
    }
  }

  static Future<int> countStreak() async {
    try {
      print("W STREAKU");
      final response = await TokenClient.client.get(
        EndpointConstants.getStreakEndpoint
      );
      print(response.data);
      if (response.statusCode == 200) {
        return response.data["streak"];
      } else {
        print("Error ${response.statusCode}: ${response.data}");
        throw Exception;
      }
    } catch (e) {
      print("Error: $e");
      return -1;
    }
  }

  static Future<List<TaskModel>> getDailyTasks() async {
    try {
      final response = await TokenClient.client.get(
        EndpointConstants.getDailyTasksEndpoint
      );
      if (response.statusCode == 200) {
        final tasks = (response.data["tasks"] as List)
            .map((task) => TaskModel.fromJson(task))
            .toList();
        return tasks;
      } else {
        throw Exception("Error while getting tasks");
      }

    } catch (e) {
      print("Error: $e");
      throw Exception("Something went wrong during getting daily tasks");
    }
  }

  static Future<TaskModel> getDailyTaskByDate(String date) async {
    try {
      final Map<String, String> body = {
        'date': date
      };
      final response = await TokenClient.client.post(
        EndpointConstants.getDailyTaskByDateEndpoint,
        data: body
      );
      print(response.data);
      return TaskModel.fromJson(response.data);
    } catch (e) {
      print("Error: $e");
      throw Exception("Something went wrong during getting daily task by date");
    }
  }

  static Future<List<Map<String, dynamic>>> getDailyTasksStatus() async {
    try {
      final response = await TokenClient.client.get(
        EndpointConstants.getDailyTasksStatusEndpoint
      );
      if (response.statusCode == 200) {
        final statuses = List<Map<String,dynamic>>.from(response.data["tasks"]);
        print(statuses);
        return statuses;
      } else {
        throw Exception("Error while getting statuses");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Something went wrong during getting daily tasks statuses");
    }
  }
}