
part of 'package:task_calendar/models/task_property.dart';

class RepeatableTask extends TaskProperty {

  int? repeatAfter;

  static const String _type = 'repeatable';
  @override
  String type = RepeatableTask._type;


  RepeatableTask({this.repeatAfter});

  static TaskProperty fromJson(Map<dynamic, dynamic> json) {
    return RepeatableTask(
        repeatAfter: json['after']
    );
  }

  @override
  Map<String, dynamic> toJson() => super.toJson()..addAll({
    'after':repeatAfter
  });
}