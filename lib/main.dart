import 'package:flutter/material.dart';
import 'package:to_do/pages/edit_task.dart';
import 'package:to_do/pages/list_task.dart';
import 'package:to_do/pages/create_task.dart';
import 'package:to_do/pages/calendar.dart';
import 'package:to_do/models/Task.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/calendar', //This page will be there soon
    routes: {
       '/': (context) => ListTask(),
      '/create-task':(context) => CreateTask(),
      '/edit-task': (context) {
        final Task taskToEdit = ModalRoute.of(context)!.settings.arguments as Task;
        return EditTask(taskToEdit: taskToEdit);
      },
      '/calendar':(context) => Calendar(),
    },
  ));
}