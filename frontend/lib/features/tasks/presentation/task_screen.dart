import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_routes.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/tasks/presentation/task_path.dart';
import 'package:frontend/widgets/card.dart';
import 'package:frontend/widgets/carousel.dart';
import 'package:frontend/widgets/expandable_card_grid.dart';
import 'package:frontend/widgets/menu_bar.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: CustomAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "CODZIENNE\nZADANIA",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorConstants.whiteColor,
                  fontSize: FontConstants.largeHeaderFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TaskPathWidget(
                nodes: [
                  TaskNode(text: "14.07", color: ColorConstants.darkColor),
                  TaskNode(text: "15.07", color: ColorConstants.lightBackgroundColor),
                  TaskNode(text: "DZIŚ", color: ColorConstants.darkColor, flag: true),
                ],
              ),
              CustomImageCarousel(
                text: "ZNAJDŹ SWOJE ŚCIEŻKI",
                slideBackgroundColor: ColorConstants.lightColor,
                indicatorColor: ColorConstants.blackColor,
                slides: [
                  CardItem(routeName: AppRouteConstants.pathRoute, imageUrl: 'https://picsum.photos/500/300?random=1', text: "Zdjęcie 1"),
                  CardItem(routeName: AppRouteConstants.pathRoute, imageUrl: 'https://picsum.photos/500/300?random=2', text: "Zdjęcie 2"),
                  CardItem(routeName: AppRouteConstants.pathRoute, backgroundColor: ColorConstants.whiteColor, textColor: ColorConstants.blackColor, text: "Kolor niebieski", backgroundDarkening: 0.5,),
                  CardItem(routeName: AppRouteConstants.pathRoute, backgroundColor: ColorConstants.whiteColor, textColor: ColorConstants.blackColor, text: "Kolor czerwony", backgroundDarkening: 0,),
                ],
              ),
              ExpandableCardGrid(
                  title: "polecamy",
                  initialCards: [
                    CardItem(routeName: AppRouteConstants.pathRoute, imageUrl: 'https://picsum.photos/500/300?random=3', text: "Zdjęcie 1"),
                    CardItem(routeName: AppRouteConstants.pathRoute, imageUrl: 'https://picsum.photos/500/300?random=4', text: "Zdjęcie 2"),
                    CardItem(routeName: AppRouteConstants.pathRoute, backgroundColor: ColorConstants.whiteColor, textColor: ColorConstants.blackColor, text: "Kolor niebieski", backgroundDarkening: 0.5,),
                    CardItem(routeName: AppRouteConstants.pathRoute, backgroundColor: ColorConstants.whiteColor, textColor: ColorConstants.blackColor, text: "Kolor czerwony", backgroundDarkening: 0,),
                  ],
              )
            ],
          ),
        ),
      ),
    );
  }
}