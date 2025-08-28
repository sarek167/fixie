// test/path_service_test.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:frontend/core/constants/api_endpoints.dart';
import 'package:frontend/core/services/token_service.dart';
import 'package:frontend/core/utils/failure.dart';
import 'package:frontend/features/tasks/data/path_model.dart';
import 'package:frontend/core/services/path_service.dart';

// dart run build_runner build --delete-conflicting-outputs
@GenerateNiceMocks([MockSpec<Dio>()])
import 'path_service_test.mocks.dart';

void main() {
  group('PathService.getUserPaths', () {
    late MockDio dio;

    setUp(() {
      dio = MockDio();
      TokenClient.setTestClient(dio);
    });

    tearDown(() {
      TokenClient.setTestClient(null);
    });

    test('zwraca List<PathModel> na 200', () async {
      final response = Response(
        requestOptions:
        RequestOptions(path: EndpointConstants.getUserPathsEndpoint),
        statusCode: 200,
        data: {
          'user_paths': [
            {
              'title': 'A',
              'description': 'Desc A',
              'background_type': 'color',
              'background_value': '#fff',
            },
            {
              'title': 'B',
              'description': 'Desc B',
              'background_type': 'gradient',
              'background_value': 'linear(...)',
            },
          ],
        },
      );

      when(dio.get(
        EndpointConstants.getUserPathsEndpoint,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => response);

      final result = await PathService.getUserPaths();

      expect(result, isA<List<PathModel>>());
      expect(result.length, 2);
      expect(result.first.title, 'A');

      verify(dio.get(
        EndpointConstants.getUserPathsEndpoint,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).called(1);
    });
  });

  group('PathService.getPopularPaths', () {
    late MockDio dio;

    setUp(() {
      dio = MockDio();
      TokenClient.setTestClient(dio);
    });

    tearDown(() {
      TokenClient.setTestClient(null);
    });

    test('zwraca List<PathModel> na 200', () async {
      final response = Response(
        requestOptions:
        RequestOptions(path: EndpointConstants.getPopularPathsEndpoint),
        statusCode: 200,
        data: {
          'popular_paths': [
            {
              'title': 'P1',
              'description': 'Desc 1',
              'background_type': 'color',
              'background_value': '#000',
            },
          ],
        },
      );

      when(dio.post(
        EndpointConstants.getPopularPathsEndpoint,
        data: anyNamed('data'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => response);

      final result = await PathService.getPopularPaths(3);

      expect(result, isA<List<PathModel>>());
      expect(result.single.title, 'P1');

      verify(dio.post(
        EndpointConstants.getPopularPathsEndpoint,
        data: {'loaded_paths_number': 3},
        options: argThat(
          isA<Options>().having(
                (o) => o.headers?['Content-Type'],
            'Content-Type',
            'application/json',
          ),
          named: 'options',
        ),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).called(1);
    });
  });

  group('PathService.getPathByTitle', () {
    late MockDio dio;

    setUp(() {
      dio = MockDio();
      TokenClient.setTestClient(dio);
    });

    tearDown(() {
      TokenClient.setTestClient(null);
    });

    test('zwraca PathModelWithTasks na 200', () async {
      final response = Response(
        requestOptions: RequestOptions(
            path:
            '${EndpointConstants.getPathByTitleEndpoint}?title=TestTitle'),
        statusCode: 200,
        data: {
          'path': {
            'title': 'TestTitle',
            'description': 'Desc',
            'background_type': 'color',
            'background_value': '#fff',
          },
          'tasks': [],
          'is_saved': false,
        },
      );

      when(dio.get(
        '${EndpointConstants.getPathByTitleEndpoint}?title=TestTitle',
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => response);

      final result = await PathService.getPathByTitle('TestTitle');

      expect(result.title, 'TestTitle');

      verify(dio.get(
        '${EndpointConstants.getPathByTitleEndpoint}?title=TestTitle',
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).called(1);
    });

    test('rzuca Exception gdy != 200', () async {
      final response = Response(
        requestOptions:
        RequestOptions(path: EndpointConstants.getPathByTitleEndpoint),
        statusCode: 404,
        data: {},
      );

      when(dio.get(
        '${EndpointConstants.getPathByTitleEndpoint}?title=Nope',
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => response);

      expect(() => PathService.getPathByTitle('Nope'), throwsException);
    });
  });

  group('PathService.toggleUserPath', () {
    late MockDio dio;

    setUp(() {
      dio = MockDio();
      TokenClient.setTestClient(dio);
    });

    tearDown(() {
      TokenClient.setTestClient(null);
    });

    test('zwraca Right(isSaved) na 200', () async {
      final response = Response(
        requestOptions:
        RequestOptions(path: EndpointConstants.postAssignPathEndpoint),
        statusCode: 200,
        data: {'isSaved': true},
      );

      when(dio.post(
        EndpointConstants.postAssignPathEndpoint,
        data: anyNamed('data'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => response);

      final result = await PathService.toggleUserPath('My Path');

      expect(result.isRight(), true);
      result.fold((_) => fail('Expected Right'), (r) => expect(r, true));

      verify(dio.post(
        EndpointConstants.postAssignPathEndpoint,
        data: {'path_title': 'My Path'},
        options: argThat(
          isA<Options>().having(
                (o) => o.headers?['Content-Type'],
            'Content-Type',
            'application/json',
          ),
          named: 'options',
        ),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).called(1);
    });

    test('zwraca Left(ServerFailure) na != 200', () async {
      final response = Response(
        requestOptions:
        RequestOptions(path: EndpointConstants.postAssignPathEndpoint),
        statusCode: 400,
        data: {},
      );

      when(dio.post(
        EndpointConstants.postAssignPathEndpoint,
        data: anyNamed('data'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => response);

      final result = await PathService.toggleUserPath('X');

      expect(result.isLeft(), true);
      result.fold(
            (l) => expect((l as ServerFailure).message, contains('Error 400')),
            (_) => fail('Expected Left'),
      );
    });

    test('zwraca Left(ServerFailure) na DioException z detail', () async {
      when(dio.post(
        EndpointConstants.postAssignPathEndpoint,
        data: anyNamed('data'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenThrow(DioException(
        requestOptions:
        RequestOptions(path: EndpointConstants.postAssignPathEndpoint),
        response: Response(
          requestOptions:
          RequestOptions(path: EndpointConstants.postAssignPathEndpoint),
          statusCode: 500,
          data: {'detail': 'server boom'},
        ),
        type: DioExceptionType.badResponse,
      ));

      final result = await PathService.toggleUserPath('Y');

      expect(result.isLeft(), true);
      result.fold(
            (l) => expect((l as ServerFailure).message, 'server boom'),
            (_) => fail('Expected Left'),
      );
    });

    test('zwraca Left(ServerFailure) na DioException bez detail', () async {
      when(dio.post(
        EndpointConstants.postAssignPathEndpoint,
        data: anyNamed('data'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenThrow(DioException(
        requestOptions:
        RequestOptions(path: EndpointConstants.postAssignPathEndpoint),
        type: DioExceptionType.connectionError,
      ));

      final result = await PathService.toggleUserPath('Z');

      expect(result.isLeft(), true);
      result.fold(
            (l) => expect((l as ServerFailure).message,
            contains('Error while connecting to the server')),
            (_) => fail('Expected Left'),
      );
    });
  });
}
