import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:frontend/core/services/websocket_service.dart';

// dart run build_runner build --delete-conflicting-outputs
@GenerateNiceMocks([MockSpec<WebSocketChannel>(), MockSpec<WebSocketSink>()])
import 'websocket_service_test.mocks.dart';

void main() {
  late WebSocketService service;
  late MockWebSocketChannel ch1;
  late MockWebSocketChannel ch2;
  late MockWebSocketSink sink1;
  late MockWebSocketSink sink2;
  late StreamController<String> ctrl1;
  late StreamController<String> ctrl2;

  setUp(() {
    service = WebSocketService.instance;

    ch1 = MockWebSocketChannel();
    ch2 = MockWebSocketChannel();
    sink1 = MockWebSocketSink();
    sink2 = MockWebSocketSink();
    ctrl1 = StreamController<String>.broadcast();
    ctrl2 = StreamController<String>.broadcast();

    when(ch1.stream).thenAnswer((_) => ctrl1.stream);
    when(ch2.stream).thenAnswer((_) => ctrl2.stream);
    when(ch1.sink).thenReturn(sink1);
    when(ch2.sink).thenReturn(sink2);

    when(sink1.close(any, any)).thenAnswer((_) async {});
    when(sink2.close(any, any)).thenAnswer((_) async {});
  });

  tearDown(() async {
    await service.disconnect();
    service.debugOverrideChannel = null;

    await ctrl1.close();
    await ctrl2.close();
  });

  Future<void> pump() async {
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
  }
  test('connect: nasłuchuje i wywołuje callback oraz ack', () async {
    service.debugOverrideChannel = ch1;

    Map<String, dynamic>? got;
    void Function()? ackCb;

    await service.connect(42, (data, ack) {
      got = data;
      ackCb = ack;
    });

    ctrl1.add(jsonEncode({
      "title": "Hello",
      "message": "World",
      "notification_id": 7,
    }));
    await pump();

    expect(got, isNotNull);
    expect(got!["title"], "Hello");
    expect(got!["message"], "World");

    ackCb!.call();
    verify(sink1.add(jsonEncode({"type": "ack", "notification_id": 7}))).called(1);
  });

  test('connect: brak notification_id -> ack nic nie wysyła', () async {
    service.debugOverrideChannel = ch1;
    void Function()? ackCb;

    await service.connect(7, (_, ack) => ackCb = ack);

    ctrl1.add(jsonEncode({"title": "No id"}));
    await pump();

    ackCb!.call();
    verifyNever(sink1.add(any));
  });

  test('connect: zły JSON nie wywołuje callbacku', () async {
    service.debugOverrideChannel = ch1;
    var called = false;

    await service.connect(1, (_, __) => called = true);

    ctrl1.add("{bad json");
    await pump();

    expect(called, isFalse);
  });

  test('ponowny connect zamyka poprzedni kanał (sink.close)', () async {
    service.debugOverrideChannel = ch1;
    await service.connect(1, (_, __) {});
    // teraz przełącz na drugi kanał
    service.debugOverrideChannel = ch2;
    await service.connect(1, (_, __) {});

    verify(sink1.close(any, any)).called(1);
  });

  test('disconnect zamyka kanał z kodem i powodem', () async {
    service.debugOverrideChannel = ch1;
    await service.connect(1, (_, __) {});
    await service.disconnect(code: 4000, reason: "bye");

    verify(sink1.close(4000, "bye")).called(1);
  });
}
