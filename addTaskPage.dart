import 'dart:ffi';

import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_manager/dataClasses.dart';

import 'menuDrawer.dart';
import "databaseController.dart";
import 'package:flutter_form_builder/flutter_form_builder.dart';
import "sharedAppBar.dart";
import "configureRemindersPage.dart";

import 'radioOutlineButton.dart';

import 'viewTasksPage.dart';

import "taskForm.dart";
import "remindersForm.dart";

class AddTaskPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  DatabaseController database;
  TaskDetails parentTask;
  ViewTasksPage? g;
  AddTaskPage({Key? key, required this.database, required this.parentTask, this.g}) : super(key: key);
  @override
  AddTaskPageState createState() => AddTaskPageState();
}

class AddTaskPageState extends State<AddTaskPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late DatabaseController database;
  late TaskDetails parentTask;
  bool? completeOn = false;
  AddTaskPageState();

  RadioOutlineButton onOrByRadioButton = RadioOutlineButton(options: ["Complete On", "Complete By"]);
  RadioOutlineButton recurringOrNotButton = RadioOutlineButton(options: ["One Time", "Recurring"]);
  DateTime? completionDate;
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  bool onOrBy = true;
  bool isRecurring = false;
  bool trackStreak = false;
  String hoursNeeded = "0", minutesNeeded = "0";
  String repeatEveryYears = "0", repeatEveryMonths = "0", repeatEveryWeeks = "0", repeatEveryDays = "0";
  TextEditingController completionDateController = TextEditingController();

  String buttonText = "Add Task";
  @override
  void initState() {
    super.initState();
    database = widget.database;
    parentTask = widget.parentTask;

//  TextEditingController dateController = TextEditingController();

    // recurringOrNotButton

    recurringOrNotButton.selectedIndex.addListener(() {
      setState(() {
        isRecurring = (recurringOrNotButton.selectedIndex.value == 1) ? true : false;
      });
    });

    onOrByRadioButton.selectedIndex.addListener(() {
      setState(() {
        onOrBy = onOrByRadioButton.selectedIndex.value == 0 ? true : false;
      });
    });
  }

  void handleRadioValueChange(bool? value) {
    setState(() {
      completeOn = value;
      print(value);
    });
  }

  TaskDetails taskDetails = TaskDetails(completionDate: null, isCompleteOn: null, isRecurring: null, name: null, ID: null, subTasks: null);
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double headingFontSize = screenwidth / 20;
    String taskName = "";
    String title = "What is the name of the task?";
    DateTime? LatestCompletionDate = DateTime(3000);
    if (parentTask.ID != -1) {
      LatestCompletionDate = parentTask.completionDate;
      String? parentTaskName = parentTask.name;
      title = "What is the name of the subtask $parentTaskName";
    }

    return Scaffold(
        key: scaffoldKey,
        body: FlowBuilder<TaskDetails>(
          state: taskDetails,
          onGeneratePages: (taskDetails, pages) {
            return [
              MaterialPage(
                  child: TaskForm(
                database: database,
              )),
              if (taskDetails.name != null)
                MaterialPage(
                    child: RemindersForm(
                  database: database,
                )),
            ];
          },
        ));
  }
}
