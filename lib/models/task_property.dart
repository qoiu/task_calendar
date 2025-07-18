import 'package:qoiu_utils/qoiu_utills.dart';
import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/utils/utils.dart';

part 'package:task_calendar/models/task_properties/repeatable.dart';
part 'package:task_calendar/models/task_properties/ghost.dart';

sealed class TaskProperty {
  static final Map<String, TaskProperty Function(Map)> allSubtypes = {
    RepeatableTask._type : (json) => RepeatableTask.fromJson(json)
  };

  static TaskProperty? fromJson(Map json) {
    'type: $json'.print();
    var type =
        allSubtypes.entries.where((e) => e.key == json['type']).firstOrNull;
    'type: $type'.dpGreen().print();
    if (type == null) return null;
    return type.value(json);
  }

  Map<String, dynamic> toJson() => {'type': type};

  String get type;
}

extension OnTaskProperty on Task{
  T? typeProperty<T>(){
    return properties.whereType<T>().firstOrNull;
  }

}