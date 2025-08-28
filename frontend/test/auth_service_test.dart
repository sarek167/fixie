import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:frontend/core/services/auth_service.dart';
import 'package:frontend/core/constants/api_endpoints.dart';

// dart run build_runner build --delete-conflicting-outputs
@GenerateNiceMocks([MockSpec<Dio>()])
import 'auth_service_test.mocks.dart';

void main() {
  group('AuthService.login', () {
    late MockDio dio;
    late AuthService authService;

    setUp(() {
      dio = MockDio();
      authService = AuthService(dio: dio);
    });

    test('returns response when login succeeds', () async {
      final response = Response(
        requestOptions: RequestOptions(path: EndpointConstants.loginEndpoint),
        statusCode: 200,
        data: {
          'access_token': 'token',
          'refresh_token': 'refresh',
        },
      );

      when(dio.post(
        EndpointConstants.loginEndpoint,
        data: anyNamed('data'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => response);

      final result = await authService.login('email', 'password');

      expect(result, response);

      verify(dio.post(
        EndpointConstants.loginEndpoint,
        data: {'email': 'email', 'password': 'password'},
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).called(1);
    });

    test('throws exception when dio throws', () {
      when(dio.post(
        EndpointConstants.loginEndpoint,
        data: anyNamed('data'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: EndpointConstants.loginEndpoint),
        type: DioExceptionType.connectionError,
      ));

      expect(
            () => authService.login('email', 'password'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
