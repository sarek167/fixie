import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/tasks/presentation/task_path.dart';
import 'package:frontend/widgets/button.dart';
import 'package:frontend/widgets/menu_bar.dart';
import 'package:frontend/widgets/tag.dart';

class SingleTaskScreen extends StatefulWidget {
  final TaskNode task;

  const SingleTaskScreen({super.key, required this.task});

  @override
  State<SingleTaskScreen> createState() => _SingleTaskScreenState();
}

class _SingleTaskScreenState extends State<SingleTaskScreen> {
  bool checkboxValue = false;
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

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
              if (task.answerType == "text")
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
                )
              else
                Transform.scale(
                  scale: 3,
                  child: Checkbox(
                    value: checkboxValue,
                    onChanged: (bool? newValue) {
                      setState(() {
                        checkboxValue = newValue ?? false;
                      });
                    },
                    activeColor: ColorConstants.darkColor, // np. niebieski/zielony
                    checkColor: ColorConstants.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: BorderSide(
                      color: ColorConstants.whiteColor,
                      width: 2,
                    ),
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