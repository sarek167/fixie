import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/core/constants/avatar_storage.dart';
import 'package:frontend/features/avatar/data/avatar_option_item.dart';
import 'package:frontend/features/avatar/presentation/avatar_carousel.dart';
import 'package:frontend/features/avatar/data/avatar_single_tab.dart';

class AvatarOptions {
  static List<AvatarSingleTab> allTabs = [
    AvatarSingleTab(
      backgroundColor: ColorConstants.veryLight,
      carousels: [
        AvatarCarousel(title: "SKÓRA", partKey: "skinColor", options: [
          AvatarOptionItem(label: "1", color: AvatarSkinColors.skin1),
          AvatarOptionItem(label: "2", color: AvatarSkinColors.skin2),
          AvatarOptionItem(label: "3", color: AvatarSkinColors.skin3),
          AvatarOptionItem(label: "4", color: AvatarSkinColors.skin4),
          AvatarOptionItem(label: "5", color: AvatarSkinColors.skin5),
          AvatarOptionItem(label: "6", color: AvatarSkinColors.skin6),
          AvatarOptionItem(label: "7", color: AvatarSkinColors.skin7),
          AvatarOptionItem(label: "8", color: AvatarSkinColors.skin8),
        ]),
        AvatarCarousel(title: "OCZY", partKey: "eyes", options: [
          AvatarOptionItem(label: "1", color: Colors.pink),
          AvatarOptionItem(label: "2", color: Colors.brown),
          AvatarOptionItem(label: "3", color:Colors.orange)
        ]),
      ]
    ),
    AvatarSingleTab(
      backgroundColor: ColorConstants.light,
      carousels: [
        AvatarCarousel(title: "WŁOSY", partKey: "hair", options: [
          AvatarOptionItem(label: "braids", imageUrl: 'https://fixieavatarimg.blob.core.windows.net/hair/braids-red.png'),
          AvatarOptionItem(label: "bob", imageUrl: 'https://fixieavatarimg.blob.core.windows.net/hair/bob-red.png')
        ])
     ]
    ),
    AvatarSingleTab(
      backgroundColor: ColorConstants.semiLight,
      carousels: [
        AvatarCarousel(title: "BRODA", partKey: "beard", options: [
          AvatarOptionItem(label: "1", color: Colors.pink),
          AvatarOptionItem(label: "2", color: Colors.brown),
          AvatarOptionItem(label: "3", color:Colors.orange)
        ]),
      ]
    ),
    const AvatarSingleTab(
        backgroundColor: ColorConstants.dark,
        carousels: [
          // AvatarCarousel(title: "OKULARY", colors: [Colors.black, Colors.grey]),
          // AvatarCarousel(title: "NAKRYCIE GŁOWY", colors: [Colors.yellow, Colors.indigo]),
        ]
    ),
    const AvatarSingleTab(
        backgroundColor: ColorConstants.lightBackground,
        carousels: [
          // AvatarCarousel(title: "OKULARY", colors: [Colors.black, Colors.grey]),
          // AvatarCarousel(title: "NAKRYCIE GŁOWY", colors: [Colors.yellow, Colors.indigo]),
        ]
    ),
  ];
}