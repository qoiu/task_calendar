part of 'package:task_calendar/models/task_property.dart';

class SubtaskListTaskBuilder extends TaskPropertyBuilder{
  @override
  TaskProperty buildJson(JsonMap map)=>SubtaskListTaskProperty.fromJson(map);

  @override
  TaskProperty buildNew() => SubtaskListTaskProperty();

}
class SubtaskListTaskProperty extends TaskProperty {
  static const String _type = 'subtask';
  @override
  String type = SubtaskListTaskProperty._type;

  List<Subtask> subtasks=[];
  
  SubtaskListTaskProperty({List<Subtask>? list}):subtasks=list??[];

  static TaskProperty fromJson(JsonMap json) {
    var subtasks = parseList(json['subtasks'], Subtask.fromJson);
    return SubtaskListTaskProperty(list: subtasks);
  }

  @override
  Map<String, dynamic> toJson() => super.toJson()..addAll({
    'subtasks':subtasks.map((e)=>e.toJson()).toList()
  });
}

class Subtask {
  String title;
  bool isCompleted;

  Subtask({this.title = '', this.isCompleted = false});

  Subtask.fromJson(JsonMap map)
      : title = map['title'],
        isCompleted = map['complete'];

  JsonMap toJson() => {'title': title, 'complete': isCompleted};
}
