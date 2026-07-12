import 'package:qoiu_db/database/base_database_table.dart';
import 'package:qoiu_db/database/database_interface.dart';

import 'package:task_calendar/database/log_queries.dart';
import 'package:task_calendar/database/skill_queries.dart';
import 'package:task_calendar/database/task_queries.dart';


abstract class DB {
  static MainDatabase main = MainDatabase();
  static TaskQueries tasks = TaskQueries();
  static SkillQueries skills = SkillQueries();
  static LogsQueries logs = LogsQueries();
}

class MainDatabase extends DatabaseInterface {
  MainDatabase() : super(databaseName: 'tasks', databaseVersion: 2);

  @override
  List<BaseDatabaseTable> get tables => [DB.tasks, DB.logs, DB.skills];
}
