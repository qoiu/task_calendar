import 'package:flutter/material.dart';
import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/utils/utils.dart';

mixin CustomListController {
  double yOffset = 0.0;
  DateTime currentDate = DateTime.now();
  DrawTaskHelper drawTaskHelper = DrawTaskHelper.fromToday(DateTime.now());
  Map<Rect, dynamic> regions = {};

  onTap(Offset point) {
    point.toString().dpYellow().print();
    var contain = regions.entries.where((e) => e.key.contains(point));
    contain.map((e) => e.value.toString()).join(",").dpGreen().print();
    var region = contain.firstOrNull?.value;
    if (region is UiTask) {
      region.task.title.dpRed().print();
      onTaskClick(region);
    }
    if (region is UiTime) {
      region.title.dpRed().print();
      region.parent.title.dpRed().print();
      onTimeClick(region);
    }
  }

  updateDates() {}

  onTaskClick(UiTask task) {}
  onTimeClick(UiTime time) {}
}

class DrawTaskHelper {
  List<UiDate> dates;

  DrawTaskHelper(this.dates);

  DrawTaskHelper.fromToday(DateTime today, [List<Task>? tasks])
      : dates = List.generate(
            20,
            (i) => UiDate(
                formatDate.format(today.add(Duration(days: i - 1))),
                List.generate(
                    24, (i) => UiTime('${i.toString().padLeft(2, '0')}:00')))) {
    dates.forEach((date) {
      date.times.forEach((time) {
        time.parent = date;
      });
    });
    if (tasks != null) {
      tasks.forEach((task) {
        var date = formatDate.format(task.start);
        var time = formatTime.format(task.start);
        dates
            .where((e) => e.title == date)
            .firstOrNull
            ?.times
            .where((t) => t.title == time)
            .firstOrNull
            ?.let((t) {
          t.tasks.add(UiTask(task));
        });
      });
    }
  }
}

class UiDate {
  String title;
  List<UiTime> times;

  DateTime get date => formatDate.parse(title);
  UiDate(this.title, this.times);
}

class UiTime {
  String title;
  late UiDate parent;
  List<UiTask> tasks = List<UiTask>.empty(growable: true);

  DateTime get time => DateTime(parent.date.year, parent.date.month, parent.date.day, formatTime.parse(title).hour,  formatTime.parse(title).minute);

  UiTime(this.title, [List<Task>? defaultTasks]) {
    if (defaultTasks != null) {
      tasks = defaultTasks.map((e) => UiTask(e)).toList();
    }
  }
}

class UiTask {
  Task task;

  UiTask(this.task);
}
