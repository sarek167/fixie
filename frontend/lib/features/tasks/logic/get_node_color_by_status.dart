import 'dart:ui';
import 'package:frontend/core/constants/app_theme.dart';

Color getColorByStatus(String status) {
  switch (status) {
    case 'completed':
      return ColorConstants.lightBackgroundColor;
    case 'in_progress':
      return ColorConstants.lightColor;
    case 'pending':
    default:
      return ColorConstants.darkColor;
  }
}