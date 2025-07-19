import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

TasksDatabase tasksDatabase = TasksDatabase();

Map<int, Future Function(Database db)> updates= {
  2:(db)async{
    await db.execute(
        'ALTER TABLE tasks ADD COLUMN complete INTEGER NOT NULL DEFAULT 0'
    );
  }
};

class TasksDatabase {
  late String databasesPath;
  late String path;
  late Database database;

  Future init() async {
    databasesPath = await getDatabasesPath();
    String path = '$databasesPath/tasks.db';
    database = await openDatabase(path, version: 2,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, date STRING, time STRING, title STRING NOT NULL, description STRING, extra STRING)');
    },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
        for (var entry in updates.entries) {
          if(oldVersion<entry.key){
            await entry.value(db);
          }
        }
    },);
  }
}
