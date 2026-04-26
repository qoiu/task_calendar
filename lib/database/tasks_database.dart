import 'package:flutter/foundation.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:sqflite/sqflite.dart';

TasksDatabase tasksDatabase = TasksDatabase();

Map<int, Future Function(Database db)> updates = {
  2: (db) async {
    await db.execute(
        'ALTER TABLE tasks ADD COLUMN complete INTEGER DEFAULT 0');
  },
  3: (db) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS skills (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    complete INTEGER,             
    date TEXT,                    
    time TEXT,                    
    progress INTEGER,             
    duration INTEGER,             
    target INTEGER,               
    lvl INTEGER,                  
    lvlPercent REAL,              
    extra TEXT                    
)
          ''');
  },
  4: (db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS logs (
      id INTEGER PRIMARY KEY,
      event_date INTEGER,
      post_date INTEGER,
      extra TEXT,
      message TEXT,
      priority INTEGER
    )
  ''');
  },
};

class TasksDatabase {
  late String databasesPath;
  late String path;
  late Database database;

  Future init() async {
    databasesPath = await getDatabasesPath();
    String path = '$databasesPath/tasks.db';
    database = await openDatabase(
      path,
      version: 4,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY, date STRING, time STRING, title STRING NOT NULL, description STRING, extra STRING)');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        for (var entry in updates.entries) {
          if (oldVersion < entry.key) {
            await entry.value(db);
          }
        }
      },
    );
  }
}
