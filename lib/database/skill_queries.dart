import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:task_calendar/models/skill.dart';

import 'package:qoiu_db/database/base_database_table.dart';

class SkillQueries extends BaseDatabaseTable<SkillData> {
  SkillQueries() : super(name: 'skills', fromDB: SkillData.fromDB);

  @override
  String get onCreate => '''
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
          ''';

}
