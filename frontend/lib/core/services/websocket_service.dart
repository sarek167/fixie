import 'dart:async';
import 'dart:convert';
import 'package:frontend/core/constants/api_endpoints.dart';
import 'package:frontend/core/services/token_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef OnNotificationCallback =
    void Function(Map<String, dynamic> data, void Function() ack);

class WebSocketService {
  WebSocketService._();
  static final WebSocketService instance = WebSocketService._();

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  Future<void> connect(
    int userId,
    OnNotificationCallback onNotification,
  ) async {
    await disconnect();

    final userToken = await TokenClient.getUserToken(userId);
    _channel = WebSocketChannel.connect(
      Uri.parse('${EndpointConstants.wsNotificationsBase}?token=$userToken'),
    );

    _channel!.stream.listen(
      (message) {
        try {
          final dynamic decoded = jsonDecode(message);
          if (decoded is! Map<String, dynamic>) return;
          final data = Map<String, dynamic>.from(decoded);

          final id = data["notification_id"];
          void ack() {
            if (id != null) {
              _channel?.sink.add(
                jsonEncode({"type": "ack", "notification_id": id}),
              );
            }
          }

          onNotification(data, ack);
        } catch (e) {
          print('Error decoding message: $e');
        }
      },
      onError: (error) {
        print('Websocket error: $error');
      },
      onDone: () {
        print('WebSocket closed');
      },
    );
  }

  Future<void> disconnect({int? code, String? reason}) async {
    await _subscription?.cancel();
    _subscription = null;
    await _channel?.sink.close(code,reason);
    _channel = null;
  }
}
