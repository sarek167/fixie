import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_routes.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/core/services/path_service.dart';
import 'package:frontend/core/services/task_service.dart';
import 'package:frontend/core/utils/hex_color.dart';
import 'package:frontend/features/authentication/data/user_model.dart';
import 'package:frontend/features/authentication/logic/user_storage.dart';
import 'package:frontend/widgets/avatar.dart';
import 'package:frontend/widgets/card.dart';
import 'package:frontend/widgets/carousel.dart';
import 'package:frontend/widgets/circle_button.dart';
import 'package:frontend/widgets/menu_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: UserStorage().getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
        return Scaffold(
          appBar: const CustomAppBar(streak: 0),
          body: Center(
            child: Text("Error while loading streak: ${snapshot.error}"))
          );
        } else {
          return Scaffold(
            backgroundColor: ColorConstants.backgroundColor,
            appBar: CustomAppBar(streak: snapshot.data!.streak),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      AvatarWidget(),
                      CircleButton()
                    ],
                  ),
                  SizedBox(height: 30,),
                  FutureBuilder(
                      future: PathService.getUserPaths(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return CustomImageCarousel(
                            text: "ZNAJDŹ SWOJE ŚCIEŻKI",
                            slideBackgroundColor: ColorConstants.darkColor,
                            indicatorColor: ColorConstants.lightColor,
                            slides: [
                              ...snapshot.data!.map((path) => CardItem(
                                routeName: AppRouteConstants.pathRoute,
                                textColor: path.isImage ? ColorConstants.whiteColor : ColorConstants.blackColor,
                                text: path.title,
                                imageUrl: path.isImage ? path.backgroundValue : null,
                                backgroundColor: path.isColor || path.isDefault ? HexColor.fromHex(path.backgroundValue) : null,
                                // backgroundDarkening: 0.2,
                              )),
                            ],
                          );
                        }
                      }),
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
    );
  }
}