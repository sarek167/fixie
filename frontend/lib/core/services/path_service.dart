
import 'package:frontend/core/constants/api_endpoints.dart';
import 'package:frontend/core/services/token_service.dart';
import 'package:frontend/features/tasks/data/path_model.dart';

class PathService {
  static Future<List<UserPath>> getUserPaths() async {
    final response = await TokenClient.client.get(EndpointConstants.getUserPathsEndpoint);
    final data = response.data;
    print(data);
    return (data['user_path'] as List)
        .map((e) => UserPath.fromJson(e))
        .toList();
  }
}