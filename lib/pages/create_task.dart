import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:to_do/models/Task.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  CreateTaskState createState() => CreateTaskState();
}

/// State for CreateTask
class CreateTaskState extends State<CreateTask> {
  DateRangePickerView _dateRangePickerView = DateRangePickerView.month;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  Priority selectedPriority = Priority.basic;
  DateTime? startDate;
  DateTime? endDate;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      startDate = args.value.startDate;
      endDate = args.value.endDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff13678A),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: const Text('Create Task'),
      ),
      body: Container(
        color: Color(0xff45C4B0),
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Select a date",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SfDateRangePicker(
                minDate: DateTime.now(),
                onSelectionChanged: _onSelectionChanged,
                view: _dateRangePickerView,
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedDate: DateTime.now(),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Task Title',
                hintText: 'Meet with Alex',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: descController,
              decoration: InputDecoration(
                labelText: 'Task Description',
                hintText: 'Send message to Carla for notify her',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              readOnly: true,
              maxLines: null,
              controller: descController,
              decoration: InputDecoration(
                labelText: 'Task Description',
                hintText: 'Send message to Carla for notify her',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            Text("Select a priority"),
            SizedBox(height: 15),
            DropdownButton(
                value: selectedPriority,
                items: [
                  DropdownMenuItem(
                    value: Priority.basic,
                    child: Text("Basic", style: TextStyle(color: Colors.grey[600]),),
                  ),
                  DropdownMenuItem(
                    value: Priority.urgent,
                    child: Text("Urgent", style: TextStyle(color: Colors.red[400]),),
                  ),
                  DropdownMenuItem(
                    value: Priority.important,
                    child: Text("Important", style: TextStyle(color: Colors.orange[600]),),
                  ),
                  DropdownMenuItem(
                    value: Priority.urgentImportant,
                    child: Text("Urgent & Important", style: TextStyle(color: Colors.red[900]),),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedPriority = value as Priority;
                  });
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff13678A),
        tooltip: 'Increment',
        onPressed: (){
          if(titleController.text.isEmpty || descController.text.isEmpty || startDate == null || endDate == null)
            return;
          Navigator.pop(context, new Task(
            title: titleController.text,
            description: descController.text,
            startDate: startDate,
            endDate: endDate,
            priority: selectedPriority,
            isCompleted: false
          ));
        },
        child: const Icon(Icons.save, color: Colors.white, size: 28),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CreateTask(),
  ));
}
