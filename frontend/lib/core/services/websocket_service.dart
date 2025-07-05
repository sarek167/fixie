import 'dart:convert';
import 'package:frontend/core/services/token_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef OnNotificationCallback = void Function(Map<String, dynamic> data);

class WebSocketService {
  WebSocketChannel? _channel;


  Future<void> connect(int userId, OnNotificationCallback onNotification) async {
    final userToken = await TokenClient.getUserToken(userId);
    _channel = WebSocketChannel.connect(
        Uri.parse('ws://10.0.2.2:8003/ws/notifications/?token=$userToken')
    );

    _channel!.stream.listen(
        (message) {
          final data = jsonDecode(message);
          print("DOSTAŁO WIADOMOŚĆ");
          print(message);
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