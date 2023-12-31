import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "databaseController.dart";
import "sharedAppBar.dart";
import "menuDrawer.dart";
import "dataClasses.dart";
import 'viewTasksPage.dart';
import 'listTasksWidget.dart';
import 'addTaskPage.dart';

class TaskInfoPage extends StatefulWidget {
  DatabaseController database;
  int taskID;
  TaskInfoPage({Key? key, required this.database, required this.taskID}) : super(key: key);

  @override
  TaskInfoPageState createState() => TaskInfoPageState();
}

class TaskInfoPageState extends State<TaskInfoPage> {
  late GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late DatabaseController database;

  TaskInfoPageState();
  @override
  void initState() {
    super.initState();
    database = widget.database;
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double headingFontSize = screenwidth / 10;
    double textFontSize = screenwidth / 20; /////////////////////////////////////!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!This probs shouldn't be done in build on phones
    double padding = screenwidth / 40;

    return Scaffold(
      key: scaffoldKey,
      appBar: SharedAppBar(
        title: "Task Info",
      ),
      body: FutureBuilder(
          future: database.getTaskDetails(widget.taskID.toString()),
          builder: (BuildContext context, AsyncSnapshot<TaskDetails> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              //describe what should be rendered at each progression state
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text("ERROR");
            } else if (snapshot.hasData) {
              TaskDetails? task = snapshot.data;
              String onOrBy = task?.isCompleteOn == true ? "on" : "by";
              DateTime? completionDateTime = task!.completionDate;
              String completionDate = "${completionDateTime?.day.toString().padLeft(2, '0')}/${completionDateTime?.month.toString().padLeft(2, '0')}/${completionDateTime?.year}";
              String completionTime = "${completionDateTime?.hour.toString().padLeft(2, '0')}:${completionDateTime?.minute.toString().padLeft(2, '0')}";
              StatelessWidget subTaskSection;
              int? hoursNeeded = task?.hoursNeeded;
              int? minutesNeeded = task?.minutesNeeded;
              bool? isRecurring = task?.isRecurring;
              print("Recurring: $isRecurring");
              if (task.subTasks!.isEmpty) {
                subTaskSection = const Text("No tasks to display");
              } else {
                subTaskSection = ListTasksWidget(database: database, tasks: task.subTasks, scaffoldKey: scaffoldKey);
              }
              return Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.name!, style: TextStyle(fontSize: headingFontSize, decoration: TextDecoration.underline), textAlign: TextAlign.left),
                      Spacer(),
                      Text("To be completed $onOrBy :\n      $completionDate at $completionTime", style: TextStyle(fontSize: textFontSize), textAlign: TextAlign.left),
                      Spacer(),
                      Text("Expected this task will take $hoursNeeded hours, and $minutesNeeded minutes.", style: TextStyle(fontSize: textFontSize), textAlign: TextAlign.left),
                      Spacer(),
                      Builder(builder: (context) {
                        if (isRecurring == true) {
                          return Text("this is a recurring task");
                        }
                        return SizedBox.shrink();
                      }),
                      Text("Subtasks:", style: TextStyle(fontSize: textFontSize), textAlign: TextAlign.left),
                      DecoratedBox(decoration: BoxDecoration(color: Colors.amberAccent, borderRadius: BorderRadius.all(Radius.circular(15))), child: Container(height: screenHeight / 3, width: screenwidth * 0.95, child: subTaskSection)),
                      Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            print("j");

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddTaskPage(
                                          parentTask: task,
                                          database: database,
                                        ))).then(
                              (value) {
                                setState(() {});
                              },
                            );
                          },
                          child: const Text("New subtask")),
                      Spacer(),
                    ],
                  ));
            } else {
              return const Text("No Data");
            }
          }),
      drawer: MenuDrawer(
        database: database,
        context: context,
      ),
    );
  }
}
