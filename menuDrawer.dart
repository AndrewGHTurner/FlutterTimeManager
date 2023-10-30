import 'package:flutter/material.dart';
import 'package:time_manager/addTaskPage.dart';
import 'package:time_manager/dataClasses.dart';
import 'package:time_manager/databaseController.dart';
import 'package:time_manager/main.dart';
import 'package:time_manager/viewTasksPage.dart';

import 'viewTasksPage.dart';

class MenuDrawer extends StatelessWidget {
  DatabaseController database;
  ViewTasksPageState? g; //this reference is needded if the menu drawer is used to go from viewtasks page to add task page as it will need redrawing if new task is added
  MenuDrawer({
    super.key,
    BuildContext? context,
    required this.database,
    this.g,
  });
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.lightGreen,
        child: ListView(
          // Important: Remove any padding from the ListView.

          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text("Menu"),
            ),
            ListTile(
                title: Text("Home"),
                onTap: () {
                  Scaffold.of(context).closeDrawer();
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
                }),
            ListTile(
                title: Text("Add Task"),
                onTap: () {
                  Scaffold.of(context).closeDrawer();
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddTaskPage(
                                parentTask: TaskDetails(completionDate: DateTime.now(), isCompleteOn: false, isRecurring: false, name: "", ID: -1, subTasks: []),
                                database: database,
                              ))).then(
                    (value) {
                      if (this.g != null) {
                        print("OO");
                        this.g!.rebuild();
                      }
                    },
                  );
                  ;
                }),
            ListTile(
              title: Text("View Tasks"),
              onTap: () {
                Scaffold.of(context).closeDrawer();
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewTasksPage(database: database)));
              },
            )
          ],
        ));
  }
}
