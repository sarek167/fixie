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
                  text: "TWOJE ŚCIEŻKI",
                  indicatorColor: ColorConstants.lightBackgroundColor,
                  slides: [
                    CardItem(routeName: "/login", imageUrl: 'https://picsum.photos/500/300?random=1', text: "Zdjęcie 1"),
                    CardItem(routeName: "/login", imageUrl: 'https://picsum.photos/500/300?random=2', text: "Zdjęcie 2"),
                    CardItem(routeName: "/login", backgroundColor: ColorConstants.lightColor, text: "Kolor niebieski", backgroundDarkening: 0.5,),
                    CardItem(routeName: "/login", backgroundColor: ColorConstants.semiLightColor, text: "Kolor czerwony", backgroundDarkening: 0,),
                  ],
                ),
              ],
            ),
        ),
      ),
    );
  }
}