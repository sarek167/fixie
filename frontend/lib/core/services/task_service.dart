import 'package:frontend/core/constants/api_endpoints.dart';
import 'package:frontend/core/services/token_service.dart';
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
}