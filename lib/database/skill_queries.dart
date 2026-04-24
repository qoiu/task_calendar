
import 'package:qoiu_utils/qoiu_utills.dart';
import 'package:task_calendar/database/tasks_database.dart';
import 'package:task_calendar/models/skill.dart';
import 'package:task_calendar/models/task.dart';

SkillQueries skillQueries = SkillQueries();
 class SkillQueries{

   Future<List<SkillData>> getSkills()async{
     var response = await tasksDatabase.database.rawQuery(
         "SELECT*FROM skills");
     'result: $response'.print();
     var result = response.map((e) {
       return SkillData.fromDB(e);
     }).toList();
     return result;
   }

   Future add(SkillData skill)async {
     'add skill: ${skill.toDb()}'.print();
     tasksDatabase.database.insert('skills', skill.toDb());
     ['Skill добавлен'.dpRed(),skill.toDb()].print();
   }

   Future update(SkillData skill)async {
     ['update', skill.toDb()].print();
     tasksDatabase.database.update('skills', skill.toDb(),
       where: 'id = ?',
       whereArgs: [skill.id],);
     ['Skill обновлен'.dpRed(),skill.toDb()].print();
   }

   Future<void> deleteTask(int id) async {
     await tasksDatabase.database.delete(
       'skills',
       where: 'id = ?',
       whereArgs: [id],
     );
     ['Skill удален'.dpRed(),id].print();
   }
}