import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qoiu_utils/qoiu_utills.dart';
import 'package:task_calendar/models/task_property.dart';
import 'package:task_calendar/themes.dart';
import 'package:task_calendar/utils/utils.dart';

class Task {
  int? id;
  String title;
  String? description;
  Color taskColor;
  DateTime? start;
  bool complete;
  List<TaskProperty> properties;


  Color get color => complete ? Colors.yellow : taskColor;
  GlobalKey taskKey = GlobalKey();

  late Color textColor = taskColor.oppositeColor();
  late Color extraColor = taskColor.oppositeExtraColor(0.05);

  updateColors() {
    textColor = color.oppositeColor();
    extraColor = color.oppositeExtraColor(0.05);
  }

  bool isTime(String time) =>
      start?.let((e) => formatTime.format(e) == time) ?? false;

  bool isDate(String date) =>
      start?.let((e) => formatDate.format(e) == date) ?? false;

  String get time =>
      start?.let((e) => formatTime.format(e).padLeft(5, '0')) ?? '';

  // : '${formatTime.format(start).padLeft(5, '0')} - ${formatTime.format(end!).padLeft(5, '0')}';

  Task(
      {required this.title,
      this.id,
      this.description,
      this.start,
      this.taskColor = MainTheme.accent,
      this.complete = false,
      this.properties = const []}) {
    updateColors();
  }

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'].toString(),
        description = json['description'],
        taskColor = json['color'] ?? MainTheme.accent,
        complete = json['complete'] ?? false,
        start = json['start'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['start'])
            : DateTime.now(),
        properties = parseProperties(json['extra']) {
    updateColors();
  }

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
        taskColor = json['color'] ?? MainTheme.accent,
        complete = json['complete'] == 1,
        properties = parseProperties(jsonDecode(json['extra'])) {
    'date: ${json['date']}'.print();
    'time: ${json['time']}'.print();
    if (json['date'] != null && json['time'] != null) {
      var time = formatTime.parse(json['time']);
      start = formatDate
          .parse(json['date'])
          .copyWith(hour: time.hour, minute: time.minute);
      updateColors();
    }
  }

  Map<String, Object?> toDb() => {
        'title': title,
        'description': description,
        'complete': complete,
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
  }) {
    var task = Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      taskColor: color ?? taskColor,
      start: start ?? this.start,
      properties: properties ?? this.properties,
    );
    return task;
  }

  @override
  String toString() {
    return 'Task{title: $title, start: ${start?.let((e) => formatDate.format(e))}}';
  }
}
