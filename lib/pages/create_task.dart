import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:to_do/models/Task.dart';
import 'package:table_calendar/table_calendar.dart';

class CreateTask extends StatefulWidget {
  final int? id;
  final String? initialTitle;
  final String? initialDescription;
  final Priority? initialPriority;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const CreateTask({
    super.key,
    this.id,
    this.initialTitle,
    this.initialDescription,
    this.initialPriority,
    this.initialStartDate,
    this.initialEndDate,
  });

  @override
  CreateTaskState createState() => CreateTaskState();
}

/// State for CreateTask
class CreateTaskState extends State<CreateTask> {
  DateRangePickerView _dateRangePickerView = DateRangePickerView.month;
  DateTime? startDate;
  late TextEditingController titleController;
  late TextEditingController descController;
  late Priority selectedPriority;
  int? id;
  bool? isUpdate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle);
    descController = TextEditingController(text: widget.initialDescription);
    isUpdate = widget.initialPriority == null ? false : true;
    selectedPriority = widget.initialPriority ?? Priority.basic;
    startDate = widget.initialStartDate;
    id = widget.id;
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      startDate = args.value.startDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: const Text('Create Task'),
      ),
      body: Container(
        color: Colors.grey,
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
              child: TableCalendar(
                focusedDay: startDate ?? DateTime.now(),
                firstDay: DateTime.now(),
                lastDay: DateTime(DateTime.now().year + 1),
                selectedDayPredicate: (day) {
                  return isSameDay(startDate, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    startDate = selectedDay;
                    startDate = focusedDay; // update `_focusedDay` here as well
                  });
                },
              ),
              // SfDateRangePicker(
              //   initialSelectedRanges: [
              //     PickerDateRange(startDate, endDate)
              //   ],
              //   headerStyle: DateRangePickerHeaderStyle(
              //       backgroundColor: Colors.grey[300]),
              //   backgroundColor: Colors.grey[300],
              //   minDate: DateTime.now(),
              //   onSelectionChanged: _onSelectionChanged,
              //   view: _dateRangePickerView,
              //   selectionMode: DateRangePickerSelectionMode.range,
              //   monthCellStyle: DateRangePickerMonthCellStyle(
              //       blackoutDatesDecoration: BoxDecoration(color: Colors.blue)),
              // ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              color: Colors.grey[300],
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Task Title',
                      hintText: 'Meet with Alex',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    child: Container(
                      color: Colors.grey,
                    ),
                    height: 20,
                  ),
                  TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: descController,
                    decoration: InputDecoration(
                      labelText: 'Task Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    child: Container(
                      color: Colors.grey,
                    ),
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      // Show popup menu
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(50, 600, 30, 200),
                        items: [
                          PopupMenuItem<String>(
                            value: "basic",
                            child: Text(
                              "Basic",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: "urgent",
                            child: Text(
                              "Urgent",
                              style: TextStyle(color: Colors.red[400]),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: "important",
                            child: Text(
                              "Important",
                              style: TextStyle(color: Colors.orange[600]),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: "urgentImportant",
                            child: Text(
                              "Urgent & Important",
                              style: TextStyle(color: Colors.red[900]),
                            ),
                          ),
                        ],
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            selectedPriority = Priority.values.byName(value);
                          });
                        }
                      });
                    },
                    child: Text('Show Menu'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff13678A),
        tooltip: 'Increment',
        onPressed: () {
          if (titleController.text.isEmpty ||
              descController.text.isEmpty ||
              startDate == null){ print(titleController.text.isEmpty); return;};
          if (isUpdate!) {
            Task.tasks[id!].title = titleController.text;
            Task.tasks[id!].description = descController.text;
            Task.tasks[id!].startDate = startDate;
            Task.tasks[id!].priority = selectedPriority;
            Navigator.pop(context);
          }else {
            Navigator.pop(
                context,
                new Task(
                    id: Task.tasks.length,
                    title: titleController.text,
                    description: descController.text,
                    startDate: startDate,
                    priority: selectedPriority,
                    isCompleted: false));
          }
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
