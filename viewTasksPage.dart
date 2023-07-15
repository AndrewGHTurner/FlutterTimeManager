import 'package:flutter/material.dart';

import 'menuDrawer.dart';
import "databaseController.dart";
import "sharedAppBar.dart";

class ViewTasksPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  DatabaseController database;
  ViewTasksPage({Key? key, required this.database}) : super(key: key);
  @override
  ViewTasksPageState createState() => ViewTasksPageState(database: database);
}

class ViewTasksPageState extends State<ViewTasksPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DatabaseController database;
  ViewTasksPageState({required this.database}) {}
  List<Map<String, Object?>>? topLevelTasks = [];

  void k() async {
    topLevelTasks = await database.listTopLevelTasks(); //this might need moving idk???
    print("top level tasks");
    topLevelTasks?.forEach((row) {
      print(row.values.elementAt(0));
      print(row.values.elementAt(1));
    });
  }

  @override
  void initState() {
    super.initState();
    k();
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return (Scaffold(
        key: scaffoldKey,
        body: Column(
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////WORKING HERE NEXT
            children: topLevelTasks!.map((Map<String, Object?> row) {
          print("K");
          return ElevatedButton(
            child: Text(style: TextStyle(fontSize: screenwidth / 20), "Add Task!"),
            onPressed: () => {print("K")},
          );
        }).toList()),
        //thinking a list of buttons. when a button is pressed it will take you to that tasks info page and it is from that page that you will be able to view any subtasks.. maybe once youve scrolled to the bottom
        appBar: SharedAppBar(
          title: "Your Tasks",
          scaffoldKey: scaffoldKey,
        ),
        drawer: MenuDrawer(
          database: database,
        )));
  }
}
