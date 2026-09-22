import 'dart:io';

import 'package:qoiu_db/database/database_interface.dart';
import 'package:qoiu_db/database/database_table_interface.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_calendar/project_module/database/project_queries.dart';


class ProjectDatabase extends DatabaseInterface {
  static ProjectDatabase main = ProjectDatabase();

  static ProjectQueries projects = ProjectQueries();
  static ProjectTaskQueries tasks = ProjectTaskQueries();
  static ProjectDividersQueries dividers = ProjectDividersQueries();

  ProjectDatabase() : super(databaseName: 'projects', databaseVersion: 1);

  @override
  List<DatabaseCreateTableInterface> get tables => [ProjectDatabase.tasks, ProjectDatabase.projects, ProjectDatabase.dividers];

}
