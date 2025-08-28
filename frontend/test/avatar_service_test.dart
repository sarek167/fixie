import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:frontend/core/constants/api_endpoints.dart';
import 'package:frontend/core/services/token_service.dart';
import 'package:frontend/features/avatar/data/avatar_state.dart';
import 'package:frontend/core/services/avatar_service.dart';

// dart run build_runner build --delete-conflicting-outputs
@GenerateNiceMocks([MockSpec<Dio>(), MockSpec<AvatarState>()])
import 'avatar_service_test.mocks.dart';

void main() {
  group('AvatarService.getAvatarOptions', () {
    late MockDio dio;

    setUp(() {
      dio = MockDio();
      TokenClient.setTestClient(dio);
    });

    tearDown(() {
      TokenClient.setTestClient(null);
    });

    test('zwraca Map<String, List> na 200', () async {
      final resp = Response(
        requestOptions: RequestOptions(path: EndpointConstants.getUserAvatarOptionsEndpoint),
        statusCode: 200,
        data: {'hair': [], 'eyes': [], 'hats': []},
      );

      when(dio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => resp);

      final result = await AvatarService.getAvatarOptions();
      expect(result.keys, containsAll(['hair', 'eyes', 'hats']));

      verify(dio.get(
        argThat(contains(EndpointConstants.getUserAvatarOptionsEndpoint)),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).called(1);
    });

    test('rzuca na DioException', () async {
      when(dio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenThrow(DioException(requestOptions: RequestOptions(path: 'x')));

      await expectLater(
        AvatarService.getAvatarOptions(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('AvatarService.getAvatarState', () {
    late MockDio dio;

    setUp(() {
      dio = MockDio();
      TokenClient.setTestClient(dio);
    });

    tearDown(() {
      TokenClient.setTestClient(null);
    });

    test('200 → AvatarState', () async {
      final data = {
        'skin_color': '1',
        'eyes_color': 'blue',
        'hair': 'braids',
        'hair_color': 'black',
        'top_clothes': 'basic',
        'top_clothes_color': 'light_green',
        'bottom_clothes': 'pants',
        'bottom_clothes_color': 'black',
        'lipstick': '0',
        'blush': '0',
        'beard': '0',
      };

      final resp = Response(
        requestOptions: RequestOptions(path: EndpointConstants.getAvatarStateEndpoint),
        statusCode: 200,
        data: data,
      );

      when(dio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => resp);

      final state = await AvatarService.getAvatarState();
      expect(state, isA<AvatarState>());
      expect(state!.hair, 'braids');

      verify(dio.get(
        argThat(contains(EndpointConstants.getAvatarStateEndpoint)),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).called(1);
    });

    test('204 → null', () async {
      final resp = Response(
        requestOptions: RequestOptions(path: EndpointConstants.getAvatarStateEndpoint),
        statusCode: 204,
      );

      when(dio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => resp);

      final state = await AvatarService.getAvatarState();
      expect(state, isNull);
    });

    test('!= 200/204 → Exception', () async {
      final resp = Response(
        requestOptions: RequestOptions(path: EndpointConstants.getAvatarStateEndpoint),
        statusCode: 500,
        data: {'error': 'x'},
      );

      when(dio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => resp);

      await expectLater(
        AvatarService.getAvatarState(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
