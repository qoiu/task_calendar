import 'package:task_calendar/database/base_database.dart';
import 'package:task_calendar/project_module/models/divider_data.dart';
import 'package:task_calendar/project_module/models/task_data.dart';

import '../models/project_data.dart';

class ProjectQueries extends BaseDatabase<ProjectData> {
  ProjectQueries({required super.database})
      : super(fromDB: ProjectData.fromDB, name: 'projects');
}

class ProjectTaskQueries extends BaseDatabase<ProjectTaskData> {
  ProjectTaskQueries({required super.database})
      : super(fromDB: ProjectTaskData.fromDB, name: 'tasks');
}

class ProjectDividersQueries extends BaseDatabase<DividerData> {
  ProjectDividersQueries({required super.database})
      : super(fromDB: DividerData.fromDB, name: 'dividers');
}
