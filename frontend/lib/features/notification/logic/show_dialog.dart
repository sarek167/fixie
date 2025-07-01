import 'package:flutter/material.dart';
import 'package:frontend/features/notification/presentation/notification_dialog.dart';
import 'package:frontend/main.dart';

class NotificationManager {
  final List<Map<String, dynamic>> _notificationQueue = [];
  bool _isShowing = false;

  void show(Map<String, dynamic> data) {
    _notificationQueue.add(data);
    _tryShowNext();
  }

  void _tryShowNext() async {
    if (_isShowing || _notificationQueue.isEmpty) return;

    _isShowing = true;
    final data = _notificationQueue.removeAt(0);

    final context = navigatorKey.currentContext;
    if (context == null) {
      _isShowing = false;
      return;
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlert(data: data);
      }
    );
    _isShowing = false;
    _tryShowNext();
    
  }

}