import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_manager/dataClasses.dart';

import 'menuDrawer.dart';
import "databaseController.dart";
import 'package:flutter_form_builder/flutter_form_builder.dart';
import "sharedAppBar.dart";

import 'radioOutlineButton.dart';

import 'viewTasksPage.dart';

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
  String onOrBy = true.toString();
  bool isRecurring = false;
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
  }

  void handleRadioValueChange(bool? value) {
    setState(() {
      completeOn = value;
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double headingFontSize = screenwidth / 20;
    String taskName = "";
    String title = "What is the name of the task?";
    DateTime LatestCompletionDate = DateTime(3000);
    if (parentTask.ID != -1) {
      LatestCompletionDate = parentTask.completionDate;
      String parentTaskName = parentTask.name;
      title = "What is the name of the subtask $parentTaskName";
    }

    return Scaffold(
        key: scaffoldKey,
        appBar: SharedAppBar(
          title: "Add Task",
          scaffoldKey: scaffoldKey,
        ),
        body: Form(
          key: formKey,
          child: Column(children: [
            TextFormField(
              decoration: InputDecoration(
                labelStyle: TextStyle(fontSize: headingFontSize),
                labelText: title,
              ),
              onSaved: (value) {
                print("J");
                taskName = value!;
              },
            ),
            //  Align(alignment: Alignment.centerLeft, child: Text("Complete task by or on the date?", style: TextStyle(fontSize: headingFontSize), textAlign: TextAlign.end)),
            Align(alignment: Alignment.centerLeft, child: Text("Is this a recurring or one time task?", style: TextStyle(fontSize: headingFontSize), textAlign: TextAlign.end)),
            this.recurringOrNotButton,

            Visibility(
                visible: !isRecurring,
                child: Column(children: <Widget>[
                  Align(alignment: Alignment.centerLeft, child: Text("Enter completion date", style: TextStyle(fontSize: headingFontSize), textAlign: TextAlign.end)),
                ])),
            Visibility(
              visible: isRecurring,
              child: Align(alignment: Alignment.centerLeft, child: Text("Enter first completion date", style: TextStyle(fontSize: headingFontSize), textAlign: TextAlign.end)),
            ),

            FormBuilderDateTimePicker(
              controller: completionDateController,
              name: 'date_established',
              format: DateFormat('dd/MM/yyyy hh:mm'),
              initialDate: DateTime.now(),
              lastDate: LatestCompletionDate,
              enabled: true,
              style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.normal),
              onSaved: (DateTime? dateTime) {
                completionDate = dateTime;
              },
            ),

            Visibility(
                visible: isRecurring,
                child: Column(children: <Widget>[
                  Align(alignment: Alignment.centerLeft, child: Text("Repeat every:", style: TextStyle(fontSize: headingFontSize), textAlign: TextAlign.end)),
                  Row(
                    children: [
                      SizedBox(
                          width: screenwidth / 4,
                          child: TextFormField(
                            initialValue: "0",
                            decoration: InputDecoration(
                              labelStyle: TextStyle(fontSize: headingFontSize),
                              labelText: "years",
                            ),
                            onSaved: (value) {
                              repeatEveryYears = value!;
                            },
                          )),
                      SizedBox(
                          width: screenwidth / 4,
                          child: TextFormField(
                            initialValue: "0",
                            decoration: InputDecoration(
                              labelStyle: TextStyle(fontSize: headingFontSize),
                              labelText: "months",
                            ),
                            onSaved: (value) {
                              repeatEveryMonths = value!;
                            },
                          )),
                      SizedBox(
                          width: screenwidth / 4,
                          child: TextFormField(
                            initialValue: "0",
                            decoration: InputDecoration(
                              labelStyle: TextStyle(fontSize: headingFontSize),
                              labelText: "weeks",
                            ),
                            onSaved: (value) {
                              repeatEveryWeeks = value!;
                            },
                          )),
                      SizedBox(
                          width: screenwidth / 4,
                          child: TextFormField(
                            initialValue: "0",
                            decoration: InputDecoration(
                              labelStyle: TextStyle(fontSize: headingFontSize),
                              labelText: "days",
                            ),
                            onSaved: (value) {
                              repeatEveryDays = value!;
                            },
                          ))
                    ],
                  ),
                ])),
            //input for the completion date
            //     Align(alignment: Alignment.centerLeft, child: Text("Enter completion date", style: TextStyle(fontSize: headingFontSize), textAlign: TextAlign.end)),
            Align(alignment: Alignment.centerLeft, child: Text("Complete on or by", style: TextStyle(fontSize: headingFontSize), textAlign: TextAlign.end)),
            onOrByRadioButton,
            Align(alignment: Alignment.centerLeft, child: Text("How long will it take?", style: TextStyle(fontSize: headingFontSize), textAlign: TextAlign.end)),

            Row(
              children: [
                SizedBox(
                    width: screenwidth / 2,
                    child: TextFormField(
                      initialValue: "0",
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: headingFontSize),
                        labelText: "hours",
                      ),
                      onSaved: (value) {
                        hoursNeeded = value!;
                      },
                    )),
                SizedBox(
                    width: screenwidth / 2,
                    child: TextFormField(
                      initialValue: "0",
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: headingFontSize),
                        labelText: "minutes",
                      ),
                      onSaved: (value) {
                        minutesNeeded = value!;
                      },
                    ))
              ],
            ),
            //Add Task button
            ElevatedButton(
                child: Text(style: TextStyle(fontSize: screenwidth / 20), buttonText),
                onPressed: () async {
                  formKey.currentState?.save();
                  onOrBy = onOrByRadioButton.selectedIndex == 0 ? true.toString() : false.toString();
                  bool d = await database.addTask(
                      taskName: taskName!,
                      completionDate: completionDate.toString(),
                      isCompleteOn: onOrBy,
                      parentTaskID: parentTask.ID,
                      isReccuring: isRecurring,
                      years: repeatEveryYears,
                      months: repeatEveryMonths,
                      weeks: repeatEveryWeeks,
                      days: repeatEveryDays);
                  print("II");
                  if (mounted) //after the above await this checks that the build context still exists to prevent craches
                  {
                    final navigator = Navigator.of(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          String alert;
                          if (d) {
                            alert = "Task added successfully";
                          } else {
                            alert = "Failed to add task";
                          }
                          return AlertDialog(
                            content: Text(alert),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  navigator.pop();
                                  navigator.pop();

                                  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ,));
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        });
                  }
                }),
          ]),
        ),
        drawer: MenuDrawer(
          database: database,
        ));
  }
}
