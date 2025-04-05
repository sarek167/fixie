import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/widgets/card.dart';
import 'package:frontend/widgets/carousel.dart';
import 'package:frontend/widgets/menu_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                CustomImageCarousel(
                  text: "ZNAJDŹ SWOJE ŚCIEŻKI",
                  slideBackgroundColor: ColorConstants.semiLightColor,
                  indicatorColor: ColorConstants.blackColor,
                  slides: [
                    CardItem(routeName: "/login", imageUrl: 'https://picsum.photos/id/237/500/300', text: "Zdjęcie 1"),
                    CardItem(routeName: "/login", imageUrl: 'https://picsum.photos/500/300?random=2', text: "Zdjęcie 2"),
                    CardItem(routeName: "/login", backgroundColor: ColorConstants.whiteColor, textColor: ColorConstants.blackColor, text: "Kolor niebieski", backgroundDarkening: 0.5,),
                    CardItem(routeName: "/login", backgroundColor: ColorConstants.whiteColor, textColor: ColorConstants.blackColor, text: "Kolor czerwony", backgroundDarkening: 0,),
                  ],
                ),
                CustomImageCarousel(
                  text: "CO CHODZI CI PO GŁOWIE",
                  slideBackgroundColor: ColorConstants.lightColor,
                  indicatorColor: ColorConstants.blackColor,
                  slides: [
                    CardItem(routeName: "/login", imageUrl: 'https://picsum.photos/500/300?random=3', text: "Zdjęcie 1"),
                    CardItem(routeName: "/login", imageUrl: 'https://picsum.photos/500/300?random=4', text: "Zdjęcie 2"),
                    CardItem(routeName: "/login", backgroundColor: ColorConstants.whiteColor, textColor: ColorConstants.blackColor, text: "Kolor niebieski", backgroundDarkening: 0.5,),
                    CardItem(routeName: "/login", backgroundColor: ColorConstants.whiteColor, textColor: ColorConstants.blackColor, text: "Kolor czerwony", backgroundDarkening: 0,),
                  ],
                ),
                CustomImageCarousel(
                  text: "DOWIEDZ SIĘ WIĘCEJ",
                  slideBackgroundColor: ColorConstants.veryLightColor,
                  indicatorColor: ColorConstants.blackColor,
                  slides: [
                    CardItem(routeName: "/login", imageUrl: 'https://picsum.photos/500/300?random=5', text: "Zdjęcie 1"),
                    CardItem(routeName: "/login", imageUrl: 'https://picsum.photos/500/300?random=6', text: "Zdjęcie 2"),
                    CardItem(routeName: "/login", backgroundColor: ColorConstants.whiteColor, textColor: ColorConstants.blackColor, text: "Kolor niebieski", backgroundDarkening: 0.5,),
                    CardItem(routeName: "/login", backgroundColor: ColorConstants.whiteColor, textColor: ColorConstants.blackColor, text: "Kolor czerwony", backgroundDarkening: 0,),
                  ],
                ),
              ],
            ),
        ),
      ),
    );
  }
}