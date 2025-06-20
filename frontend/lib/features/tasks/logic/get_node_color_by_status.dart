import 'dart:ui';
import 'package:frontend/core/constants/app_theme.dart';

Color getColorByStatus(String status) {
  switch (status) {
    case 'completed':
      return ColorConstants.lightBackground;
    case 'in_progress':
      return ColorConstants.light;
    case 'pending':
    default:
      return ColorConstants.dark;
  }
}