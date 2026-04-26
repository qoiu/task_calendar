import 'package:sqflite/sqflite.dart';
import 'package:task_calendar/database/base_database.dart';
import 'package:task_calendar/database/tasks_database.dart';
import 'package:task_calendar/project_module/models/task_data.dart';

Map<int, String> _updates = {};

class ProjectQueries extends BaseDatabase {
  ProjectQueries({required super.database, required super.name})
      : super(fromDB: ProjectTaskData.fromDB);

  static Future<ProjectQueries> create(String name) async {
    var databasesPath = await getDatabasesPath();
    String path = '$databasesPath/$name.db';
    var database = await openDatabase(
      path,
      version: 4,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY, title STRING, icon INTEGER,  offsetX DOUBLE, offsetY DOUBLE, status STRING NOT NULL, extra STRING)');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        for (var entry in _updates.entries) {
          if (oldVersion < entry.key) {
            await db.execute(entry.value);
          }
        }
      },
    );
    return ProjectQueries(database: database, name: name);
  }
}
