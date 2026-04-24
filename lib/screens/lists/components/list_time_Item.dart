import 'package:flutter/material.dart';
import 'package:qoiu_utils/components/common_text_builder.dart';
import 'package:qoiu_utils/qoiu_utills.dart';
import 'package:task_calendar/components/cloud_button.dart';
import 'package:task_calendar/components/task_widget.dart';
import 'package:task_calendar/database/task_queries.dart';
import 'package:task_calendar/modals/accept_modal.dart';
import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/utils/utils.dart';

import 'main_list_controller.dart';

class ListTimeItem extends StatefulWidget {
  final String time;
  final String date;
  final MainListController listController;
  final VoidCallback updateScreen;
  final VoidCallback update;
  final VoidCallback refreshDay;
  final Task? task;

  const ListTimeItem(this.date, this.time,
      {required this.listController,
      required this.updateScreen,
      required this.update,
      required this.refreshDay,
      this.task,
      super.key});

  @override
  State<ListTimeItem> createState() => _ListTimeItemState();
}

class _ListTimeItemState extends State<ListTimeItem> {
  bool delete = false;

  @override
  void initState() {
    super.initState();
  }

  Widget draggable({required Widget child}) => widget.task != null
      ? child
      : DragTarget(
          builder: (a, b, c) => Container(
              width: double.maxFinite,
              color: widget.listController.taskTime == null
                  ? Colors.transparent
                  : (widget.listController.selected ? Colors.red : Colors.green)
                      .withValues(alpha: 0.1),
              child: child),
          onWillAcceptWithDetails: (c) =>true,
          onMove: (v) {
            if (widget.task?.let((e) => TaskWidget.taskSize(e)) == null) {
              setState(() {});
            }
            if (widget.listController.taskTime
                    ?.let((e) => e.isTime(widget.time)) ??
                true) {
              return;
            }
            widget.listController.taskTime!.start =
                formatDateTime.parse('${widget.date} ${widget.time}');
            widget.updateScreen();
          },
          onLeave: (a) {
            widget.updateScreen();
          },
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        draggable(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextBuilder(widget.time).build()),
              const SizedBox(width: 10),
              widget.task?.let((task) => Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2)
                            .copyWith(right: 10),
                        child: Stack(
                          children: [
                            if (delete) ...{
                              TaskDeleteWidget(task)
                            } else ...{
                              TaskCompleteWidget(task),
                            },
                            task.getSubtasks()?.let((subtask) => Column(
                                      spacing: 10,
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(child: Icon(Icons.arrow_drop_down), onTap: (){
                                              // subtask.type
                                              setState(() {});
                                            },),
                                            dismissibleTask(task),
                                          ],
                                        ),
                                        ...subtask.subtasks.map((e) =>
                                            CloudButton(e.title, onTap: () {}))
                                      ],
                                    )) ??
                                dismissibleTask(task),
                          ],
                        ),
                      ))) ??
                  Container(),
              if (widget.listController.taskTime?.let(
                      (e) => e.isTime(widget.time) && e.isDate(widget.date)) ??
                  false) ...{
                Expanded(
                    child: TaskWidget(task: widget.listController.taskTime!))
              }
            ],
          ),
        ),
        Divider(
          color: getColorScheme().onPrimary,
          height: 1,
        )
      ],
    );
  }

  Dismissible dismissibleTask(Task task) {
    return Dismissible(
      key: Key(task.toDb().toString()),
      onDismissed: (v) async {
        await taskQueries.deleteTask(task.id!);
        widget.refreshDay();
      },
      confirmDismiss: (v) async {
        if (!delete) {
          task.complete = !task.complete;
          await taskQueries.update(task);
          TaskWidget.sizes.remove(task.id!);
          widget.refreshDay();
          return false;
        } else {
          var result =
              await AcceptModal(title: 'Удалить задачу ${task.title}').show();
          return result == true;
        }
      },
      onUpdate: (details) {
        if (!TaskWidget.sizes.containsKey(task.id)) {
          'no size'.print();
          widget.refreshDay();
        }
        if (delete != (details.direction == DismissDirection.endToStart)) {
          setState(() {
            delete = details.direction == DismissDirection.endToStart;
          });
        }
      },
      child: LongPressDraggable(
        feedback: Transform.scale(
          scale: 1,
          child: Opacity(opacity: 0.6, child: TaskWidget(task: task)),
        ),
        data: task,
        onDragStarted: () {
          widget.listController.taskTime = task.copyWith();
          widget.updateScreen();
        },
        onDragUpdate: (details) {
          // ['delete', details.localPosition.dx].print();
          delete = details.localPosition.dx > 0;
        },
        onDragCompleted: () async {
          await taskQueries.update(widget.listController.taskTime!);
          widget.listController.taskTime = null;
          widget.refreshDay();
        },
        onDraggableCanceled: (_, __) {
          widget.listController.taskTime = null;
          widget.updateScreen();
        },
        child: TaskWidget(
          task: task,
          applySize: true,
        ),
      ),
    );
  }
}
