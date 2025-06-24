import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef OnNotificationCallback = void Function(Map<String, dynamic> data);

class WebSocketService {
  WebSocketChannel? _channel;

  void connect(String userId, OnNotificationCallback onNotification) {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://10.0.2.2:8003/ws/notifications/$userId')
    );

    _channel!.stream.listen(
        (message) {
          final data = jsonDecode(message);
          onNotification(data);
        },
      onError: (error) {
          print('Websocket error: $error');
      },
      onDone: () {
          print('WebSocket closed');
    }
    );
  }

  void disconnect() {
    _channel?.sink.close();
  }
}