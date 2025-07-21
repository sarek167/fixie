import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/tasks/logic/navigate_to_selected_task.dart';
import 'package:frontend/widgets/button.dart';
import 'package:intl/intl.dart';

class DayTaskCard extends StatelessWidget {
  const DayTaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('dd.MM').format(now);

    return Container(
        width: 300,
        height: 150,
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
            child: SizedBox(
                width: 300,
                height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: FontConstants.largeHeaderFontSize,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 10,),
                  CustomButton(text: "ZACZYNAMY!", onPressed: () async {navigateToSelectedTask(context, now);}, backgroundColor: ColorConstants.light,)
                ],
              )
            )
        )
    );
  }
}