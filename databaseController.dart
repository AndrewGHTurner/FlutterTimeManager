import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dataClasses.dart';

class DatabaseController {
  Database? database;
  DatabaseController();

  Future<String> getDatabasePath() async {
    String databaseName = "Tasks.db";
    Directory directory = await getApplicationDocumentsDirectory();

    return join(directory.path, databaseName);
  }

  Future<bool> checkDatabaseExists() async {
    if (database == null) {
      return false;
    } else {
      return true;
    }
  }

//this method doesnt work
  Future<String> checkTableExists(String tableName) async {
    String checkExistTable = "SELECT * FROM $tableName";
    List<Map<String, Object?>>? checkExist = await database?.rawQuery(checkExistTable);
    print("DFGHJK");
    if (checkExist != null) {
      if (checkExist.isEmpty == false) {
        return "Table $tableName Exists";
      } else {
        return "Table $tableName does not exist";
      }
    }
    return "resultt empty";
  }

  void makeDatabase() async {
    print("mak");
    sqfliteFfiInit();
    WidgetsFlutterBinding.ensureInitialized();
    //join method from path package is best practice so path is formed correctly on multiple platforms
    databaseFactory = databaseFactoryFfi;
    String databaseName = "Tasks.db";
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, databaseName);

    database = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      //Creates the table that holds all of the tasks entered by the user
      //creates the table that lists the top level tasks ie the tasks that do not have a parent task
      //creates the table that links parent task with their subtasks
      await db.execute("""
            CREATE TABLE tasks(
              taskID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
              name VARCHAR NOT NULL,
              completionDate DATE,
              neededMinutes INTEGER,
              neededHours INTEGER,
              isCompleteOn BOOL,
              isRecurring BOOL);""");

      await db.execute("""CREATE TABLE topLevelTasks(
              taskID INTEGER,
              FOREIGN KEY (taskID) REFERENCES tasks(taskID));""");

      await db.execute("""CREATE TABLE subTasks(
              parentTaskID INTEGER NOT NULL,
              childTaskID INTEGER NOT NULL,
              FOREIGN KEY (parentTaskID) REFERENCES tasks(taskID),
              FOREIGN KEY (childTaskID) REFERENCES tasks(taskID));""");

      await db.execute("""CREATE TABLE recurranceIntervals(
              taskID INTEGER,
              years INTEGER NOT NULL,
              months INTEGER NOT NULL,
              weeks INTEGER NOT NULL,
              days INTEGER NOT NULL,
              FOREIGN KEY (taskID) REFERENCES tasks(taskID));
            """);
    });
  }

  Future<bool> addTask(
      {required String taskName,
      required String? completionDate,
      required bool isCompleteOn,
      required bool isReccuring,
      int parentTaskID = -1,
      String neededHours = "0",
      String neededMinutes = "0",
      String years = "0",
      String months = "0",
      String weeks = "0",
      String days = "0"}) async {
    //insert the new task in the tasks table ... this must be done first to prevent foreign key trouble
    int? tasksRowID = await database?.rawInsert("""INSERT INTO tasks(name, completionDate, neededMinutes, neededHours, isCompleteOn, isRecurring) VALUES (
      '$taskName', '$completionDate', '$neededMinutes', '$neededHours', '$isCompleteOn', '$isReccuring');""");
    if (tasksRowID == 0) {
      return false; //could not insert ... use a transaction?
    }
    String lastID = await tasksRowID.toString();
    if (parentTaskID < 1) {
      //TaskID of -1 indecates that this is a top level task.
      //get the rowID of the task that's just been inputted and add it to the list of top level tasks
      if (await database?.rawInsert("INSERT INTO topLevelTasks(taskID) VALUES ((SELECT taskID FROM tasks WHERE rowid = $lastID));") == 0) {
        return false; //could not insert
      }
    } else {
      //this task must be a subtask
      //get the rowID of the task that's just been inputted and add it to the subTasks table with the given parentTaskID
      if (await database?.rawInsert("INSERT INTO subTasks(parentTaskID, childTaskID) VALUES ('$parentTaskID', '$lastID');") == 0) {
        return false; //could not insert
      }
    }
    //if the task is recurring insert the reccurance interval into the recurrance intervals table
    if (isReccuring) {
      if (await database?.rawInsert("INSERT INTO recurranceIntervals(taskID, years, months, weeks, days) VALUES ('$lastID', '$years', '$months', '$weeks', '$days');") == 0) {
        return false;
      }
    }
    return true;
  }

  void _deleteSubTask(String subTaskID) async {
    //delete the reference between this task and its parent task
    database?.execute("DELETE FROM subTasks WHERE childTaskID = '$subTaskID'");
    //delete this task
    database?.execute("DELETE FROM tasks WHERE taskID = '$subTaskID'");
  }

  void _deleteSubTasks(String subTaskID) async {
    List<Map<String, Object?>>? subTaskIDs = await database?.rawQuery("SELECT childTaskID FROM subTasks WHERE parentTaskID = $subTaskID;");
    if (subTaskIDs!.isEmpty) //this task will have no further subTasks
    {
      _deleteSubTask(subTaskID);
    } else {
      //this will delete all subTasks of the subTasks
      for (var subTaskID in subTaskIDs) {
        _deleteSubTasks(subTaskID['childTaskID'].toString());
      }
      _deleteSubTask(subTaskID);
    }
  }

  void deleteTask(String taskID) async {
    print(taskID);
    //delete the reference to this task if it is a top level task
    database?.execute("DELETE FROM topLevelTasks WHERE taskID = '$taskID'");
    _deleteSubTasks(taskID);
  }

  //returns taskIDs and names of all top level tasks
  Future<List<Task>> listTopLevelTasks() async {
    List<Map<String, Object?>>? result = await database?.rawQuery("SELECT tasks.taskID, tasks.name FROM tasks INNER JOIN topLevelTasks ON tasks.taskID = topLevelTasks.taskID");
    List<Task> taskList = [];
    result?.forEach((row) {
      taskList.add(Task(row['taskID'] as int, row["name"] as String));
    });
    return taskList;
  }

  //returns a list of names and IDs of subtasks of a task whos ID is given as a string.
  //parentTaskID is given as a string to save one line of code
  Future<List<Task>> listSubTasks(String parentTaskID) async {
    List<Map<String, Object?>>? result = await database?.rawQuery("SELECT tasks.taskID, tasks.name FROM tasks INNER JOIN subTasks ON tasks.taskID = subTasks.childTaskID WHERE subTasks.parentTaskID = $parentTaskID");
    List<Task> taskList = [];
    result?.forEach((row) {
      taskList.add(Task(row['taskID'] as int, row["name"] as String));
    });
    return taskList;
  }

  //returns data from a whole row of the tasks table in the database representing all of the details about a single task
  //input is the id of the task as a string ... tasking as a string to save one line of code
  Future<TaskDetails> getTaskDetails(String taskID) async {
    //get name, completionDate etc about task from tasks table
    List<Map<String, Object?>>? result = await database?.rawQuery("SELECT * FROM tasks WHERE taskID = $taskID"); //there will only ever be one result ... hopefully
    Map<String, Object?> task = result!.first;
    //make list of subTasks of this task
    String date = task["completionDate"] as String;
    if (date == "null") {
      date = DateTime(0).toString();
    }
    return TaskDetails(
        completionDate: DateTime.parse(date),
        isCompleteOn: task["isCompleteOn"] == "false" ? false : true,
        isRecurring: task["isRecurring"] == "false" ? false : true,
        name: task["name"] as String,
        ID: task["taskID"] as int,
        hoursNeeded: task["neededHours"] as int,
        minutesNeeded: task["neededMinutes"] as int,
        subTasks: await listSubTasks(taskID));
  }
}
