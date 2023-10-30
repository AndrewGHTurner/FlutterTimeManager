import 'package:flutter/material.dart';

import 'menuDrawer.dart';
import "databaseController.dart";
import "sharedAppBar.dart";
import "taskInfoPage.dart";

import 'dataClasses.dart';
import 'listTasksWidget.dart';

class ViewTasksPage extends StatefulWidget {
  DatabaseController database;
  ViewTasksPage({Key? key, required this.database}) : super(key: key);
  late ViewTasksPageState j;
  @override
  ViewTasksPageState createState() {
    j = ViewTasksPageState(database: database);
    return j;
  }
} /* body: Column(
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////WORKING HERE NEXT
            children: topLevelTasks!.map((Map<String, Object?> row) {
          print("K");
          return ElevatedButton(
            child: Text(style: TextStyle(fontSize: screenwidth / 20), "Add Task!"),
            onPressed: () => {print("K")},
          );
        }).toList()),*/

class ViewTasksPageState extends State<ViewTasksPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DatabaseController database;
  ViewTasksPageState({required this.database}) {}
  List<Map<String, Object?>>? topLevelTasks = [];
  void rebuild() {
    print("rebuilding");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return (Scaffold(
        key: scaffoldKey,
        body: FutureBuilder(
            future: database.listTopLevelTasks(),
            builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                //describe what should be rendered at each progression state
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text("ERROR");
              } else if (snapshot.hasData) {
                return (ListTasksWidget(database: database, tasks: snapshot.data!, scaffoldKey: scaffoldKey));
              } else {
                return const Text("No Data");
              }
            }),
        //thinking a list of buttons. when a button is pressed it will take you to that tasks info page and it is from that page that you will be able to view any subtasks.. maybe once youve scrolled to the bottom
        appBar: SharedAppBar(
          title: "Your Tasks",
        ),
        drawer: MenuDrawer(
          database: database,
          g: this,
        )));
  }
}
