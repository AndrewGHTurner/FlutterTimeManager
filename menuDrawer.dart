import 'package:flutter/material.dart';
import 'package:time_manager/addTaskPage.dart';
import 'package:time_manager/databaseController.dart';
import 'package:time_manager/main.dart';
import 'package:time_manager/viewTasksPage.dart';

class MenuDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
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
                  globalKey.currentState?.closeDrawer();
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyHomePage()));
                }),
            ListTile(
                title: Text("Add Task"),
                onTap: () {
                  globalKey.currentState?.closeDrawer();
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddTaskPage(
                                database: database,
                              )));
                }),
            ListTile(
              title: Text("View Tasks"),
              onTap: () {
                globalKey.currentState?.closeDrawer();
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ViewTasksPage(database: database)));
              },
            )
          ],
        ));
  }
}
