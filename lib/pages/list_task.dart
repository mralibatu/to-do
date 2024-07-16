import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:to_do/models/Task.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:segmented_button_slide/segmented_button_slide.dart';
import 'package:animate_icons/animate_icons.dart';

List<Task> list_tasks = List.from(Task.tasks);

class ListTask extends StatefulWidget {
  const ListTask({super.key});

  @override
  State<ListTask> createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final AnimateIconController iconController = AnimateIconController();
  DateTime? selectedDate;
  String searchBarTitle = "";
  int selectedOption = 0;
  bool isDateSliderShow = true;

  int _getDaysCount() {
    DateTime now = DateTime.now();
    DateTime lastDayofMonth = DateTime(now.year, now.month + 1, 0);
    return lastDayofMonth.day - now.day;
  }

  void search(String query) {
    if (query.isEmpty) {
      setState(() {
        if (selectedDate != null) {
          list_tasks = Task.getByDate(selectedDate!);
        } else {
          list_tasks = Task.tasks;
        }
      });
    } else {
      if (selectedDate != null) {
        setState(() {
          list_tasks = Task.getByDate(selectedDate!)
              .where(
                  (e) => e.title!.toLowerCase().contains(query.toLowerCase()))
              .toList();
        });
      } else {
        setState(() {
          list_tasks = Task.tasks
              .where(
                  (e) => e.title!.toLowerCase().contains(query.toLowerCase()))
              .toList();
        });
      }
    }
  }

  void showAll() {
    setState(() {
      selectedDate = null;
      list_tasks = new List.from(Task.tasks);
    });
  }

  void checkAll(int i) {
    for (Task task in Task.tasks) {
      task.isCompleted = i == 1 ? true : false;
    }
    if (i == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All Task Done!')),
      );
    }
  }

  void queryListener() {
    search(searchController.text);
  }

  @override
  void initState() {
    //Task.createTasks(100);
    loadTasks();
    searchController.addListener(queryListener);
    super.initState();
  }

  Future<void> loadTasks() async {
    // Assuming this widget has an asynchronous context (e.g., inside an async function)
    List<Task> tasks = await Task.get();

    setState(() {
      Task.tasks = tasks;
      list_tasks = Task.sortByPriority(); // Assuming list_tasks is also a List<Task> in your State
    });
  }

  @override
  void dispose() {
    searchController.removeListener(queryListener);
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //endDrawer: NavBar(),
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/calendar");
                            },
                            icon: Icon(Icons.calendar_month)),
                        // IconButton(
                        //     onPressed: () {
                        //       Task.save();
                        //     },
                        //     icon: Icon(Icons.save)),
                        // IconButton(
                        //     onPressed: () {
                        //       setState(() {
                        //         Task.get();
                        //         list_tasks = Task.tasks;
                        //       });
                        //     },
                        //     icon: Icon(Icons.get_app)),

                        // //Check All Done
                        // AnimateIcons(
                        //   startIcon: Icons.check_circle,
                        //   endIcon: Icons.check_circle_outline,
                        //   size: 30.0,
                        //   controller: iconController,
                        //   // add this tooltip for the start icon
                        //   startTooltip: 'Icons.add_circle',
                        //   // add this tooltip for the end icon
                        //   endTooltip: 'Icons.add_circle_outline',
                        //   onStartIconPress: () {
                        //     setState(() {
                        //       checkAll(1);
                        //     });
                        //     return true;
                        //   },
                        //   onEndIconPress: () {
                        //     setState(() {
                        //       checkAll(0);
                        //     });
                        //     return true;
                        //   },
                        //   duration: Duration(milliseconds: 200),
                        //   startIconColor: Colors.black,
                        //   endIconColor: Colors.black,
                        //   clockwise: false,
                        // ),
                      ],
                    ),
                  ),
                  Text(
                    "To-Do it!",
                    style: TextStyle(fontSize: 24),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: AnimateIcons(
                      startIcon: Icons.select_all,
                      endIcon: Icons.date_range,
                      size: 30.0,
                      controller: iconController,
                      // add this tooltip for the start icon
                      startTooltip: 'Icons.add_circle',
                      // add this tooltip for the end icon
                      endTooltip: 'Icons.add_circle_outline',
                      onStartIconPress: () {
                        setState(() {
                          isDateSliderShow = false;
                          showAll();
                        });
                        return true;
                      },
                      onEndIconPress: () {
                        setState(() {
                          isDateSliderShow = true;
                          selectedDate = DateTime.now();
                        });
                        return true;
                      },
                      duration: Duration(milliseconds: 200),
                      startIconColor: Colors.black,
                      endIconColor: Colors.black,
                      clockwise: false,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: 400,
                height: 50,
                child: SearchBar(
                  autoFocus: false,
                  controller: searchController,
                  hintText: "Search",
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Icon(Icons.search),
                  ),
                  onSubmitted: (String value) {},
                ),
              ),
            ),
            !isDateSliderShow
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                    child: Column(
                      children: [
                        DatePicker(
                          height: 120,
                          DateTime.now(),
                          selectionColor: Colors.black12,
                          daysCount: _getDaysCount(),
                          selectedTextColor: Colors.white,
                          onDateChange: (date) {
                            setState(() {
                              selectedDate = date;
                              list_tasks = new List.from(Task.getByDate(date));
                            });
                          },
                        ),
                      ],
                    ),
                  ),
            SizedBox(
              height: 80,
              width: 500,
              child: isDateSliderShow
                  ? SegmentedButtonSlide(
                      entries: [
                        SegmentedButtonSlideEntry(
                            icon: Icons.sort, label: "Priority"),
                        SegmentedButtonSlideEntry(
                            icon: Icons.sort, label: "Done"),
                      ],
                      selectedEntry: selectedOption,
                      onChange: (selected) {
                        setState(() {
                          selectedOption = selected;
                          List<Task>? par =
                              selectedDate != null ? list_tasks : null;
                          switch (selectedOption) {
                            case 0:
                              list_tasks = new List.from(
                                  Task.sortByPriority(parTasks: par));
                            case 1:
                              list_tasks = new List.from(
                                  Task.sortByCompleted(parTasks: par));
                          }
                        });
                      },
                      colors: SegmentedButtonSlideColors(
                          barColor: Colors.grey.withOpacity(0.2),
                          backgroundSelectedColor: Color(0xff015958),
                          foregroundSelectedColor: Colors.white,
                          foregroundUnselectedColor: Colors.black,
                          hoverColor: Colors.grey.withOpacity(0.8)),
                      slideShadow: [
                        BoxShadow(
                            color: Colors.white54,
                            blurRadius: 5,
                            spreadRadius: 1)
                      ],
                      margin: const EdgeInsets.all(16),
                      height: 40,
                    )
                  : SegmentedButtonSlide(
                      entries: [
                        SegmentedButtonSlideEntry(
                            icon: Icons.sort, label: "Priority"),
                        SegmentedButtonSlideEntry(
                            icon: Icons.sort, label: "Date"),
                        SegmentedButtonSlideEntry(
                            icon: Icons.sort, label: "Done"),
                      ],
                      selectedEntry: selectedOption,
                      onChange: (selected) {
                        setState(() {
                          selectedOption = selected;
                          List<Task>? par =
                              selectedDate != null ? list_tasks : null;
                          switch (selectedOption) {
                            case 0:
                              list_tasks = new List.from(
                                  Task.sortByPriority(parTasks: par));
                            case 1:
                              list_tasks =
                                  new List.from(Task.sortByDate(parTasks: par));
                            case 2:
                              list_tasks = new List.from(
                                  Task.sortByCompleted(parTasks: par));
                          }
                        });
                      },
                      colors: SegmentedButtonSlideColors(
                          barColor: Colors.grey.withOpacity(0.2),
                          backgroundSelectedColor: Color(0xff015958),
                          foregroundSelectedColor: Colors.white,
                          foregroundUnselectedColor: Colors.black,
                          hoverColor: Colors.grey.withOpacity(0.8)),
                      slideShadow: [
                        BoxShadow(
                            color: Colors.white54,
                            blurRadius: 5,
                            spreadRadius: 1)
                      ],
                      margin: const EdgeInsets.all(16),
                      height: 40,
                    ),
            ),
            list_tasks.length == 0
                ? Text("There is no task!")
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(
                        itemCount: list_tasks.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            //Slide operations
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.blue,
                              ),
                              //Completed slider background
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 20.0),
                              child: Icon(Icons.edit_calendar,
                                  color: Colors.white),
                            ),
                            secondaryBackground: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.red,
                              ),
                              //Delete slider background
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                Navigator.pushNamed(context, "/edit-task",
                                    arguments: list_tasks[index]);
                              } else if (direction ==
                                  DismissDirection.endToStart) {
                                setState(() {
                                  Task.tasks.removeAt(index);
                                  list_tasks.removeAt(index);
                                  if (isDateSliderShow &&
                                      selectedDate != null) {
                                    switch (selectedOption) {
                                      case 0:
                                        list_tasks = new List.from(
                                            Task.sortByPriority(parTasks: list_tasks));
                                      case 1:
                                        list_tasks =
                                        new List.from(Task.sortByDate(parTasks: list_tasks));
                                      case 2:
                                        list_tasks = new List.from(
                                            Task.sortByCompleted(parTasks: list_tasks));
                                    }
                                    list_tasks = Task.getByDate(selectedDate!);
                                  } else {
                                    switch (selectedOption) {
                                      case 0:
                                        list_tasks = new List.from(
                                            Task.sortByPriority(parTasks: list_tasks));
                                      case 1:
                                        list_tasks = new List.from(
                                            Task.sortByCompleted(parTasks: list_tasks));
                                    }
                                  }
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Task silindi')),
                                );
                              }
                            },

                            child: Card(
                              child: ListTile(
                                leading: Container(
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        list_tasks[index].isCompleted =
                                            !list_tasks[index].isCompleted!;
                                      });
                                    },
                                    icon: Icon(
                                      list_tasks[index].isCompleted!
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color: Color(0xff026873),
                                    ),
                                  ),
                                ),
                                title: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          list_tasks[index].title!,
                                          style: TextStyle(
                                              color: Color(0xff024059)),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              showAdaptiveDialog(
                                                  context: context,
                                                  builder:
                                                      (context) => AlertDialog(
                                                            title: Row(
                                                              children: [
                                                                Text(
                                                                    "${list_tasks[index].title}"),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Icon(
                                                                    Icons
                                                                        .crisis_alert,
                                                                    color: list_tasks[index].priority ==
                                                                            Priority
                                                                                .basic
                                                                        ? Colors
                                                                            .grey
                                                                        : list_tasks[index].priority ==
                                                                                Priority.urgent
                                                                            ? Colors.orange[300]
                                                                            : list_tasks[index].priority == Priority.important
                                                                                ? Colors.red[300]
                                                                                : Colors.red),
                                                              ],
                                                            ),
                                                            content: Text(
                                                                "${list_tasks[index].description}"),
                                                          ));
                                            },
                                            icon: Icon(Icons.crisis_alert,
                                                color: list_tasks[index]
                                                            .priority ==
                                                        Priority.basic
                                                    ? Colors.grey
                                                    : list_tasks[index]
                                                                .priority ==
                                                            Priority.urgent
                                                        ? Colors.orange[300]
                                                        : list_tasks[index]
                                                                    .priority ==
                                                                Priority
                                                                    .important
                                                            ? Colors.red[300]
                                                            : Colors.red)),
                                      ],
                                    ),
                                    isDateSliderShow
                                        ? SizedBox()
                                        : Align(
                                            alignment: Alignment.bottomRight,
                                            child: isDateSliderShow
                                                ? Text("")
                                                : Text(
                                                    "${list_tasks[index].startDate?.day} / ${list_tasks[index].startDate?.month}",
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff13678A),
        tooltip: 'Increment',
        onPressed: () async {
          Task newTask =
              await Navigator.pushNamed(context, "/create-task") as Task;

          if (newTask != null) {
            setState(() {
              Task.tasks.add(newTask);
              list_tasks.add(newTask);
              Task.save();
            });
          }
        },
        child:
            const Icon(Icons.add_task_outlined, color: Colors.white, size: 28),
      ),
    );
  }
}
