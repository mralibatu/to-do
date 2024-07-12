import 'package:flutter/material.dart';
import 'package:to_do/models/Task.dart';
import 'package:animate_icons/animate_icons.dart';

bool isDarkMode = false;

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final AnimateIconController iconController = AnimateIconController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: !isDarkMode ? Colors.blue : Colors.grey[800],
          shape: BoxShape.circle
        ),
        child: AnimateIcons(
          startIcon: Icons.dark_mode,
          endIcon: Icons.sunny,
          size: 30.0,
          controller: iconController,
          // add this tooltip for the start icon
          startTooltip: 'Icons.add_circle',
          // add this tooltip for the end icon
          endTooltip: 'Icons.add_circle_outline',
          onStartIconPress: () {
            setState(() {
              isDarkMode = true;
            });
            return true;
          },
          onEndIconPress: () {
            setState(() {
              isDarkMode = false;
            });
            return true;
          },
          duration: Duration(milliseconds: 200),
          startIconColor: Colors.black,
          endIconColor: Colors.white,
          clockwise: false,
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black12 : Colors.white,
      body: SafeArea(
        child: monthCalendar(),
      ),
    );
  }
}

Widget monthCalendar() {
  List<Widget> days = [];
  List<Widget> days2 = [];
  List<Widget> days3 = [];
  List<Widget> days4 = [];
  List<Widget> days5 = [];
  DateTime now = DateTime.now();
  now = DateTime(now.year, now.month - 1, 1);
  DateTime preMonth = DateTime(now.year, now.month - 1);
  int daysInPreMonth = DateTime(preMonth.year, preMonth.month + 1, 0).day;
  int currentDay = 0;

  for (int i = getWeekDay(); i > 1; i--) {
    days.add(Column(
      children: [
        Text("${daysInPreMonth - i + 2}",
            style: TextStyle(fontSize: 25, color: Colors.grey)),
      ],
    ));
  }
  for (int i = getWeekDay(); i <= 7; i++) {
    days.add(CalendarDay(currentDay: i - getWeekDay() + 1, now: DateTime(now.year, now.month, i - 5)));
    // days.add(Column(
    //   children: [
    //     Text("0${i - getWeekDay() + 1}", style: TextStyle(fontSize: 25)),
    //     Text(
    //         "${Task.getTaskCountByDate(
    //             DateTime(now.year, now.month + 1, i - 5))}"),
    //   ],
    // ));
    if (i == 7) {
      currentDay = i - getWeekDay() + 1;
    }
  }

  for (int i = 1; i <= 7; i++) {
    currentDay++;
    days2.add(CalendarDay(currentDay: currentDay, now: now));
  }
  for (int i = 0; i < 7; i++) {
    currentDay++;
    days3.add(CalendarDay(currentDay: currentDay, now: now));
  }
  for (int i = 0; i < 7; i++) {
    currentDay++;
    days4.add(CalendarDay(currentDay: currentDay, now: now));
  }
  for (int i = 0; i < 7; i++) {
    currentDay++;
    if (currentDay > daysInPreMonth) {
      break;
    }
    days5.add(CalendarDay(currentDay: currentDay, now: now));
  }

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CalendarHeader(char: "P"),
              CalendarHeader(char: "S"),
              CalendarHeader(char: "Ç"),
              CalendarHeader(char: "P"),
              CalendarHeader(char: "C"),
              CalendarHeader(char: "C"),
              CalendarHeader(char: "P"),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Divider(),
      SizedBox(
        height: 5,
      ),
      WeekRow(days: days),
      WeekRow(days: days2),
      WeekRow(days: days3),
      WeekRow(days: days4),
      WeekRow(days: days5),
    ],
  );
}

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
    required this.char,
  });

  final String char;

  @override
  Widget build(BuildContext context) {
    return Text(
      char,
      style: TextStyle(fontSize: 15, color: isDarkMode ? Colors.white : Colors.black87),
    );
  }
}

class WeekRow extends StatelessWidget {
  const WeekRow({
    super.key,
    required this.days,
  });

  final List<Widget> days;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          return Align(
            alignment: Alignment.topCenter,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 15, 0),
                  child: days[index],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CalendarDay extends StatelessWidget {
  const CalendarDay({
    super.key,
    required this.currentDay,
    required this.now,
  });

  final int currentDay;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    List<Task> currentTasks = Task.getByDate(DateTime(now.year, now.month + 1, currentDay));
    return InkWell(
      onTap: () {
        currentTasks.length == 0 ? null :
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: !isDarkMode ? Colors.white : Colors.grey[800],
                title: Text("Tasks",
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),),
                content: Container(
                  color: !isDarkMode ? Colors.white : Colors.grey[800] ,
                  height: currentTasks.length == 1 ? 100 : currentTasks.length == 2 ? 220 : 300,
                  width: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: currentTasks.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          children: [
                            Text("${currentTasks[index].title}\n\n${currentTasks[index].description}",
                            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),),
                            index < currentTasks.length - 1 ? Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Divider(),
                            ) : SizedBox(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            );
          },
        );
      },
      highlightColor: Colors.blue,
      splashColor: Colors.lightBlueAccent,
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        constraints: BoxConstraints.loose(Size.fromHeight(60)),
        child: Column(
          children: currentDay < 10
              ? [
            Text("0${currentDay}", style: TextStyle(fontSize: 25,color: isDarkMode ? Colors.white : Colors.black)),
            Text(
                "${Task.getTaskCountByDate(
                    DateTime(now.year, now.month + 1, currentDay))}",style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),),
          ]
              : [
            Text("${currentDay}", style: TextStyle(fontSize: 25,color: isDarkMode ? Colors.white : Colors.black)),
            Text(
                "${Task.getTaskCountByDate(
                    DateTime(now.year, now.month + 1, currentDay))}",style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }
}

int getWeekDay() {
  DateTime now = DateTime.now();
  DateTime firstDayOfMonth = DateTime(now.year, now.month - 1, 1);
  return firstDayOfMonth.weekday;
}
