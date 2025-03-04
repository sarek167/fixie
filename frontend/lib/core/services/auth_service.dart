import 'package:dio/dio.dart';
import 'package:frontend/core/constants/api_endpoints.dart';

class AuthService {
  final Dio _dio = Dio();

  Future<Response> login(String email, String password) async {
    final response = await _dio.post(
      EndpointConstants.loginEndpoint,
      data: {
        'email': email,
        'password': password,
      },
    );
    return response;
  }

  Future<Response> register(String email, String username, String password) async {
    final response = await _dio.post(
      EndpointConstants.registerEndpoint,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
      data: {
        'email': email,
        'username': username,
        'password': password,
      },
    );
    return response;
  }
}