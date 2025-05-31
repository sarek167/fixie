import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/avatar/presentation/avatar_carousel.dart';
import 'package:frontend/features/avatar/data/avatar_single_tab.dart';

class AvatarOptions {
  static const List<AvatarSingleTab> allTabs = [
    AvatarSingleTab(
      backgroundColor: ColorConstants.veryLightColor,
      carousels: [
        AvatarCarousel(title: "SKÓRA", colors: [Colors.pink, Colors.brown, Colors.orange]),
        AvatarCarousel(title: "WŁOSY", images: [
          'https://fixieavatarimg.blob.core.windows.net/hair/braids-red.png',
          'https://fixieavatarimg.blob.core.windows.net/hair/bob-red.png',
          'https://fixieavatarimg.blob.core.windows.net/hair/braids-red.png',
          'https://fixieavatarimg.blob.core.windows.net/hair/bob-red.png',
          'https://fixieavatarimg.blob.core.windows.net/hair/braids-red.png',
          'https://fixieavatarimg.blob.core.windows.net/hair/bob-red.png',
        ])

      ]
    ),
    AvatarSingleTab(
      backgroundColor: ColorConstants.lightColor,
      carousels: [
        AvatarCarousel(title: "OCZY", colors: [Colors.blue, Colors.green, Colors.cyan])
      ]
    ),
    AvatarSingleTab(
      backgroundColor: ColorConstants.semiLightColor,
      carousels: [
        AvatarCarousel(title: "OKULARY", colors: [Colors.black, Colors.grey]),
        AvatarCarousel(title: "NAKRYCIE GŁOWY", colors: [Colors.yellow, Colors.indigo]),
      ]
    ),
    AvatarSingleTab(
        backgroundColor: ColorConstants.darkColor,
        carousels: [
          AvatarCarousel(title: "OKULARY", colors: [Colors.black, Colors.grey]),
          AvatarCarousel(title: "NAKRYCIE GŁOWY", colors: [Colors.yellow, Colors.indigo]),
        ]
    ),
    AvatarSingleTab(
        backgroundColor: ColorConstants.lightBackgroundColor,
        carousels: [
          AvatarCarousel(title: "OKULARY", colors: [Colors.black, Colors.grey]),
          AvatarCarousel(title: "NAKRYCIE GŁOWY", colors: [Colors.yellow, Colors.indigo]),
        ]
    ),
  ];
}