import 'package:flutter/material.dart';
import 'package:time_manager/databaseController.dart';
import 'dataClasses.dart';
import 'taskInfoPage.dart';

class ListTasksWidget extends StatelessWidget {
  DatabaseController database;
  List<Task> tasks;
  final GlobalKey<ScaffoldState> scaffoldKey;
  ListTasksWidget({super.key, BuildContext? context, required this.database, required this.tasks, required this.scaffoldKey});
  @override
  Widget build(BuildContext context) {
    return (ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          Task task = tasks![index];
          return (Dismissible(
            key: ValueKey<int>(tasks[index].ID),
            onDismissed: (dismissDirection) => {print(task.name)},
            background: Container(
              color: Colors.red,
              child: Icon(Icons.delete_forever),
            ),
            child: ListTile(
                title: ElevatedButton(
              child: Text(task.name),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaskInfoPage(
                              database: database,
                              taskID: task.ID,
                            )));
              },
            )),
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  String name = task.name;
                  String taskID = task.ID.toString();
                  return AlertDialog(
                    title: const Text("Confirm"),
                    content: Text("Are you sure you wish to delete the task: $name?"),
                    actions: <Widget>[
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            database.deleteTask(taskID);
                          },
                          child: const Text("DELETE")),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("CANCEL"),
                      ),
                    ],
                  );
                },
              );
            },
          ));
        }));
  }
}
