import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/avatar/data/avatar_options.dart';
import 'package:frontend/features/avatar/presentation/avatar_carousel.dart';
import 'package:frontend/features/avatar/data/avatar_single_tab.dart';

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
                  color: ColorConstants.veryLightColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16))
                ),
                 child: Icon(Icons.accessibility_new, color: ColorConstants.whiteColor, size: FontConstants.largeHeaderFontSize)
              ),
            ),
            Tab(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                      color: ColorConstants.lightColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16))
                  ),
                  child: Icon(Icons.brush, color: ColorConstants.whiteColor, size: FontConstants.largeHeaderFontSize)
              ),
            ),
            Tab(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                      color: ColorConstants.semiLightColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16))
                  ),
                  child: Icon(Icons.remove_red_eye, color: ColorConstants.whiteColor, size: FontConstants.largeHeaderFontSize)
              ),
            ),
            Tab(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                      color: ColorConstants.darkColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16))
                  ),
                  child: Icon(Icons.emoji_people, color: ColorConstants.whiteColor, size: FontConstants.largeHeaderFontSize)
              ),
            ),
            Tab(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                      color: ColorConstants.lightBackgroundColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16))
                  ),
                  child: Icon(Icons.pets, color: ColorConstants.whiteColor, size: FontConstants.largeHeaderFontSize,)
              ),
            ),
          ],
        ),


        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: AvatarOptions.allTabs.map((tab) {
              return Container(
                color: tab.backgroundColor,
                child: ListView(
                  children: tab.carousels.map((carousel) =>
                    AvatarCarousel(title: carousel.title, colors: carousel.colors ?? [], images: carousel.images ?? [])
                  ).toList(),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }


}
