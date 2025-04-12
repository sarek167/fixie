import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/core/services/path_service.dart';
import 'package:frontend/core/services/task_service.dart';
import 'package:frontend/features/authentication/data/user_model.dart';
import 'package:frontend/features/authentication/logic/user_storage.dart';
import 'package:frontend/features/tasks/presentation/progress_bar.dart';
import 'package:frontend/features/tasks/presentation/task_path.dart';
import 'package:frontend/features/tasks/logic/get_node_color_by_status.dart';
import 'package:frontend/widgets/menu_bar.dart';

class PathScreen extends StatefulWidget {
  const PathScreen({super.key});

  @override
  State<PathScreen> createState() => _PathScreenState();

}

class _PathScreenState extends State<PathScreen> {
  bool isPathAdded = false;
  bool _initialized = false;

  void togglePath(String pathTitle) async {
    final result = await PathService.toggleUserPath(pathTitle);
    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${failure.message}")),
      ),
      (_) => setState(() {
        isPathAdded = !isPathAdded;
      })
    );
  }

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
          if (!_initialized) {
            isPathAdded = path.isSaved;
            _initialized = true;
          }
          print("Snapshot data: ${snapshot.data}");
          final List<TaskNode> nodes = path.tasks.asMap().entries.map((entry) {
            final index = entry.key;
            final task = entry.value;
            return TaskNode(
              id: task.id,
              text: "${index + 1}",
              color: getColorByStatus(task.status),
              flag: task.status == "in_progress",
              title: task.title,
              description: task.description,
              category: task.category,
              difficulty: task.difficulty,
              answerType: task.answerType
            );
          }).toList();
          nodes.add(TaskNode(id: -1, text: "", color: Colors.transparent, isTrophy: true, answerType: "checkbox"));
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
                        child: Text(
                            "Error while loading streak: ${snapshot.error}"))
                );
              } else {
                final streak = snapshot.data!.streak;
                return Scaffold(
                  backgroundColor: ColorConstants.backgroundColor,
                  appBar: CustomAppBar(streak: streak,),
                  body: Center(
                    child: SingleChildScrollView(
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20),
                              child: Text(
                                  path.description,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorConstants.whiteColor,
                                    fontSize: FontConstants.standardFontSize,
                                  )
                              )
                          ),
                          IconButton(
                            icon: Icon(
                              isPathAdded ? Icons.favorite_rounded : Icons
                                  .favorite_border_rounded,
                              size: 30,
                              color: ColorConstants.whiteColor,
                            ),
                            onPressed: () => togglePath(path.title),
                            tooltip: isPathAdded
                                ? 'Usuń ścieżkę z moich'
                                : 'Dodaj ścieżkę do moich',
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
    );
  }
}