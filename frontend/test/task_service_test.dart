import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:frontend/core/constants/api_endpoints.dart';
import 'package:frontend/core/services/token_service.dart';
import 'package:frontend/features/tasks/presentation/task_path.dart';
import 'package:frontend/features/tasks/data/task_model.dart';
import 'package:frontend/core/services/task_service.dart';

// dart run build_runner build --delete-conflicting-outputs
@GenerateNiceMocks([MockSpec<Dio>()])
import 'task_service_test.mocks.dart';

String _iso(String s) => DateTime.parse(s).toIso8601String();

Map<String, dynamic> _taskJson({
  required int id,
  required String title,
  required String description,
  required String category,
  required String answerType, // "text" | "checkbox"
  int difficulty = 1,
  String type = 'daily',
  String createdAt = '2025-08-01T09:00:00Z',
  String updatedAt = '2025-08-01T10:00:00Z',
  String? dateForDaily = '2025-08-01',
  String status = 'pending',
}) {
  return {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'difficulty': difficulty,
    'type': type,
    'date_for_daily': dateForDaily, // może być null; TaskModel sobie poradzi
    'created_at': _iso(createdAt),
    'updated_at': _iso(updatedAt),
    'status': status,
    'answer_type': answerType, // MUSI być nie-null, bo fromJson woła .toLowerCase()
  };
}

void main() {
  group('TaskService.submitAnswer', () {
    late MockDio dio;
    late TaskNode textTask;
    late TaskNode checkboxTask;

    setUp(() {
      dio = MockDio();
      TokenClient.setTestClient(dio);
      textTask = TaskNode(
        id: 1,
        text: 'Write something',
        color: Colors.red,
        answerType: 'text',
      );
      checkboxTask = TaskNode(
        id: 2,
        text: 'Check me',
        color: Colors.blue,
        answerType: 'checkbox',
      );
    });

    tearDown(() {
      TokenClient.setTestClient(null);
    });

    test('returns true on 200 for text task', () async {
      final response = Response(
        requestOptions: RequestOptions(path: EndpointConstants.postTaskAnswerEndpoint),
        statusCode: 200,
      );

      when(dio.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => response);

      final ok = await TaskService.submitAnswer(textTask, 'ans', null);
      expect(ok, true);

      verify(dio.post(
        argThat(contains(EndpointConstants.postTaskAnswerEndpoint)),
        data: {
          'task_id': 1,
          'text_answer': 'ans',
          'checkbox_answer': null,
        },
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).called(1);
    });

    test('returns true on 201 for checkbox task', () async {
      final response = Response(
        requestOptions: RequestOptions(path: EndpointConstants.postTaskAnswerEndpoint),
        statusCode: 201,
      );

      when(dio.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => response);

      final ok = await TaskService.submitAnswer(checkboxTask, null, true);
      expect(ok, true);

      verify(dio.post(
        argThat(contains(EndpointConstants.postTaskAnswerEndpoint)),
        data: {
          'task_id': 2,
          'text_answer': null,
          'checkbox_answer': true,
        },
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).called(1);
    });

    test('returns false on non-200/201', () async {
      final response = Response(
        requestOptions: RequestOptions(path: EndpointConstants.postTaskAnswerEndpoint),
        statusCode: 400,
        data: {'error': 'bad'},
      );

      when(dio.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => response);

      final ok = await TaskService.submitAnswer(textTask, 'x', null);
      expect(ok, false);
    });

    test('returns false on exception', () async {
      when(dio.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: EndpointConstants.postTaskAnswerEndpoint),
      ));

      final ok = await TaskService.submitAnswer(textTask, 'x', null);
      expect(ok, false);
    });
  });

  group('TaskService.countStreak', () {
    late MockDio dio;

    setUp(() {
      dio = MockDio();
      TokenClient.setTestClient(dio);
    });

    tearDown(() {
      TokenClient.setTestClient(null);
    });

    test('returns streak on 200', () async {
      final response = Response(
        requestOptions: RequestOptions(path: EndpointConstants.getStreakEndpoint),
        statusCode: 200,
        data: {'streak': 7},
      );

      when(dio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => response);

      final streak = await TaskService.countStreak();
      expect(streak, 7);

      verify(dio.get(
        argThat(contains(EndpointConstants.getStreakEndpoint)),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).called(1);
    });

    test('returns -1 on exception', () async {
      when(dio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: EndpointConstants.getStreakEndpoint),
      ));

      final streak = await TaskService.countStreak();
      expect(streak, -1);
    });
  });

  group('TaskService.getDailyTasks', () {
    late MockDio dio;

    setUp(() {
      dio = MockDio();
      TokenClient.setTestClient(dio);
    });

    tearDown(() {
      TokenClient.setTestClient(null);
    });

    test('returns parsed List<TaskModel> on 200', () async {
      final response = Response(
        requestOptions: RequestOptions(path: EndpointConstants.getDailyTasksEndpoint),
        statusCode: 200,
        data: {
          'tasks': [
            _taskJson(
              id: 1,
              title: 'Do A',
              description: 'desc A',
              category: 'cat',
              answerType: 'text',
              dateForDaily: '2025-08-01',
            ),
            _taskJson(
              id: 2,
              title: 'Do B',
              description: 'desc B',
              category: 'cat',
              answerType: 'checkbox',
              dateForDaily: '2025-08-02',
              status: 'completed',
            ),
          ],
        },
      );

      when(dio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => response);

      final tasks = await TaskService.getDailyTasks();
      expect(tasks, isA<List<TaskModel>>());
      expect(tasks.length, 2);
      expect(tasks[0].answerType, 'text');
      expect(tasks[1].answerType, 'checkbox');
      expect(tasks[1].status, 'completed');

      verify(dio.get(
        argThat(contains(EndpointConstants.getDailyTasksEndpoint)),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).called(1);
    });

    test('throws on non-200', () async {
      final response = Response(
        requestOptions: RequestOptions(path: EndpointConstants.getDailyTasksEndpoint),
        statusCode: 500,
        data: {'error': 'x'},
      );

      when(dio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => response);

      expect(() => TaskService.getDailyTasks(), throwsA(isA<Exception>()));
    });

    test('throws on exception', () async {
      when(dio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: EndpointConstants.getDailyTasksEndpoint),
      ));

      expect(() => TaskService.getDailyTasks(), throwsA(isA<Exception>()));
    });
  });

  group('TaskService.getDailyTaskByDate', () {
    late MockDio dio;

    setUp(() {
      dio = MockDio();
      TokenClient.setTestClient(dio);
    });

    tearDown(() {
      TokenClient.setTestClient(null);
    });

    test('returns TaskModel on 200', () async {
      final response = Response(
        requestOptions: RequestOptions(path: EndpointConstants.getDailyTaskByDateEndpoint),
        statusCode: 200,
        data: _taskJson(
          id: 11,
          title: 'Single Task',
          description: 'one',
          category: 'cat',
          answerType: 'text',
          dateForDaily: '2025-08-01',
        ),
      );

      when(dio.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => response);

      final model = await TaskService.getDailyTaskByDate('2025-08-01');
      expect(model, isA<TaskModel>());
      expect(model.id, 11);
      expect(model.answerType, 'text');

      verify(dio.post(
        argThat(contains(EndpointConstants.getDailyTaskByDateEndpoint)),
        data: {'date': '2025-08-01'},
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).called(1);
    });

    test('throws on exception', () async {
      when(dio.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onSendProgress: anyNamed('onSendProgress'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: EndpointConstants.getDailyTaskByDateEndpoint),
      ));

      expect(() => TaskService.getDailyTaskByDate('2025-08-01'), throwsA(isA<Exception>()));
    });
  });

  group('TaskService.getDailyTasksStatus', () {
    late MockDio dio;

    setUp(() {
      dio = MockDio();
      TokenClient.setTestClient(dio);
    });

    tearDown(() {
      TokenClient.setTestClient(null);
    });

    test('returns list of maps on 200', () async {
      final response = Response(
        requestOptions: RequestOptions(path: EndpointConstants.getDailyTasksStatusEndpoint),
        statusCode: 200,
        data: {
          'tasks': [
            {'date': '2025-08-01', 'status': 'completed'},
            {'date': '2025-08-02', 'status': 'pending'},
          ],
        },
      );

      when(dio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => response);

      final statuses = await TaskService.getDailyTasksStatus();
      expect(statuses, isA<List<Map<String, dynamic>>>());
      expect(statuses.length, 2);
      expect(statuses[0]['status'], 'completed');

      verify(dio.get(
        argThat(contains(EndpointConstants.getDailyTasksStatusEndpoint)),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).called(1);
    });

    test('throws on non-200', () async {
      final response = Response(
        requestOptions: RequestOptions(path: EndpointConstants.getDailyTasksStatusEndpoint),
        statusCode: 404,
        data: {},
      );

      when(dio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => response);

      expect(() => TaskService.getDailyTasksStatus(), throwsA(isA<Exception>()));
    });

    test('throws on exception', () async {
      when(dio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: EndpointConstants.getDailyTasksStatusEndpoint),
      ));

      expect(() => TaskService.getDailyTasksStatus(), throwsA(isA<Exception>()));
    });
  });
}
