import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:time_manager/dataClasses.dart';
import 'package:time_manager/databaseController.dart';

import 'menuDrawer.dart';
import 'radioOutlineButton.dart';
import 'sharedAppBar.dart';

class TaskForm extends HookWidget {
  DatabaseController database;
  TaskForm({Key? key, required this.database}) : super(key: key);
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double headingFontSize = screenwidth / 20;
    String taskName = "";
    String title = "What is the name of the task?";
    DateTime LatestCompletionDate = DateTime(3000);
    return Scaffold(
        appBar: SharedAppBar(
          title: "Task Delails Form",
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
            const Spacer(),
            Align(alignment: Alignment.centerLeft, child: Text("Is this a recurring or one time task?", style: TextStyle(fontSize: headingFontSize), textAlign: TextAlign.end)),
            this.recurringOrNotButton,
            Spacer(),
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
            Spacer(),
            Visibility(
                visible: isRecurring,
                child: Column(children: <Widget>[
                  Align(alignment: Alignment.centerLeft, child: Text("Repeat every:", style: TextStyle(fontSize: headingFontSize), textAlign: TextAlign.end)),
                  Row(children: [
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
                        )),
                  ]),
                  Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 10,
                      ), //SizedBox
                      const Text(
                        "Track completion streek",
                        style: TextStyle(fontSize: 17.0),
                      ), //Text
                      const SizedBox(width: 10), //SizedBox
                      /** Checkbox Widget **/
                      Checkbox(
                        value: trackStreak,
                        onChanged: (bool? value) {
                          //       setState(() {
                          trackStreak = !trackStreak;
                          //  });
                        },
                      ),
                      Spacer(),
                    ],
                  ),
                ])),
            //input for the completion date
            //     Align(alignment: Alignment.centerLeft, child: Text("Enter completion date", style: TextStyle(fontSize: headingFontSize), textAlign: TextAlign.end)),
            Align(alignment: Alignment.centerLeft, child: Text("Complete on or by", style: TextStyle(fontSize: headingFontSize), textAlign: TextAlign.end)),
            onOrByRadioButton,
            Spacer(),
            /*configure reminders button
            ElevatedButton(
              child: Text(style: TextStyle(fontSize: screenwidth / 20), "Configure reminders - Optional"),
              onPressed: () {
                print("I)");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConfigureRemindersPage(
                              database: database,
                            )));
              },
            ),
            Spacer(),*/
            Align(alignment: Alignment.centerLeft, child: Text("How long will it take? - Optional", style: TextStyle(fontSize: headingFontSize), textAlign: TextAlign.end)),

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
            //next button
            ElevatedButton(
                onPressed: () {
                  context.flow<TaskDetails>().update((state) => TaskDetails(completionDate: null, isCompleteOn: null, isRecurring: null, name: taskName, ID: null, subTasks: null));
                },
                child: const Text("Next")),

            //Add Task button
            /*      ElevatedButton(
                child: Text(style: TextStyle(fontSize: screenwidth / 20), buttonText),
                onPressed: () async {
                  formKey.currentState?.save();
                  bool d = await database.addTask(
                      taskName: taskName!,
                      completionDate: completionDate.toString(),
                      isCompleteOn: onOrBy,
                      parentTaskID: parentTask.ID,
                      isReccuring: isRecurring,
                      neededHours: hoursNeeded,
                      neededMinutes: minutesNeeded,
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
                }),*/
          ]),
        ),
        drawer: MenuDrawer(
          database: database,
        ));
  }
}
