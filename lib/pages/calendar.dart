import 'package:flutter/material.dart';
import 'package:to_do/pages/list_task.dart';
import 'package:to_do/pages/create_task.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: monthCalendar(),
      ),
    );
  }
}

Widget monthCalendar() {
  List<Widget> days = [];
  DateTime now = DateTime.now();
  now = DateTime(now.year, now.month - 1, 1);
  DateTime preMonth = DateTime(now.year, now.month - 1);
  int daysInPreMonth = DateTime(preMonth.year, preMonth.month + 1, 0).day;

  for (int i = getWeekDay(); i > 1; i--) {
    days.add(Text("${daysInPreMonth - i + 2}", style: TextStyle(fontSize: 25)));
  }
  // for (int i = getWeekDay(); i <= 7; i++) {
  //   days.add(value)
  // }

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "P",
                style: TextStyle(fontSize: 15),
              ),
              Text(
                "S",
                style: TextStyle(fontSize: 15),
              ),
              Text(
                "Ç",
                style: TextStyle(fontSize: 15),
              ),
              Text(
                "P",
                style: TextStyle(fontSize: 15),
              ),
              Text(
                "C",
                style: TextStyle(fontSize: 15),
              ),
              Text(
                "C",
                style: TextStyle(fontSize: 15),
              ),
              Text(
                "P",
                style: TextStyle(fontSize: 15),
              ),
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
      Expanded(
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
      )
    ],
  );
}

int getWeekDay() {
  DateTime now = DateTime.now();
  DateTime firstDayOfMonth = DateTime(now.year, now.month - 1, 1);
  return firstDayOfMonth.weekday;
}
