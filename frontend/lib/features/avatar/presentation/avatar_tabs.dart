import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/core/services/avatar_service.dart';
import 'package:frontend/features/avatar/data/avatar_options.dart';
import 'package:frontend/features/avatar/data/avatar_single_tab.dart';
import 'package:frontend/features/avatar/presentation/avatar_carousel.dart';

class AvatarCustomizationTabs extends StatefulWidget {
  const AvatarCustomizationTabs({super.key});

  @override
  _AvatarCustomizationTabsState createState() => _AvatarCustomizationTabsState();
}

class _AvatarCustomizationTabsState extends State<AvatarCustomizationTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: false,
          indicatorColor: Colors.transparent,
          labelPadding: EdgeInsets.zero,
          tabs: [
            Tab(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: ColorConstants.veryLight,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16))
                ),
                 child: Icon(Icons.accessibility_new, color: ColorConstants.white, size: FontConstants.largeHeaderFontSize)
              ),
            ),
            Tab(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                      color: ColorConstants.light,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16))
                  ),
                  child: Icon(Icons.brush, color: ColorConstants.white, size: FontConstants.largeHeaderFontSize)
              ),
            ),
            Tab(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                      color: ColorConstants.semiLight,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16))
                  ),
                  child: Icon(Icons.remove_red_eye, color: ColorConstants.white, size: FontConstants.largeHeaderFontSize)
              ),
            ),
            Tab(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                      color: ColorConstants.dark,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16))
                  ),
                  child: Icon(Icons.emoji_people, color: ColorConstants.white, size: FontConstants.largeHeaderFontSize)
              ),
            ),
            Tab(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                      color: ColorConstants.lightBackground,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16))
                  ),
                  child: Icon(Icons.pets, color: ColorConstants.white, size: FontConstants.largeHeaderFontSize,)
              ),
            ),
          ],
        ),

        FutureBuilder(
            future: AvatarService.getAvatarOptions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                print("W AVATAR TABS");
                print(snapshot.data!);
                final avatarMap = snapshot.data!;
                final List<AvatarSingleTab> tabs = [
                  AvatarSingleTab(
                    backgroundColor: ColorConstants.veryLight,
                    carousels: [
                      AvatarCarousel(title: "SKÓRA", partKey: "skinColor", options: avatarMap["base"] ?? []),
                      AvatarCarousel(title: "OCZY", partKey: "eyesColor", options: avatarMap["eyes"] ?? []),
                    ],
                  ),
                  AvatarSingleTab(
                    backgroundColor: ColorConstants.light,
                    carousels: [
                      AvatarCarousel(title: "WŁOSY", partKey: "hair", options: avatarMap["hair"] ?? [], isColor: false,),
                      AvatarCarousel(title: "KOLOR WŁOSÓW", partKey: "hairColor", options: avatarMap["hair"] ?? []),

                    ],
                  ),
                  AvatarSingleTab(
                    backgroundColor: ColorConstants.semiLight,
                    carousels: [
                      AvatarCarousel(title: "SZMINKA", partKey: "lipstick", options: avatarMap["lipstick"] ?? [], hasEmpty: true,),
                      AvatarCarousel(title: "RUMIENIEC", partKey: "blush", options: avatarMap["blush"] ?? [], hasEmpty: true,),
                      AvatarCarousel(title: "BRODA", partKey: "beard", options: avatarMap["beard"] ?? [], isColor: true, hasEmpty: true,),
                    ],
                  ),
                  AvatarSingleTab(
                    backgroundColor: ColorConstants.dark,
                    carousels: [
                      AvatarCarousel(title: "GÓRNE UBRANIE", partKey: "topClothes", options: avatarMap["top-clothes"] ?? [], isColor: false,),
                      AvatarCarousel(title: "KOLOR", partKey: "topClothesColor", options: avatarMap["top-clothes"] ?? []),
                      AvatarCarousel(title: "DOLNE UBRANIE", partKey: "bottomClothes", options: avatarMap["bottom-clothes"] ?? [], isColor: false,),
                      AvatarCarousel(title: "KOLOR", partKey: "bottomClothesColor", options: avatarMap["bottom-clothes"] ?? []),

                    ],
                  ),
                  const AvatarSingleTab(
                    backgroundColor: ColorConstants.lightBackground,
                    carousels: [],
                  ),
                ];
                return Expanded(
                  child: TabBarView(
                    controller: _tabController,

                    children: tabs.map((tab) {
                      return Container(
                        color: tab.backgroundColor,
                        child: ListView(
                          children: tab.carousels.map((carousel) =>
                          AvatarCarousel(
                            title: carousel.title,
                            partKey: carousel.partKey,
                            options: carousel.options,
                            isColor: carousel.isColor,
                            hasEmpty: carousel.hasEmpty,
                          )
                          ).toList(),
                        ),
                      );
                    }).toList()
                  ),
                );
              }
            }
        )

      ],
    );
  }


}
