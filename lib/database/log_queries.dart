
import 'package:qoiu_utils/qoiu_utills.dart';
import 'package:task_calendar/database/tasks_database.dart';
import 'package:task_calendar/models/calendar_log.dart';
import 'package:task_calendar/models/task.dart';

LogsQueries logQueries = LogsQueries();
 class LogsQueries{

   Future<List<CalendarLog>> getTasksAtDay(String day)async{
     var response = await tasksDatabase.database.rawQuery(
         "SELECT*FROM logs WHERE event_date='$day'");
     'result: $response'.print();
     var result = response.map((e) {
       return CalendarLog.fromMap(e);
     }).toList();
     return result;
   }

   Future<List<CalendarLog>> getAll()async{
     var response = await tasksDatabase.database.rawQuery(
         "SELECT*FROM logs");
     'result: $response'.print();
     var result = response.map((e) {
       return CalendarLog.fromMap(e);
     }).toList();
     return result;
   }

  Future add(CalendarLog log)async {
     'add task: ${log.toMap()}'.print();
     tasksDatabase.database.insert('logs', log.toMap());
     ['Лог добавлен'.dpRed(),log.toMap()].print();
  }
}