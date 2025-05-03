
part of 'package:task_calendar/models/task_property.dart';

class GhostTask extends TaskProperty {
  static const String _type = 'ghost';
  @override
  String type = GhostTask._type;

  static TaskProperty fromJson(Map<dynamic, dynamic> json) {
    return GhostTask();
  }

  @override
  Map<String, dynamic> toJson() => super.toJson()..addAll({});
}
