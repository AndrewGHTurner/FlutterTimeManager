import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class DatabaseController {
  Database? database;
  DatabaseController() {
    makeDatabase();
  }
  void makeDatabase() async {
    print("mak");
    WidgetsFlutterBinding.ensureInitialized();
    //join method from path package is best practice so path is formed correctly on multiple platforms
    databaseFactory = databaseFactoryFfi;

    database = await openDatabase(join(await getDatabasesPath(), "Tasks.db"), version: 1, onCreate: (Database db, int version) async {
      //Creates the table that holds all of the tasks entered by the user
      //creates the table that lists the top level tasks ie the tasks that do not have a parent task
      await db.execute("""
            CREATE TABLE tasks(
              taskID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
              name VARCHAR NOT NULL,
              completionDate DATE,
              isCompleteOn BOOL);
            
            CREATE TABLE topLevelTasks(
              taskID INTEGER,
              FOREIGN KEY (taskID) REFERENCES tasks(taskID));
            """);
    });
  }

  void addTask(String taskName, DateTime? completionDate, bool isCompleteOn, bool isTopLevelTask) async {
    print("INSERT INTO tasks(name) VALUES ($taskName);");
    String date = completionDate.toString();
    String onOrBy = isCompleteOn.toString();
    print("""INSERT INTO tasks(name, completionDate, isCompleteOn) VALUES (
      '$taskName', '$date', $onOrBy);""");
    database?.execute("""INSERT INTO tasks(name, completionDate, isCompleteOn) VALUES (
      '$taskName', '$date', $onOrBy);""");
    if (isTopLevelTask) {
      //get the rowID of the task that's just been inputted and add it to the list of top level tasks
      List<Map<String, Object?>>? result = await database?.rawQuery("SELECT last_insert_rowid();");
      String? lastRowID = Sqflite.firstIntValue(result!).toString();
      database?.execute("INSERT INTO topLevelTasks(taskID) VALUES ((SELECT taskID FROM tasks WHERE rowid = $lastRowID));");
    }
  }

  //returns taskIDs and names of all top level tasks
  Future<List<Map<String, Object?>>?> listTopLevelTasks() async {
    return await database?.rawQuery("SELECT tasks.taskID, tasks.name FROM tasks INNER JOIN topLevelTasks ON tasks.taskID = topLevelTasks.taskID");
  }
}
