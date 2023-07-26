import 'package:flutter/material.dart';
import 'package:time_manager/addTaskPage.dart';
import 'package:time_manager/dataClasses.dart';
import 'package:time_manager/databaseController.dart';
import 'package:time_manager/main.dart';
import 'package:time_manager/viewTasksPage.dart';

class MenuDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DatabaseController database;
  MenuDrawer({super.key, BuildContext? context, required this.database});
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
                  scaffoldKey.currentState?.closeDrawer();
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
                }),
            ListTile(
                title: Text("Add Task"),
                onTap: () {
                  scaffoldKey.currentState?.closeDrawer();
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddTaskPage(
                                parentTask: TaskDetails(completionDate: DateTime.now(), isCompleteOn: false, name: "", ID: -1, subTasks: []),
                                database: database,
                              )));
                }),
            ListTile(
              title: Text("View Tasks"),
              onTap: () {
                scaffoldKey.currentState?.closeDrawer();
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewTasksPage(database: database)));
              },
            )
          ],
        ));
  }
}
