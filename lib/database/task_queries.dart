
import 'package:task_calendar/database/tasks_database.dart';
import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/utils/utils.dart';

TaskQueries taskQueries = TaskQueries();
 class TaskQueries{

   Future<List<Task>> getTasksAtDay(String day)async{
     var response = await tasksDatabase.database.rawQuery(
         "SELECT*FROM tasks WHERE date='$day'");
     'result: $response'.print();
     var result = response.map((e) {
       return Task.fromDB(e);
     }).toList();
     return result;
   }

   Future<List<Task>> getTasksUnsigned()async{
     var response = await tasksDatabase.database.rawQuery(
         "SELECT*FROM tasks  WHERE date IS NULL");
     'result: $response'.print();
     var result = response.map((e) {
       return Task.fromDB(e);
     }).toList();
     return result;
   }

  Future add(Task task)async {
     'add task: ${task.toDb()}'.print();
     tasksDatabase.database.insert('tasks', task.toDb());
  }

  Future update(Task task)async {
    'update task: ${task.toDb()}'.print();
    tasksDatabase.database.update('tasks', task.toDb(),
    where: 'id = ?',
    whereArgs: [task.id],);
  }

   Future<void> deleteTask(int id) async {
     await tasksDatabase.database.delete(
       'tasks',
       where: 'id = ?',
       whereArgs: [id],
     );
   }
}