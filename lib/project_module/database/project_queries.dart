import 'package:qoiu_db/database/database_table_interface.dart';
import 'package:task_calendar/project_module/models/divider_data.dart';
import 'package:task_calendar/project_module/models/task_data.dart';

import '../models/project_data.dart';

class ProjectQueries extends DatabaseTableInterface<ProjectData> {
  ProjectQueries() : super(fromDB: ProjectData.fromDB, name: 'projects');

  @override
  String get onCreate =>
      'CREATE TABLE IF NOT EXISTS projects (id INTEGER PRIMARY KEY, title STRING, extra STRING)';}

class ProjectTaskQueries extends DatabaseTableInterface<ProjectTaskData> {
  ProjectTaskQueries() : super(fromDB: ProjectTaskData.fromDB, name: 'tasks');

  @override
  String get onCreate =>
      'CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY, projectId INTEGER, title STRING, icon INTEGER,  offsetX DOUBLE, offsetY DOUBLE, status STRING NOT NULL, extra STRING)';

}

class ProjectDividersQueries extends DatabaseTableInterface<DividerData> {
  ProjectDividersQueries()
      : super(fromDB: DividerData.fromDB, name: 'dividers');

  @override
  String get onCreate =>
      'CREATE TABLE IF NOT EXISTS dividers (id INTEGER PRIMARY KEY, projectId INTEGER, title STRING, color STRING, yPos INTEGER , extra STRING)';

}
