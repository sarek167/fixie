import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/core/services/path_service.dart';
import 'package:frontend/features/tasks/presentation/progress_bar.dart';
import 'package:frontend/features/tasks/presentation/task_path.dart';
import 'package:frontend/features/tasks/logic/get_node_color_by_status.dart';
import 'package:frontend/widgets/menu_bar.dart';

class PathScreen extends StatelessWidget {
  PathScreen({super.key});
  // final List<TaskNode> nodes = [
  //   TaskNode(text: "1", color: ColorConstants.lightBackgroundColor),
  //   TaskNode(text: "2", color: ColorConstants.lightBackgroundColor),
  //   TaskNode(text: "3", color: ColorConstants.darkColor, flag: true),
  //   TaskNode(text: "4", color: ColorConstants.darkColor),
  //   TaskNode(text: "5", color: ColorConstants.darkColor),
  //   TaskNode(text: "", color: Colors.transparent, isTrophy: true)
  // ];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final title = args['title'];
    print(title);

    return FutureBuilder(
      future: PathService.getPathByTitle(title),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
          body: Center(child: Text("Error: ${snapshot.error}"))
          );
        } else {
          final path = snapshot.data!;
          print("Snapshot data: ${snapshot.data}");
          final List<TaskNode> nodes = path.tasks.asMap().entries.map((entry) {
            final index = entry.key;
            final task = entry.value;
            print("TASKI");
            print(path.tasks);
            return TaskNode(
              text: "${index + 1}",
              color: getColorByStatus(task.status),
              flag: task.status == "in_progress",
              title: task.title,
              description: task.description,
              category: task.category,
              difficulty: task.difficulty
            );
          }).toList();
          nodes.add(TaskNode(text: "", color: Colors.transparent, isTrophy: true));
          return Scaffold(
            backgroundColor: ColorConstants.backgroundColor,
            appBar: CustomAppBar(),
            body: Center(
              child:SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      path.title.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorConstants.whiteColor,
                        fontSize: FontConstants.largeHeaderFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        path.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorConstants.whiteColor,
                          fontSize: FontConstants.standardFontSize,
                        )
                      )
                    ),
                    const SizedBox(height: 20),
                    ProgressBar(nodes: nodes),
                    TaskPathWidget(
                      nodes: nodes,
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