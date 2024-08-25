import 'package:task_calendar/models/task.dart';

class DateDetails{
  String date;
  List<Task> tasks;

  DateDetails({required this.date, this.tasks=const []});
}