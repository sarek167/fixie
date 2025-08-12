import 'dart:convert';
import 'package:frontend/core/services/token_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef OnNotificationCallback =
    void Function(Map<String, dynamic> data, void Function() ack);

class WebSocketService {
  WebSocketChannel? _channel;

  Future<void> connect(
    int userId,
    OnNotificationCallback onNotification,
  ) async {
    final userToken = await TokenClient.getUserToken(userId);
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://10.0.2.2:8003/ws/notifications/?token=$userToken'),
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

  void disconnect() {
    _channel?.sink.close();
  }
}
