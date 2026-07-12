import 'package:qoiu_db/database/base_database_table.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:task_calendar/models/task.dart';

class TaskQueries extends BaseDatabaseTable<Task> {
  TaskQueries() : super(fromDB: Task.fromDB, name: 'tasks');

  @override
  String get onCreate => '''CREATE TABLE IF NOT EXISTS tasks (
   id INTEGER PRIMARY KEY,
       date STRING,
       time STRING,
       title STRING NOT NULL,
       description STRING,
       extra STRING,
       complete INTEGER DEFAULT 0
   )''';

  @override
  Map<int, String> get onUpdate => {
        2: 'ALTER TABLE tasks ADD COLUMN category TEXT DEFAULT "";'
      };

  Future<List<Task>> getTasksAtDay(String day) async {
    var response =
        await database.rawQuery("SELECT*FROM tasks WHERE date='$day'");
    'result: $response'.print();
    var result = response.map((e) {
      return Task.fromDB(e);
    }).toList();
    return result;
  }

  Future<List<Task>> getTasksUnsigned() async {
    var response =
        await database.rawQuery("SELECT*FROM tasks  WHERE date IS NULL");
    'result: $response'.print();
    var result = response.map((e) {
      return Task.fromDB(e);
    }).toList();
    return result;
  }

  Future<List<Task>> checkOldTasks() async {
    var response = await database.rawQuery(
        "SELECT*FROM tasks  WHERE date IS NOT NULL AND complete IS 0");
    'result: $response'.print();
    var result = response.map((e) {
      return Task.fromDB(e);
    }).toList();
    result.forEach((e) {
      e.updateStatus();
    });
    return result;
  }
}
