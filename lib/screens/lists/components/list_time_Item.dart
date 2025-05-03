import 'package:flutter/material.dart';
import 'package:task_calendar/components/task_widget.dart';
import 'package:task_calendar/components/text_builder.dart';
import 'package:task_calendar/database/task_queries.dart';
import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/utils/utils.dart';

import 'main_list_controller.dart';

class ListTimeItem extends StatelessWidget {
  final String time;
  final String date;
  final MainListController listController;
  final VoidCallback update;
  final VoidCallback refreshDay;
  final Task? task;

  const ListTimeItem(this.date, this.time,
      {required this.listController,
      required this.update,
      required this.refreshDay,
      this.task,
      super.key});

  Widget draggable({required Widget child}) => task != null
      ? child
      : DragTarget(
          builder: (a, b, c) => Container(
              width: double.maxFinite,
              color: listController.taskTime == null
                  ? Colors.transparent
                  : (listController.selected ? Colors.red : Colors.green)
                      .withValues(alpha: 0.2),
              child: child),
          onWillAcceptWithDetails: (c) {
            'onWillAcceptWithDetails'.print();
            return true;
          },
          onMove: (v) {
            if (listController.taskTime?.let((e) => e.isTime(time)) ?? true)
              return;
            'updateTime: $time'.print();
            listController.taskTime!.start = formatDateTime.parse('$date $time');
            'updateTime: ${listController.taskTime!.start}'.dpGreen().print();
            update();
          },
          onLeave: (a) {
            update();
          },
        );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            draggable(
              child: Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: TextBuilder(time).build()),
                  const SizedBox(width: 10),
                  task?.let((task) => Expanded(
                          child: Dismissible(
                            key: Key(task.toDb().toString()),
                            onDismissed: (v)async{
                              await taskQueries.deleteTask(task.id!);
                              refreshDay();
                            },
                            child: LongPressDraggable(
                                feedback: Transform.scale(
                                  scale: 0.8,
                                  child: Opacity(
                                      opacity: 0.6,
                                      child: TaskWidget(task: task)),
                                ),
                              data: task,
                              onDragStarted: (){
                                  listController.taskTime = task.copyWith();
                                  update();
                              },
                              onDragCompleted: ()async{
                                  await taskQueries.update(listController.taskTime!);
                                  listController.taskTime = null;
                                  refreshDay();
                              },
                              onDraggableCanceled: (_,__){
                                listController.taskTime = null;
                                update();
                              },
                                child: TaskWidget(task: task),
                            ),
                          ))) ??
                      Container(),
                  if (listController.taskTime?.let((e) => e.isTime(time)) ??
                      false) ...{
                    Expanded(child: TaskWidget(task: listController.taskTime!))
                  }
                ],
              ),
            ),
            Divider(
              color: getColorScheme().onPrimary,
              height: 1,
            )
          ],
        ),
      ],
    );
  }
}
