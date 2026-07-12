import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qoiu_db/database/db_entity.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:qoiu_utils/typedef.dart';
import 'package:task_calendar/models/calendar_log.dart';
import 'package:task_calendar/models/task_property.dart';
import 'package:task_calendar/themes.dart';
import 'package:task_calendar/utils/json_map_extension.dart';
import 'package:task_calendar/utils/utils.dart';

import '../database/main_database.dart';

class Task implements DbEntity{
  @override
  int id;
  String title;
  String? description;
  Color taskColor;
  DateTime? start;
  bool complete;
  bool showInfo = false;
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

  addProperty(String type) {
    if (properties.where((e) => e.type == type).isEmpty) {
      'isEmpty'.dpRed().print();
      TaskProperty.newObject(type)?.let((e) => properties.add(e));
    }
  }

  T? getProperty<T>() {
    return properties.whereType<T>().firstOrNull;
  }

  SubtaskListTaskProperty? getSubtasks() =>
      getProperty<SubtaskListTaskProperty>();

  // : '${formatTime.format(start).padLeft(5, '0')} - ${formatTime.format(end!).padLeft(5, '0')}';

  Task(
      {required this.title,
        this.id = -1,
      this.description,
      this.start,
      this.taskColor = MainTheme.accent,
      this.complete = false,
      this.showInfo = false,
      this.properties = const []}) {
    updateColors();
    properties = [];
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
        showInfo = json.extra?['show_info'] == 1,
        properties = parseProperties(parseList(json.extra?['properties'], (e)=>e as JsonMap)) {
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

  updateStatus() {
    var now = DateTime.now().millisecondsSinceEpoch;
    if (!complete &&
        (start?.copyWith(hour: 23, minute: 59).millisecondsSinceEpoch ?? now) <
            now) {
      start = null;
      DB.logs.add(CalendarLog(
          'Вы не выполнили задачу($title) - задача возвращена в общие задачи'));
      DB.tasks.update(this);
    }
  }

  @override
  JsonMap toDB() => {
        'title': title,
        'description': description,
        'complete': complete ? 1 : 0,
        'date': start?.let((e) => formatDate.format(e)),
        'time': start?.let((e) => formatTime.format(e)),
        'extra': jsonEncode(getExtra())
      };

  JsonMap getExtra() => {
        'properties': properties.map((e) => e.toJson()).toList(),
        'showInfo': showInfo ? 0 : 1
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
