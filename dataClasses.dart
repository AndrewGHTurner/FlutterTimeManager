class Task {
  String name;
  int ID;
  Task(this.ID, this.name);
}

class TaskDetails extends Task {
  DateTime completionDate;
  bool isCompleteOn;
  List<Task> subTasks;
  TaskDetails({required this.completionDate, required this.isCompleteOn, required name, required ID, required this.subTasks}) : super(ID, name);
}
