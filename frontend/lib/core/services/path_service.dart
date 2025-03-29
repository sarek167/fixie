
import 'package:frontend/core/constants/api_endpoints.dart';
import 'package:frontend/core/services/token_service.dart';
import 'package:frontend/features/tasks/data/path_model.dart';

class PathService {
  static Future<List<PathModel>> getUserPaths() async {
    final response = await TokenClient.client.get(EndpointConstants.getUserPathsEndpoint);
    final data = response.data;
    print(data);
    return (data['user_paths'] as List)
        .map((e) => PathModel.fromJson(e))
        .toList();
  }

  static Future<List<PathModel>> getPopularPaths() async {
    final response = await TokenClient.client.get(EndpointConstants.getPopularPathsEndpoint);
    final data = response.data;
    print(data);
    return (data['popular_paths'] as List)
        .map((e) => PathModel.fromJson(e))
        .toList();
  }

  static Future<PathModel> getPathByTitle(String title) async {
    final response = await TokenClient.client.get("${EndpointConstants.getPathByTitleEndpoint}?title=$title");
    if (response.statusCode == 200) {
      final data = response.data;
      return PathModel.fromJson(data);
    } else {
      throw Exception("Error while getting path data");
    }
  }
}