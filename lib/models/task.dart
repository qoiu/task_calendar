import 'dart:ui';

import 'package:task_calendar/themes.dart';
import 'package:task_calendar/utils/utils.dart';

class Task {
  int? id;
  String title;
  String? description;
  Color color;
  DateTime start;
  DateTime? end;

  Color get textColor => color.oppositeColor();
  String get time => end == null
      ? formatTime.format(start).padLeft(5, '0')
      : '${formatTime.format(start).padLeft(5, '0')} - ${formatTime.format(end!).padLeft(5, '0')}';

  Task(
      {required this.title,
      this.description,
      this.color = MainTheme.accent,
      required this.start,
      this.end});

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'].toString(),
        description = json['description'],
        color = json['color'] ?? MainTheme.accent,
        start = json['start'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['start'])
            : DateTime.now(),
        end = json['end'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['end'])
            : null;

  Map<String, Object?> toDb() => {
        if (id != null) 'id': id,
        'title': title,
        'description': description,
        'start': start.millisecondsSinceEpoch,
        'end': end?.millisecondsSinceEpoch
      };

  @override
  String toString() {
    return 'Task{title: $title, start: ${formatDate.format(start)}}';
  }
}
