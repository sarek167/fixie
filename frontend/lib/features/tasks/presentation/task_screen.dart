import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_routes.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/core/services/path_service.dart';
import 'package:frontend/core/services/task_service.dart';
import 'package:frontend/core/utils/hex_color.dart';
import 'package:frontend/features/authentication/data/user_model.dart';
import 'package:frontend/features/authentication/logic/user_storage.dart';
import 'package:frontend/features/tasks/logic/get_node_color_by_status.dart';
import 'package:frontend/features/tasks/presentation/task_path.dart';
import 'package:frontend/widgets/card.dart';
import 'package:frontend/widgets/carousel.dart';
import 'package:frontend/widgets/expandable_card_grid.dart';
import 'package:frontend/widgets/menu_bar.dart';
import 'package:intl/intl.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

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
                    Text(
                      "CODZIENNE\nZADANIA",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorConstants.whiteColor,
                        fontSize: FontConstants.largeHeaderFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FutureBuilder(
                      future: TaskService.getDailyTasks(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          final List<TaskNode> nodes = snapshot.data!.asMap().entries.map((entry) {
                            final index = entry.key;
                            final task = entry.value;
                            return TaskNode(
                                id: task.id,
                                text: DateFormat('dd.MM').format(task.dateForDaily!),
                                color: getColorByStatus(task.status),
                                flag: task.status == "in_progress",
                                title: task.title,
                                description: task.description,
                                category: task.category,
                                difficulty: task.difficulty,
                                answerType: task.answerType
                            );
                          }).toList();
                          return TaskPathWidget(
                            nodes: nodes
                          );
                        }
                      }
                    ),

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
                            slideBackgroundColor: ColorConstants.lightColor,
                            indicatorColor: ColorConstants.darkColor,
                            slides: [
                              ...snapshot.data!.map((path) => CardItem(
                                routeName: AppRouteConstants.pathRoute,
                                textColor: path.isImage ? ColorConstants.whiteColor : ColorConstants.blackColor,
                                text: path.title,
                                imageUrl: path.isImage ? path.backgroundValue : null,
                                backgroundColor: path.isColor || path.isDefault ? HexColor.fromHex(path.backgroundValue) : null,
                                // backgroundDarkening: 0.2,
                              )),
                              // CardItem(routeName: AppRouteConstants.pathRoute, imageUrl: 'https://picsum.photos/500/300?random=1', text: "Zdjęcie 1"),
                              // CardItem(routeName: AppRouteConstants.pathRoute, imageUrl: 'https://picsum.photos/500/300?random=2', text: "Zdjęcie 2"),
                              // CardItem(routeName: AppRouteConstants.pathRoute, backgroundColor: ColorConstants.whiteColor, textColor: ColorConstants.blackColor, text: "Kolor niebieski", backgroundDarkening: 0.5,),
                              // CardItem(routeName: AppRouteConstants.pathRoute, backgroundColor: ColorConstants.whiteColor, textColor: ColorConstants.blackColor, text: "Kolor czerwony", backgroundDarkening: 0,),
                            ],
                          );
                        }
                      }),
                      FutureBuilder(
                        future: PathService.getPopularPaths(),
                        builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return ExpandableCardGrid(
                            title: "polecamy",
                            initialCards: [
                              ...snapshot.data!.map((path) => CardItem(
                                routeName: AppRouteConstants.pathRoute,
                                textColor: path.isImage ? ColorConstants.whiteColor : ColorConstants.blackColor,
                                text: path.title,
                                imageUrl: path.isImage ? path.backgroundValue : null,
                                backgroundColor: path.isColor || path.isDefault ? HexColor.fromHex(path.backgroundValue) : null,
                                // backgroundDarkening: 0.2,
                              )),
                            ]
                          );
                        }
                      }
                    )
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