import 'package:flutter/material.dart';

class AvatarOptionItem {
  final String label;
  final Color? color;
  final String? imageUrl;

  AvatarOptionItem({
    required this.label,
    this.color,
    this.imageUrl
  });
}