import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:qoiu_utils/qoiu_utils.dart';

import '../task_main_theme.dart';

class TaskData {
  final int id;
  String title;
  final int icon;
  Offset offset;
  final TaskStatus status;

  TaskData({
    required this.id,
    required this.title,
    required this.icon,
    this.offset = Offset.zero,
    this.status = TaskStatus.unknown,
  });


  Color get statusColor {
    switch(status){
      case TaskStatus.unknown: return getColorScheme().outline;
      case TaskStatus.inProcess: return TaskMainTheme.progress;
      case TaskStatus.success: return getColorScheme().primary;
      case TaskStatus.failed: return getColorScheme().error;
    }
  }
}

enum TaskStatus { unknown, inProcess, success, failed }
