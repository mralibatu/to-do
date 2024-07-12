import 'package:flutter/material.dart';
import 'package:to_do/pages/list_task.dart';
import 'package:to_do/pages/create_task.dart';
import 'package:to_do/pages/calendar.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    //initialRoute: '/calendar',
    routes: {
       '/': (context) => ListTask(),
      '/create-task':(context) => CreateTask(),
      '/calendar':(context) => Calendar(),
    },
  ));
}