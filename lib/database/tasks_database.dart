import 'package:sqflite/sqflite.dart';

TasksDatabase tasksDatabase = TasksDatabase();

class TasksDatabase {
  late String databasesPath;
  late String path;
  late Database database;

  init() async {
    databasesPath = await getDatabasesPath();
    String path = '$databasesPath/demo.db';
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, start LONG, end LONG, title STRING NOT NULL, description STRING)');
    });
  }
}
