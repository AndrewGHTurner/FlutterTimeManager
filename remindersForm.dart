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

class RemindersForm extends HookWidget {
  DatabaseController database;
  RemindersForm({Key? key, required this.database}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: formKey,
        body: Column(children: <Widget>[
          const Text("ned "),
          ElevatedButton(
              onPressed: () {
                print("KKK");
                context.flow<TaskDetails>().update((state) => state = TaskDetails(completionDate: null, isCompleteOn: null, isRecurring: null, name: null, ID: null, subTasks: null));
              },
              child: const Text("Submit"))
        ]));
  }
}
