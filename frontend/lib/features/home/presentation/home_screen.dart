import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_routes.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/core/services/path_service.dart';
import 'package:frontend/core/services/task_service.dart';
import 'package:frontend/core/services/websocket_service.dart';
import 'package:frontend/core/utils/hex_color.dart';
import 'package:frontend/features/authentication/data/user_model.dart';
import 'package:frontend/features/authentication/logic/user_storage.dart';
import 'package:frontend/widgets/avatar.dart';
import 'package:frontend/widgets/card.dart';
import 'package:frontend/widgets/carousel.dart';
import 'package:frontend/widgets/circle_button.dart';
import 'package:frontend/widgets/menu_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WebSocketService _webSocketService = WebSocketService();
  User? _user;

  @override
  void initState() {
    super.initState();

    UserStorage().getUser().then((user) {
      if (user != null) {
        setState(() {
          _user = user;
        });

        _webSocketService.connect(user.id.toString(), (data) {
            print(data);
        });
      }
    });

  }

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
            backgroundColor: ColorConstants.background,
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
                            slideBackgroundColor: ColorConstants.dark,
                            indicatorColor: ColorConstants.light,
                            slides: [
                              ...snapshot.data!.map((path) => CardItem(
                                routeName: AppRouteConstants.pathRoute,
                                textColor: path.isImage ? ColorConstants.white : ColorConstants.black,
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
                    slideBackgroundColor: ColorConstants.light,
                    indicatorColor: ColorConstants.black,
                    slides: [
                      CardItem(routeName: "/login", imageUrl: 'https://picsum.photos/500/300?random=3', text: "Zdjęcie 1"),
                      CardItem(routeName: "/login", imageUrl: 'https://picsum.photos/500/300?random=4', text: "Zdjęcie 2"),
                      CardItem(routeName: "/login", backgroundColor: ColorConstants.white, textColor: ColorConstants.black, text: "Kolor niebieski", backgroundDarkening: 0.5,),
                      CardItem(routeName: "/login", backgroundColor: ColorConstants.white, textColor: ColorConstants.black, text: "Kolor czerwony", backgroundDarkening: 0,),
                    ],
                  ),
                  CustomImageCarousel(
                    text: "DOWIEDZ SIĘ WIĘCEJ",
                    slideBackgroundColor: ColorConstants.veryLight,
                    indicatorColor: ColorConstants.black,
                    slides: [
                      CardItem(routeName: "/login", imageUrl: 'https://picsum.photos/500/300?random=5', text: "Zdjęcie 1"),
                      CardItem(routeName: "/login", imageUrl: 'https://picsum.photos/500/300?random=6', text: "Zdjęcie 2"),
                      CardItem(routeName: "/login", backgroundColor: ColorConstants.white, textColor: ColorConstants.black, text: "Kolor niebieski", backgroundDarkening: 0.5,),
                      CardItem(routeName: "/login", backgroundColor: ColorConstants.white, textColor: ColorConstants.black, text: "Kolor czerwony", backgroundDarkening: 0,),
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