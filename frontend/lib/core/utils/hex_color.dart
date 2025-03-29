import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    final hex = hexColor.replaceAll("#", "");
    return int.parse("FF$hex", radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static Color fromHex(String hexColor) => HexColor(hexColor);
}