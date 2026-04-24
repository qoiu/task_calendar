import 'package:qoiu_utils/qoiu_utills.dart';
import 'package:qoiu_utils/typedef.dart';
import 'package:task_calendar/models/skill.dart';
import 'package:task_calendar/models/task.dart';

// part 'package:task_calendar/models/task_properties/ghost.dart';
part 'package:task_calendar/models/skill_properties/skill_statistic.dart';
// part 'package:task_calendar/models/task_properties/subtask_list_property.dart';

sealed class SkillProperty {
  static final Map<String, SkillPropertyBuilder> allSubtypes = {
    'statistic': StatisticSkillBuilder()
  };

  static SkillProperty? fromJson(JsonMap json) {
    'type: $json'.print();
    var type =
        allSubtypes.entries.where((e) => e.key == json['type']).firstOrNull;
    'type: $type'.dpGreen().print();
    if (type == null) return null;
    return type.value.buildJson(json);
  }

  static SkillProperty? newObject(String type) {
    'newObject($type)'.print();
    'newObject(${allSubtypes[type]})'.print();
    return allSubtypes[type]?.buildNew();
  }

  Map<String, dynamic> toJson() => {'type': type};

  String get type;
}

extension OnSkillProperty on SkillData{
  T? typeProperty<T>(){
    return properties.whereType<T>().firstOrNull;
  }

}

abstract class SkillPropertyBuilder{
  SkillProperty buildJson(JsonMap map);
  SkillProperty buildNew();
}