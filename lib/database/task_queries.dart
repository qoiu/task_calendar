
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:task_calendar/database/tasks_database.dart';
import 'package:task_calendar/models/task.dart';

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

   Future<List<Task>> checkOldTasks()async{
     var response = await tasksDatabase.database.rawQuery(
         "SELECT*FROM tasks  WHERE date IS NOT NULL AND complete IS 0");
     'result: $response'.print();
     var result = response.map((e) {
       return Task.fromDB(e);
     }).toList();
     result.forEach((e){e.updateStatus();});
     return result;
   }

  Future add(Task task)async {
     'add task: ${task.toDb()}'.print();
     tasksDatabase.database.insert('tasks', task.toDb());
     ['Задача добавлена'.dpRed(),task.toDb()].print();
  }

  Future update(Task task)async {
    tasksDatabase.database.update('tasks', task.toDb(),
    where: 'id = ?',
    whereArgs: [task.id],);
    ['Задача обновлена'.dpRed(),task.toDb()].print();
  }

   Future<void> deleteTask(int id) async {
     await tasksDatabase.database.delete(
       'tasks',
       where: 'id = ?',
       whereArgs: [id],
     );
     ['Задача удалена'.dpRed(),id].print();
   }
}