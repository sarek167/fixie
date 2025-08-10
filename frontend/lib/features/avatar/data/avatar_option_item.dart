import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/core/constants/avatar_storage.dart';
import 'package:frontend/core/utils/hex_color.dart';

class AvatarOptionItem {
  final String label;
  final Color? color;
  final String? imageUrl;

  AvatarOptionItem({
    required this.label,
    this.color,
    this.imageUrl
  });

  static List<AvatarOptionItem> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) => AvatarOptionItem.fromSingleJson(e)).toList();
  }

  factory AvatarOptionItem.fromSingleJson(Map<String, dynamic> json) {
    return AvatarOptionItem(
        label: json['blob_name'],
        color: json["color_to_display"] != null
          ? HexColor(json['color_to_display'])
          : null ,
        imageUrl: 'https://${AvatarStorage.storageName}.blob.core.windows.net/${json["container_name"]}/${json["blob_name"]}.png',
    );
  }
}