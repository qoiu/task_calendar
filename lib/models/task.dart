import 'dart:convert';
import 'dart:ui';

import 'package:task_calendar/models/task_property.dart';
import 'package:task_calendar/themes.dart';
import 'package:task_calendar/utils/utils.dart';

class Task {
  int? id;
  String title;
  String? description;
  Color color;
  DateTime? start;
  List<TaskProperty> properties;

  Color get textColor => color.oppositeColor();

  bool isTime(String time) =>
      start?.let((e) => formatTime.format(e) == time) ?? false;

  String get time =>
      start?.let((e) => formatTime.format(e).padLeft(5, '0')) ?? '';

  // : '${formatTime.format(start).padLeft(5, '0')} - ${formatTime.format(end!).padLeft(5, '0')}';

  Task(
      {required this.title,
        this.id,
      this.description,
      this.color = MainTheme.accent,
      this.start,
      this.properties = const []});

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'].toString(),
        description = json['description'],
        color = json['color'] ?? MainTheme.accent,
        start = json['start'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['start'])
            : DateTime.now(),
        properties = parseProperties(json['extra']);

  static List<TaskProperty> parseProperties(List? json) {
    'isList: ${json is List}'.print();
    return json == null
        ? []
        : json
            .whereType<Map<String, dynamic>>()
            .nonNulls
            .map((e) => TaskProperty.fromJson(e))
            .nonNulls
            .toList();
  }

  Task.fromDB(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'].toString(),
        description = json['description'],
        start = null,
        color = json['color'] ?? MainTheme.accent,
        properties = parseProperties(jsonDecode(json['extra'])) {
    'date: ${json['date']}'.print();
    'time: ${json['time']}'.print();
    if (json['date'] != null && json['time'] != null) {
      var time = formatTime.parse(json['time']);
      start = formatDate
          .parse(json['date'])
          .copyWith(hour: time.hour, minute: time.minute);
    }
  }

  Map<String, Object?> toDb() => {
        'title': title,
        'description': description,
        'date': start?.let((e) => formatDate.format(e)),
        'time': start?.let((e) => formatTime.format(e)),
        'extra': jsonEncode(properties.map((e) => e.toJson()).toList())
      };

  Task copyWith({
    String? title,
    String? description,
    Color? color,
    DateTime? start,
    List<TaskProperty>? properties,
  }) =>
      Task(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        color: color ?? this.color,
        start: start ?? this.start,
        properties: properties ?? this.properties,
      );

  @override
  String toString() {
    return 'Task{title: $title, start: ${start?.let((e) => formatDate.format(e))}}';
  }
}
