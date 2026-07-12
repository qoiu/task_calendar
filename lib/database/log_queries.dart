
import 'package:task_calendar/models/calendar_log.dart';

import 'package:qoiu_db/database/base_database_table.dart';


 class LogsQueries extends BaseDatabaseTable<CalendarLog>{

   LogsQueries():super(name: 'logs', fromDB: CalendarLog.fromMap);

   @override
   String get onCreate => '''CREATE TABLE IF NOT EXISTS logs (
      id INTEGER PRIMARY KEY,
      event_date INTEGER,
      post_date INTEGER,
      extra TEXT,
      message TEXT,
      priority INTEGER
    )
  ''';
}