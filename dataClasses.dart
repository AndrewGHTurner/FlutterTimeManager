class Task {
  String? name;
  int? ID;
  Task(this.ID, this.name);
}

class TaskDetails extends Task {
  DateTime? completionDate;
  bool? isCompleteOn;
  bool? isRecurring;
  List<Task>? subTasks;
  int? hoursNeeded = 0;
  int? minutesNeeded = 0;
  TaskDetails({required this.completionDate, required this.isCompleteOn, required this.isRecurring, required name, required ID, required this.subTasks, this.hoursNeeded = 0, this.minutesNeeded = 0}) : super(ID, name);
}
