import 'package:sqflite/sqflite.dart';

TasksDatabase tasksDatabase = TasksDatabase();

class TasksDatabase {
  late String databasesPath;
  late String path;
  late Database database;

  Future init() async {
    databasesPath = await getDatabasesPath();
    String path = '$databasesPath/tasks.db';
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, date STRING, time STRING, title STRING NOT NULL, description STRING, extra STRING)');
    });
  }
}
