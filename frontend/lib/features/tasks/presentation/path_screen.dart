import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/tasks/presentation/task_path.dart';
import 'package:frontend/widgets/menu_bar.dart';

class PathScreen extends StatelessWidget {
  const PathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: CustomAppBar(),
      body: Center(
        child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "NAZWA\nŚCIEŻKI",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorConstants.whiteColor,
                  fontSize: FontConstants.largeHeaderFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TaskPathWidget(
                nodes: [
                  TaskNode(text: "1", color: ColorConstants.lightBackgroundColor),
                  TaskNode(text: "2", color: ColorConstants.lightBackgroundColor),
                  TaskNode(text: "3", color: ColorConstants.darkColor, flag: true),
                  TaskNode(text: "4", color: ColorConstants.darkColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}