import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/tasks/logic/progress.dart';
import 'package:frontend/features/tasks/presentation/task_path.dart';

class ProgressBar extends StatelessWidget {
  final List<TaskNode> nodes;

  const ProgressBar({
    Key? key,
    required this.nodes
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 200,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: Progress().calculateProgress(nodes),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorConstants.semiLightColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "PROGRES",
          style: TextStyle(
            color: ColorConstants.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: FontConstants.headerFontSize,
          ),
        )
      ],
    );
  }
}
