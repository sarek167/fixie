
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:frontend/core/constants/api_endpoints.dart';
import 'package:frontend/core/services/token_service.dart';
import 'package:frontend/core/utils/failure.dart';
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

  static Future<PathModelWithTasks> getPathByTitle(String title) async {
    final response = await TokenClient.client.get("${EndpointConstants.getPathByTitleEndpoint}?title=$title");
    if (response.statusCode == 200) {
      return PathModelWithTasks.fromJson(response.data);
    } else {
      throw Exception("Error while getting path data");
    }
  }

  static Future<Either<Failure, bool>> toggleUserPath(String pathTitle) async {
    final Map<String, dynamic> body = {
      'path_title': pathTitle
    };
    try {
      final response = await TokenClient.client.post(
        EndpointConstants.postAssignPathEndpoint,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        final isSaved = response.data['isSaved'] as bool;
        return Right(isSaved);
      } else {
        return Left(ServerFailure("Error ${response.statusCode}"));
      }
    } on DioException catch (e) {
      final message = e.response?.data?['detail'] ?? "Error while connecting to the server";
      return Left(ServerFailure(message.toString()));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }
}



