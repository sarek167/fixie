import 'package:dio/dio.dart';
import 'package:frontend/core/constants/api_endpoints.dart';
import 'package:frontend/core/services/token_service.dart';

class AuthService {
  final Dio _dio;

  AuthService({Dio? dio}) : _dio = dio ?? Dio();

  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post(
        EndpointConstants.loginEndpoint,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Login failed: ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Login request failed: ${e.message}');
    }
  }

  Future<Response> register(
    String email,
    String username,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        EndpointConstants.registerEndpoint,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: {'email': email, 'username': username, 'password': password},
      );

      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Register failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Register request failed: ${e.message}');
    }
  }

  Future<Response> logout(String accessToken, String refreshToken) async {
    try {
      final response = await TokenClient.client.post(
        EndpointConstants.logoutEndpoint,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Logout failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Logout request failed: ${e.message}');
    }
  }
  
  Future<bool> changeUserData(Map<String, String> userData) async {
    try {
      final response = await TokenClient.client.patch(
          EndpointConstants.patchUserDataEndpoint,
          data: userData
      );

      if (response.statusCode == 200 || response.statusCode == 202) {
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
