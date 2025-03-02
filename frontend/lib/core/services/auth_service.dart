import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio();

  Future<Response> login(String email, String password) async {
    final response = await _dio.post(
      'http://10.0.2.2:8000/user_management/login/',
      data: {
        'email': email,
        'password': password,
      },
    );
    return response;
  }

  Future<Response> register(String email, String username, String password) async {
    final response = await _dio.post(
      'http://10.0.2.2:8000/user_management/register/',
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