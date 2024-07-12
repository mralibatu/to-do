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
    days.add(Text("${daysInPreMonth - i + 2}", style: TextStyle(fontSize: 25)));
  }
  for (int i = getWeekDay(); i <= 7; i++) {
    days.add(Text("0${i - getWeekDay() + 1}", style: TextStyle(fontSize: 25)));
    if (i == 7) {
      currentDay = i - getWeekDay() + 1;
    }
  }

  for (int i = 1; i <= 7; i++) {
    currentDay++;
    if (currentDay< 10) {
      days2.add(
          Text("0${currentDay}", style: TextStyle(fontSize: 25)));
    } else {
      days2.add(Text("${currentDay}", style: TextStyle(fontSize: 25)));
    }
  }
  for (int i = 0; i < 7; i++) {
    currentDay++;
    if (currentDay < 10) {
      days3.add(
          Text("0${currentDay}", style: TextStyle(fontSize: 25)));
    } else {
      days3.add(
          Text("${currentDay}", style: TextStyle(fontSize: 25)));
    }
  }
  for (int i = 0; i < 7; i++) {
    currentDay++;
    days4.add(Text("${currentDay}", style: TextStyle(fontSize: 25)));
  }
  for (int i = 0; i < 7; i++) {
    currentDay++;
    days5.add(Text("${currentDay}", style: TextStyle(fontSize: 25)));
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
                    child: days2[index],
                  ),
                ],
              ),
            );
          },
        ),
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
                    child: days3[index],
                  ),
                ],
              ),
            );
          },
        ),
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
                    child: days4[index],
                  ),
                ],
              ),
            );
          },
        ),
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
                    child: days5[index],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
}

int getWeekDay() {
  DateTime now = DateTime.now();
  DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
  return firstDayOfMonth.weekday;
}
