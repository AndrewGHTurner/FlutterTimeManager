import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_manager/dataClasses.dart';

import 'menuDrawer.dart';
import "databaseController.dart";
import 'package:flutter_form_builder/flutter_form_builder.dart';
import "sharedAppBar.dart";

class AddTaskPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  DatabaseController database;
  TaskDetails parentTask;
  AddTaskPage({Key? key, required this.database, required this.parentTask}) : super(key: key);
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
  @override
  void initState() {
    super.initState();
    database = widget.database;
    parentTask = widget.parentTask;
  }

  void handleRadioValueChange(bool? value) {
    setState(() {
      completeOn = value;
      print(value);
    });
  }

  DateTime? completionDate;
  TextEditingController dateController = TextEditingController();
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double headingFontSize = screenwidth / 20;
    String? taskName;
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
          title: title,
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
                taskName = value;
              },
            ),
            Align(alignment: Alignment.centerLeft, child: Text("Complete task by or on the date?", style: TextStyle(fontSize: headingFontSize), textAlign: TextAlign.end)),
            Row(
              children: <Widget>[
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('On'),
                    value: true,
                    groupValue: completeOn,
                    onChanged: handleRadioValueChange,
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('By'),
                    value: false,
                    groupValue: completeOn,
                    onChanged: handleRadioValueChange,
                  ),
                )
              ],
            ),
            //input for the completion date
            Align(alignment: Alignment.centerLeft, child: Text("Enter completion date", style: TextStyle(fontSize: headingFontSize), textAlign: TextAlign.end)),
            FormBuilderDateTimePicker(
              name: 'date_established',
              format: DateFormat('dd/MM/yyyy hh:mm'),
              initialDate: DateTime.now(),
              lastDate: LatestCompletionDate,
              enabled: true,
              decoration: InputDecoration(hintText: "Enter completion date", labelStyle: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.normal)),
              style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.normal),
              onSaved: (DateTime? dateTime) {
                completionDate = dateTime;
              },
            ),
            //Add Task button
            ElevatedButton(
              child: Text(style: TextStyle(fontSize: screenwidth / 20), "Add Task!"),
              onPressed: () {
                formKey.currentState?.save();
                database.addTask(taskName: taskName!, completionDate: completionDate.toString(), isCompleteOn: completeOn.toString(), parentTaskID: parentTask.ID);
              },
            ),
          ]),
        ),
        drawer: MenuDrawer(
          database: database,
        ));
  }
}
