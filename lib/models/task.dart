import 'dart:ui';

import 'package:task_calendar/themes.dart';
import 'package:task_calendar/utils/utils.dart';

class Task {
  String title;
  String? description;
  Color color;
  DateTime start;
  DateTime end;

  Color get textColor => color.oppositeColor();
  String get time =>
      '${formatTime.format(start).padLeft(5, '0')} - ${formatTime.format(end).padLeft(5, '0')}';

  Task(
      {required this.title,
      this.description,
      this.color = MainTheme.accent,
      required this.start,
      required this.end});

  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        color = json['color'] ?? MainTheme.accent,
        start = json['start'],
        end = json['end'];

  Map<String, Object?> toDb() => {
        'title': title,
        'description': description,
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch
      };
}
