import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:qoiu_utils/typedef.dart';
import 'package:task_calendar/database/skill_queries.dart';
import 'package:task_calendar/models/calendar_log.dart';
import 'package:task_calendar/models/skill_property.dart';
import 'package:task_calendar/models/task_property.dart';
import 'package:task_calendar/themes.dart';
import 'package:task_calendar/utils/utils.dart';
import 'dart:math' as math;

import '../database/log_queries.dart';

class SkillData {
  int? id;
  String title;
  String? description;
  Color skillColor;
  DateTime? endAt;
  int durationInDays;
  int? startDay;
  int lvl;
  int target;
  double lvlPercent;
  int progress;
  bool complete;
  AverageCounter averageCounter;
  List<SkillProperty> properties;

  int get currentTarget => (target + math.pow(1 + lvlPercent, lvl)).floor();

  Color get color => complete ? Colors.yellow : skillColor;
  GlobalKey taskKey = GlobalKey();

  late Color textColor = skillColor.oppositeColor();
  late Color extraColor = skillColor.oppositeExtraColor(0.05);

  updateColors() {
    textColor = color.oppositeColor();
    extraColor = color.oppositeExtraColor(0.05);
  }

  bool isTime(String time) =>
      endAt?.let((e) => formatTime.format(e) == time) ?? false;

  bool isDate(String date) =>
      endAt?.let((e) => formatDate.format(e) == date) ?? false;

  String get time =>
      endAt?.let((e) => formatTime.format(e).padLeft(5, '0')) ?? '';

  T? getProperty<T>() {
    return properties.whereType<T>().firstOrNull;
  }

  // : '${formatTime.format(start).padLeft(5, '0')} - ${formatTime.format(end!).padLeft(5, '0')}';

  int get daysLeft =>  endAt?.difference(DateTime.now()).inDays??-1;
  int get nextLvlTarget => (target+target*(lvl*lvlPercent)).floor();
  int get currentLvlTarget => (target+target*((lvl-1)*lvlPercent)).floor();

  SkillData(
      {required this.title,
      this.id,
      this.description,
      this.endAt,
      this.skillColor = MainTheme.accent,
      this.complete = false,
      required this.lvl,
      required this.lvlPercent,
      required this.target,
      this.textColor = MainTheme.textColor,
      this.durationInDays = 7,
      required this.averageCounter,
      this.properties = const [],
      this.progress = 0}) {
    updateColors();
  }

  static List<SkillProperty> parseProperties(List? json) {
    'isList: ${json is List}'.print();
    return json == null
        ? []
        : json
            .whereType<Map<String, dynamic>>()
            .nonNulls
            .map((e) => SkillProperty.fromJson(e))
            .nonNulls
            .toList();
  }

  checkSkllDate() {
    ['checkSkill Dates', title].print();
    ['endAt', endAt].print();
    var now = DateTime.now();
    if (endAt == null) {
      var wd = now.weekday - 1;
      if (wd != 0) {
        now = now.add(Duration(days: wd * -1));
      }
      endAt = now.add(Duration(days: durationInDays));
      endAt = endAt?.copyWith(hour: 23, minute: 59);
      logQueries.add(CalendarLog('Установлено новое время навыка($title) - ${formatDateTime.format(endAt!)}'));
      skillQueries.update(this);
    } else {
      StatisticSkill? statistic = getProperty<StatisticSkill>();
      ['now.millisecondsSinceEpoch > endAt!.millisecondsSinceEpoch', now.millisecondsSinceEpoch > endAt!.millisecondsSinceEpoch].print();
      while (now.millisecondsSinceEpoch > endAt!.millisecondsSinceEpoch) {
        String? message;
        if(statistic==null){
          statistic = SkillProperty.allSubtypes['statistic']!.buildNew() as StatisticSkill;
          properties.add(statistic);
        }
        if(progress>=nextLvlTarget){
          statistic.completed += 1;
          [title, 'complete - lvl up'].print();
          lvl+=1;
          message='Навык: ($title) - новый уровень($lvl) -';
        }else if(progress>=target) {
          statistic.completed += 1;
          [title, 'complete'].print();
          message='Навык: ($title) - выполнил базу -';
        }else{
          statistic.failed +=1;
          lvl-=1;
          message='Навык: ($title) - опустился до($lvl) -';
          [title, 'failed - lvl down'].print();
        }
        progress = 0;
        var oldEnd = endAt!.copyWith(millisecond: 0);
        endAt = endAt!.add(Duration(days: durationInDays));
        message?.let((e)=>logQueries.add(CalendarLog('$e${formatDateTime.format(endAt!)}', eventDate: oldEnd)));
        skillQueries.update(this);
      }
    }
  }

  SkillData.fromDB(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'].toString(),
        description = json['description'],
        endAt = formatDate.tryParse(json['date']),
        skillColor = json['color'] ?? MainTheme.accent,
        complete = json['complete'] == 1,
        progress = json['progress'],
        durationInDays = json['duration'],
        target = json['target'],
        lvl = json['lvl'],
        properties = parseProperties(jsonDecode(json['extra'])),
        averageCounter =
            AverageCounter(json['avg_count'] ?? 0, json['avg'] ?? 0),
        lvlPercent = json['lvlPercent'] {
    'date: ${json['date']}'.print();
    'time: ${json['time']}'.print();
    checkSkllDate();
    if (json['date'] != null && json['time'] != null) {
      var time = formatTime.parse(json['time']);
      endAt = formatDate
          .parse(json['date'])
          .copyWith(hour: time.hour, minute: time.minute);
      updateColors();
    }
  }

  // id INTEGER PRIMARY KEY,
  //     title TEXT NOT NULL,
  // description TEXT,
  //     complete INTEGER,
  // date TEXT,
  //     time TEXT,
  // progress INTEGER,
  //     duration INTEGER,
  // target INTEGER,
  //     lvl INTEGER,
  // lvlPercent REAL,
  //     extra TEXT
  Map<String, Object?> toDb() => {
        'title': title,
        'description': description,
        'complete': complete?1:0,
        'date': endAt?.let((e) => formatDate.format(e)),
        'time': endAt?.let((e) => formatTime.format(e)),
        'progress': progress,
        'duration': durationInDays,
        'target': target,
        'lvl': lvl,
        'lvlPercent': lvlPercent,
        'extra': jsonEncode(properties.map((e) => e.toJson()).toList())
      };

  @override
  String toString() {
    return 'Task{title: $title, start: ${endAt?.let((e) => formatDate.format(e))}}';
  }
}

class AverageCounter {
  double avg;
  int count;

  AverageCounter(this.count, this.avg);

  increase(int value) {
    count++;
    avg = avg + (value - avg) / count;
  }
}
