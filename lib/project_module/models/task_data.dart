import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:qoiu_utils/typedef.dart';

import '../project_main_theme.dart';

class ProjectTaskData {
  final int id;
  String title;
  final int icon;
  Offset offset;
  final TaskStatus status;

  ProjectTaskData({
    required this.id,
    required this.title,
    required this.icon,
    this.offset = Offset.zero,
    this.status = TaskStatus.unknown,
  });

  Color get statusColor {
    switch (status) {
      case TaskStatus.unknown:
        return getColorScheme().outline;
      case TaskStatus.inProcess:
        return ProjectMainTheme.progress;
      case TaskStatus.success:
        return getColorScheme().primary;
      case TaskStatus.failed:
        return getColorScheme().error;
    }
  }

  ProjectTaskData.fromDB(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'].toString(),
        icon = json['icon'],
        offset = Offset(json['offsetX'], json['offsetY']),
        status = parseEnum(TaskStatus.values, json['status']);

  JsonMap toDb() => {
    'title': title,
    'icon': icon,
    'offsetX': offset.dx,
    'offsetY': offset.dy,
    'status': status.name
  };
}

enum TaskStatus { unknown, inProcess, success, failed }
