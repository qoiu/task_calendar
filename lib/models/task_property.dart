import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:qoiu_utils/typedef.dart';
import 'package:task_calendar/models/task.dart';

part 'package:task_calendar/models/task_properties/repeatable.dart';
part 'package:task_calendar/models/task_properties/ghost.dart';
part 'package:task_calendar/models/task_properties/subtask_list_property.dart';

sealed class TaskProperty {
  static final Map<String, TaskPropertyBuilder> allSubtypes = {
    RepeatableTask._type : RepeatableTaskBuilder(),
    SubtaskListTaskProperty._type : SubtaskListTaskBuilder(),
  };

  static TaskProperty? fromJson(JsonMap json) {
    'type: $json'.print();
    var type =
        allSubtypes.entries.where((e) => e.key == json['type']).firstOrNull;
    'type: $type'.dpGreen().print();
    if (type == null) return null;
    return type.value.buildJson(json);
  }

  static TaskProperty? newObject(String type) {
    'newObject($type)'.print();
    'newObject(${allSubtypes[type]})'.print();
    return allSubtypes[type]?.buildNew();
  }

  Map<String, dynamic> toJson() => {'type': type};

  String get type;
}

extension OnTaskProperty on Task{
  T? typeProperty<T>(){
    return properties.whereType<T>().firstOrNull;
  }

}

abstract class TaskPropertyBuilder{
  TaskProperty buildJson(JsonMap map);
  TaskProperty buildNew();
}