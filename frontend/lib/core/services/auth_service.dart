import 'package:dio/dio.dart';
import 'package:frontend/core/constants/api_endpoints.dart';
import 'package:frontend/core/services/token_service.dart';

class AuthService {
  final Dio _dio = Dio();
  Future<Response> login(String email, String password) async {
    final response = await _dio.post(
      EndpointConstants.loginEndpoint,
      data: {'email': email, 'password': password},
    );
    print(response);
    return response;
  }

  Future<Response> register(
    String email,
    String username,
    String password,
  ) async {
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
    return response;
  }

  Future<Response> logout(String accessToken, String refreshToken) async {
    final response = await TokenClient.client.patch(
        EndpointConstants.logoutEndpoint,
        data: {'refresh_token': refreshToken},
    );

    return response;
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
