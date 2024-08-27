
import 'package:task_calendar/models/task.dart';

class CustomListController {
  double yOffset = 0.0;
  DateTime currentDate = DateTime.now();
  Function() updateDate = () {};
  DrawTaskHelper drawTaskHelper = DrawTaskHelper([]);
}

class DrawTaskHelper {
  List<UiDate> dates;

  DrawTaskHelper._(this.dates);
  DrawTaskHelper.fromToday(DateTime today):dates = List.generate(20, (i)=>UiDate(title, times))
  
}

class UiDate {
  String title;
  List<UiTime> times;

  UiDate(this.title, this.times);
}

class UiTime {
  String title;
  List<Task> tasks;

  UiTime(this.title, this.tasks);
}
