import 'package:flutter/material.dart';
import 'package:qoiu_utils/components/common_text_builder.dart';
import 'package:qoiu_utils/qoiu_utills.dart';
import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/utils/utils.dart';

const _taskPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 7);

class TaskWidget extends StatelessWidget {
  final Task task;
  final bool expand;
  final bool applySize;

  static Map<int,Size> sizes= {};
  static Size? taskSize(Task task) => task.id!=null?sizes[task.id]:null;

  const TaskWidget({super.key, required this.task, this.expand=true, this.applySize=false});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(applySize && task.id!=null) {
         task.taskKey.size()?.let((e){
           TaskWidget.sizes[task.id!] ??= e;
        });
      }
    });
    return Container(
      width: expand?double.maxFinite:null,
      key: applySize?task.taskKey:null,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(colors: [
            task.color,
            task.extraColor,
            task.color
          ], stops: const [
            0.2,
            0.5,
            0.8,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Padding(
        padding: _taskPadding,
        child: Row(
          children: [
            if (task.complete) ...{
              const Icon(
                  Icons.star,
                  size: 20,
                  color: Colors.orange
              )
            },
            Expanded(
                child: TextBuilder('${task.title} ${TaskWidget.taskSize(task)}')
                    .color(task.complete?Colors.orange:task.color.oppositeColor())
                .maxLines(2)
                .ellipsis()
                    .build()),
          ],
        ),
      ),
    );
  }
}

class TaskDeleteWidget extends StatelessWidget {
  final Task task;
  const TaskDeleteWidget(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: TaskWidget.taskSize(task)?.width,
      height: TaskWidget.taskSize(task)?.height,
      decoration: BoxDecoration(
          color: Colors.red.withAlpha(100),
          borderRadius: BorderRadius.circular(50)),
      child: Padding(
        padding: _taskPadding,
        child: Container(
          width: double.maxFinite,
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              Expanded(child: TextBuilder("Удалить").alignEnd().color(Colors.red).build()),
              const Icon(
                Icons.delete,
                size: 20,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskCompleteWidget extends StatelessWidget {
  final Task task;

  const TaskCompleteWidget(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: TaskWidget.taskSize(task)?.width,
      height: TaskWidget.taskSize(task)?.height,
      decoration: BoxDecoration(
          color: task.complete ? task.taskColor : Colors.yellow.withAlpha(100),
          borderRadius: BorderRadius.circular(50)),
      child: Padding(
        padding: _taskPadding,
        child: SizedBox(
          width: double.maxFinite,
          child: Row(
            children: [
              task.complete
                  ? Icon(
                      Icons.star_border,
                      size: 20,
                      color: task.taskColor.oppositeColor(),
                    )
                  : const Icon(
                      Icons.star,
                      size: 20,
                      color: Colors.orange
                    ),
              Expanded(
                child: TextBuilder((task.complete ? "Восстановить" : "Выполнить") + TaskWidget.taskSize(task).toString())
                    .color(task.complete
                        ? task.taskColor.oppositeColor()
                        : Colors.orange)
                    .build(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
