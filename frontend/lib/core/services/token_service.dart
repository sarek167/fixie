import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/core/constants/api_endpoints.dart';

class TokenClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: EndpointConstants.baseUserEndpoint,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    contentType: 'application/json',
  ));

  static final Dio _refreshDio = Dio(BaseOptions(
    baseUrl:EndpointConstants.baseUserEndpoint,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    contentType: 'application/json'
  ));

  static final _storage = FlutterSecureStorage();

  static Dio get client {
    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (!options.path.contains("token_refresh")) {
          final token = await _storage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        return handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          final refreshToken = await _storage.read(key: 'refresh_token');
          if (refreshToken != null) {
            final refreshed = await _refreshToken(refreshToken);
            if (refreshed != null) {
              e.requestOptions.headers['Authorization'] = 'Bearer $refreshed';
              final clonedRequest = await _dio.fetch(e.requestOptions);
              return handler.resolve(clonedRequest);
            }
          }
        }
        return handler.next(e);
      },
    ));
    return _dio;
  }

  static Future<String?> _refreshToken(String refreshToken) async {
    try {
      final response = await _refreshDio.post(EndpointConstants.refreshTokenSuffix, data: jsonEncode({'refresh': refreshToken}));
      if (response.statusCode == 200) {
        final access = response.data['access'];
        final newRefresh = response.data['refresh'];
        await _storage.write(key: 'access_token', value: access);
        if (newRefresh != null) {
          await _storage.write(key: 'refresh_token', value: newRefresh);
        }
        return access;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}