import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:to_do/models/Task.dart';
import 'package:to_do/NavBar.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:segmented_button_slide/segmented_button_slide.dart';

List<Task> tasks = Task.getTasks();
List<Task> list_tasks = new List.from(Task.tasks);

class ListTask extends StatefulWidget {
  const ListTask({super.key});

  @override
  State<ListTask> createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  String searchBarTitle = "";
  int selectedOption = 0;

  int _getDaysCount() {
    DateTime now = DateTime.now();
    DateTime lastDayofMonth = DateTime(now.year, now.month + 1, 0);
    return lastDayofMonth.day - now.day;
  }

  void search(String query) {
    if (query.isEmpty) {
      setState(() {
        list_tasks = tasks;
      });
    } else {
      setState(() {
        list_tasks = tasks
            .where((e) => e.title!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void showAll() {
    list_tasks = new List.from(Task.tasks);
  }

  void checkAll() {
    for (Task task in Task.tasks) {
      task.isCompleted = true;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All Task Done!')),
    );
  }

  void queryListener() {
    search(searchController.text);
  }

  @override
  void initState() {
    Task.createTasks(120);
    searchController.addListener(queryListener);
    searchBarTitle = Task.getRandomTask().title!;
    super.initState();
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
      endDrawer: NavBar(),
      backgroundColor: Color(0xff45C4B0),
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
                    child: Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                checkAll();
                              });
                            },
                            icon: Icon(Icons.checklist_outlined)),
                        Text(
                          "Check All",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "To-Do it!",
                    style: TextStyle(
                        backgroundColor: Color(0xff45C4B0), fontSize: 24),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Builder(
                      builder: (context) => IconButton(
                        onPressed: () {
                          //Scaffold.of(context).openEndDrawer();
                          setState(() {
                            showAll();
                          });
                        },
                        icon: Icon(Icons.menu),
                      ),
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
                  controller: searchController,
                  hintText: "Search",
                  leading: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search),
                  ),
                  onSubmitted: (String value) {},
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  DatePicker(
                    height: 120,
                    DateTime.now(),
                    selectionColor: Color(0xff9AEBA3),
                    daysCount: _getDaysCount(),
                    selectedTextColor: Colors.white,
                    onDateChange: (date) {
                      // New date selected
                      setState(() {
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
              child: SegmentedButtonSlide(
                entries: const [
                  SegmentedButtonSlideEntry(icon: Icons.sort, label: "Priority"),
                  SegmentedButtonSlideEntry(icon: Icons.sort, label: "Date"),
                  SegmentedButtonSlideEntry(icon: Icons.sort, label: "Done"),
                ],
                selectedEntry: selectedOption,
                onChange: (selected) {
                  setState(() {
                    selectedOption = selected;
                    switch(selectedOption)
                    {
                      case 0:
                        list_tasks = new List.from(Task.sortByPriority());
                      case 1:
                        list_tasks = new List.from(Task.sortByDate());
                      case 2:
                        list_tasks = new List.from(Task.sortByCompleted());
                    }

                  });
                },
                colors: SegmentedButtonSlideColors(
                    barColor: Colors.grey.withOpacity(0.2),
                    backgroundSelectedColor: Color(0xff015958),
                    foregroundSelectedColor: Colors.white,
                    foregroundUnselectedColor: Colors.black,
                    hoverColor: Colors.grey.withOpacity(0.8)
                ),
                slideShadow: [
                  BoxShadow(
                      color: Colors.white54,
                      blurRadius: 5,
                      spreadRadius: 1
                  )
                ],
                margin: const EdgeInsets.all(16),
                height: 40,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  itemCount: list_tasks.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      //Slide operations
                      key: UniqueKey(),
                      direction: DismissDirection.horizontal,
                      background: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.blue,
                        ),
                        //Completed slider background
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20.0),
                        child: Icon(Icons.edit_calendar, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        //Delete slider background
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20.0),
                        color: Colors.red,
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          Navigator.pushNamed(context, "/create-task",
                              arguments: index);
                        } else if (direction == DismissDirection.endToStart) {
                          setState(() {
                            if (tasks[index].title == searchBarTitle)
                              searchBarTitle = Task.getRandomTask().title!;
                            searchController.clear();
                            tasks.removeAt(index); // Öğeyi listeden kaldır
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Task silindi')),
                          );
                        }
                      },

                      child: Card(
                        color: (list_tasks[index].priority ==
                            Priority.basic)
                            ? Colors.grey[600]
                            : list_tasks[index].priority ==
                            Priority.urgent
                            ? Colors.red[400]
                            : list_tasks[index].priority ==
                            Priority.important
                            ? Colors.orange[600]
                            : Colors.red[900],
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
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                list_tasks[index].title!,
                                style: TextStyle(color: Color(0xff024059)),
                              ),
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
          setState(() {
            Task.tasks.add(newTask);
          });
        },
        child:
            const Icon(Icons.add_task_outlined, color: Colors.white, size: 28),
      ),
    );
  }
}
