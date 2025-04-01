import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/tasks/presentation/task_path.dart';
import 'package:frontend/widgets/button.dart';
import 'package:frontend/widgets/menu_bar.dart';
import 'package:frontend/widgets/tag.dart';

class SingleTaskScreen extends StatelessWidget {
  final TaskNode task;
  const SingleTaskScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: CustomAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                task.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorConstants.whiteColor,
                  fontSize: FontConstants.largeHeaderFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tag(text: task.category, tagColor: ColorConstants.lightColor,),
                  const SizedBox(width: 10),
                  Tag(text: "Trudność: ${task.difficulty}"),
                ],
              ),
              SizedBox(height: 20),
              Text(
                task.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ColorConstants.whiteColor,
                    fontSize: FontConstants.standardFontSize
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorConstants.whiteColor,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: TextField(
                    maxLines: null,
                    expands: true,
                    style: TextStyle(
                      color: ColorConstants.blackColor,
                      fontSize: FontConstants.standardFontSize
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Zapisz swoją odpowiedź...',
                      hintStyle: TextStyle(
                        color: ColorConstants.blackColor
                      )
                    )
                  )
                )
              ),
              SizedBox(height: 20),
              CustomButton(text: "Zatwierdź", onPressed: () => {}) // TODO: add onPressed
            ],
          )
        )

      ),
    );
  }
}