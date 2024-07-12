import 'package:flutter/material.dart';
import 'package:to_do/pages/list_task.dart';
import 'package:to_do/pages/create_task.dart';
import 'package:to_do/models/Task.dart';

class EditTask extends StatefulWidget {
  final Task taskToEdit;

  const EditTask({super.key, required this.taskToEdit});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {

  late Task taskToEdit = ModalRoute.of(context)!.settings.arguments as Task;

  @override
  Widget build(BuildContext context) {
    return CreateTask(
      initialTitle: widget.taskToEdit.title,
      initialDescription: widget.taskToEdit.description,
      initialPriority: widget.taskToEdit.priority,
      initialStartDate: widget.taskToEdit.startDate,
      id: widget.taskToEdit.id,
    );
  }
}
