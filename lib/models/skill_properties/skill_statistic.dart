
part of 'package:task_calendar/models/skill_property.dart';

class StatisticSkillBuilder extends SkillPropertyBuilder{
  @override
  SkillProperty buildJson(JsonMap map)=>StatisticSkill.fromJson(map);

  @override
  SkillProperty buildNew() => StatisticSkill();

}
class StatisticSkill extends SkillProperty{

  int completed=0;
  int failed=0;

  StatisticSkill({this.completed=0, this.failed=0});

  @override
  String get type => 'statistic';


  static SkillProperty fromJson(Map<dynamic, dynamic> json) {
    return StatisticSkill(
      completed: json['completed'],
      failed: json['failed']
    );
  }

  @override
  Map<String, dynamic> toJson() => super.toJson()..addAll({
    'completed':completed,
    'failed':failed
  });

}