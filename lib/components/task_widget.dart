import 'package:flutter/material.dart';
import 'package:task_calendar/components/text_builder.dart';
import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/utils/utils.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  const TaskWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: task.color,
        borderRadius: BorderRadius.circular(50)
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: TextBuilder(task.title).color(task.color.oppositeColor()).build(),
      ),
    );
  }
}
