import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/core/services/task_service.dart';
import 'package:frontend/features/authentication/data/user_model.dart';
import 'package:frontend/features/authentication/logic/user_storage.dart';
import 'package:frontend/features/tasks/logic/navigate_to_selected_task.dart';
import 'package:frontend/widgets/menu_bar.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();

}

class _CalendarScreenState extends State<CalendarScreen> {
  Set<DateTime> completedDates = {};
  DateTime? _selectedDay;

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
                      "KALENDARZ\nZADAŃ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorConstants.whiteColor,
                        fontSize: FontConstants.largeHeaderFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: FutureBuilder<List<Map<String,
                        dynamic>>>(
                        future: TaskService.getDailyTasksStatus(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator()
                            );
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return Center(child: Text("Error while loading statuses"));
                          } else {
                            completedDates = snapshot.data!
                                .where((item) =>
                            item['status'] == 'completed')
                                .map((item) =>
                                DateTime.parse(item['date']))
                                .toSet();
                            return TableCalendar(
                              locale: 'pl_PL',
                              firstDay: DateTime.utc(2025, 03, 1),
                              lastDay: DateTime.utc(2026, 03, 1),
                              focusedDay: DateTime.now(),
                              calendarFormat: CalendarFormat
                                  .month,
                              startingDayOfWeek: StartingDayOfWeek
                                  .monday,
                              onDaySelected: (selectedDay, focusedDay) async {
                                navigateToSelectedTask(context, selectedDay);
                              },
                              headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                titleTextStyle: TextStyle(
                                  color: ColorConstants.whiteColor,
                                  fontSize: FontConstants.headerFontSize,
                                  fontWeight: FontWeight.bold
                                ),
                                leftChevronIcon: Icon(
                                  Icons.chevron_left,
                                  color: ColorConstants.whiteColor
                                ),
                                rightChevronIcon: Icon(
                                  Icons.chevron_right,
                                  color: ColorConstants.whiteColor
                                ),
                                decoration: BoxDecoration(
                                  color: ColorConstants.darkColor,
                                  borderRadius: BorderRadius
                                    .only(
                                    topRight: Radius.circular(8),
                                    topLeft: Radius.circular(8)
                                  )
                                )
                              ),
                              daysOfWeekHeight: FontConstants.largeHeaderFontSize,
                              daysOfWeekStyle: DaysOfWeekStyle(
                                decoration: BoxDecoration(
                                  color: ColorConstants.lightColor,
                                ),
                                weekdayStyle: TextStyle(
                                  color: ColorConstants.whiteColor,
                                  fontSize: FontConstants.standardFontSize,
                                  fontWeight: FontWeight.bold
                                ),
                                weekendStyle: TextStyle(
                                  color: ColorConstants.whiteColor,
                                  fontSize: FontConstants.standardFontSize,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              calendarBuilders: CalendarBuilders(
                                defaultBuilder: (context, day, _) {
                                  final isCompleted = completedDates.any((d) =>
                                    d.year == day.year &&
                                    d.month == day.month &&
                                    d.day == day.day
                                  );
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: isCompleted
                                          ? ColorConstants.lightBackgroundColor
                                          : ColorConstants.veryLightColor,
                                      // borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${day.day}',
                                        style: TextStyle(
                                          color: ColorConstants.whiteColor,
                                          fontSize: FontConstants.standardFontSize,
                                          fontWeight: FontWeight.bold
                                        )
                                      )
                                    ),
                                  );
                                },
                                todayBuilder: (context, day, _) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: ColorConstants.lightColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${day.day}',
                                        style: TextStyle(
                                          color: ColorConstants.whiteColor,
                                          fontSize: FontConstants.headerFontSize,
                                          fontWeight: FontWeight.bold
                                        )
                                      )
                                    )
                                  );
                                },
                                outsideBuilder: (context, day,
                                    _) {
                                  return Center(
                                    child: Text(
                                      '${day.day}',
                                      style: TextStyle(
                                        color: ColorConstants.whiteColor
                                      ),
                                    )
                                  );
                                }
                              )
                            );
                          }
                        }
                      ),
                    )
                  ]
                )
              )
            )
          );
        }
      }
    );
  }
}
