import 'package:sqflite/sqflite.dart';
import 'package:task_calendar/project_module/database/project_queries.dart';

abstract class ProjectDatabase {
  static Map<int, String> _updates = {};

  static late ProjectQueries projects;
  static late ProjectTaskQueries tasks;
  static late ProjectDividersQueries dividers;

  static init() async {
    var databasesPath = await getDatabasesPath();
    String path = '$databasesPath/projects';
    // await deleteDatabase(path);
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY, projectId INTEGER, title STRING, icon INTEGER,  offsetX DOUBLE, offsetY DOUBLE, status STRING NOT NULL, extra STRING)');
        await db.execute(
            'CREATE TABLE IF NOT EXISTS dividers (id INTEGER PRIMARY KEY, projectId INTEGER, title STRING, color STRING, yPos INTEGER , extra STRING)');
        await db.execute(
            'CREATE TABLE IF NOT EXISTS projects (id INTEGER PRIMARY KEY, title STRING, extra STRING)');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        for (var entry in _updates.entries) {
          if (oldVersion < entry.key) {
            await db.execute(entry.value);
          }
        }
      },
    );
    projects = ProjectQueries(database: database);
    tasks = ProjectTaskQueries(database: database);
    dividers = ProjectDividersQueries(database: database);
  }
}
