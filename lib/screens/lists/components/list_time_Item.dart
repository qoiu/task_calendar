import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qoiu_utils/components/common_text_builder.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:task_calendar/components/cloud_button.dart';
import 'package:task_calendar/components/task_widget.dart';
import 'package:task_calendar/database/main_database.dart';
import 'package:task_calendar/modals/accept_modal.dart';
import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/utils/extensions/date_time_extension.dart';
import 'package:task_calendar/utils/utils.dart';

import 'main_list_controller.dart';

class ListTimeItem extends StatefulWidget {
  final String time;
  final String date;
  final MainListController listController;
  final VoidCallback updateScreen;
  final VoidCallback update;
  final VoidCallback refreshDay;
  final Function(Task) addTask;
  final Task? task;

  const ListTimeItem(this.date, this.time,
      {required this.listController,
      required this.updateScreen,
      required this.update,
      required this.refreshDay,
      required this.addTask,
      this.task,
      super.key});

  @override
  State<ListTimeItem> createState() => _ListTimeItemState();
}

class _ListTimeItemState extends State<ListTimeItem> {
  bool delete = false;
  double deleteDrag = 0;
  double completeDrag = 0;

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
                  : (widget.listController.selected
                          ? getColorScheme().error
                          : getColorScheme().primary)
                      .withValues(alpha: 0.1),
              child: child),
          onWillAcceptWithDetails: (c) {
            widget.updateScreen();
            return true;
          },
          onAcceptWithDetails: (c) {
            var receiveTask = (c as DragTargetDetails).data as Task;
            // task.time = widget.time
            // task.time = '';
            widget.listController.taskTime?.let((task) {
              ['onAcceptWithDetails', (receiveTask).toDB()].print();
              ['onAcceptWithDetails - true', (task).toDB()].print();
              ['sameDate', task.start?.sameDay(receiveTask.start)].print();
              if (task.start?.sameDay(receiveTask.start) == false) {
                widget.addTask(task);
              }
            });
            // DB.tasks.update(task);
            // widget.listController.taskTime?.let((task){
            //   if(task.id!=null){
            //   }else{
            //     DB.tasks
            //         .add(widget.listController.taskTime!);
            //   }
            // });
            // widget.listController.taskTime = null;
            // widget.listController.refreshData.update();
            // widget.update();
            // widget.controller.getTasks();
            widget.updateScreen();
          },
          onMove: (v) {
            var task = (v as DragTargetDetails).data as Task;
            ['onMove', (task).toDB()].print();
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
        // DottedLine(
        //   direction: Axis.horizontal,
        //   alignment: WrapAlignment.center,
        //   lineLength: MediaQuery.widthOf(context),
        //   lineThickness: 0.2,
        //   dashLength: 4.0,
        //   dashColor: getColorScheme().outline,
        //   dashRadius: 0.0,
        //   dashGapLength: 8.0,
        //   dashGapColor: Colors.transparent,
        //   dashGapRadius: 0.0,
        // ),
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
                        child: LayoutBuilder(
                          builder: (context,constraints) {
                            var size = constraints.biggest;
                            return Stack(
                              alignment: AlignmentGeometry.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width:
                                        deleteDrag * size.width,
                                    // Clip.hardEdge на внешнем контейнере обрежет всё, что не влезает в его width
                                    clipBehavior: Clip.hardEdge,
                                    decoration: const BoxDecoration(),
                                    // Нужно для работы clipBehavior в Container
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        physics: const NeverScrollableScrollPhysics(), // Запрещаем крутить пальцем
                                        child:Row(
                                          children: [
                                            // Icon(Icons.arrow_back_ios, color: getColorScheme().outline),
                                            Icon(Icons.check, color: task.complete?getColorScheme().outline:getColorScheme().primary,),
                                          ],
                                        )),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: min(50,
                                        completeDrag * size.width),
                                    // Clip.hardEdge на внешнем контейнере обрежет всё, что не влезает в его width
                                    clipBehavior: Clip.hardEdge,
                                    alignment: Alignment.centerRight,
                                    decoration: const BoxDecoration(),
                                    // Нужно для работы clipBehavior в Container
                                    child: SizedBox(
                                      width: 60,
                                      child: Stack(
                                        children: [
                                          // Positioned(right: 30, child: Icon(Icons.check, color: getColorScheme().primary,)),
                                          Positioned(right: 0, child: Icon(Icons.delete, color: getColorScheme().error),),
                                          // Positioned(right: 0, child: Icon(Icons.arrow_forward_ios, color: getColorScheme().outline,)),
                                          const SizedBox(width: 100, height: 25)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                task.getSubtasks()?.let((subtask) => Column(
                                          spacing: 10,
                                          children: [
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  child:
                                                      Icon(Icons.arrow_drop_down),
                                                  onTap: () {
                                                    // subtask.type
                                                    setState(() {});
                                                  },
                                                ),
                                                dismissibleTask(task),
                                              ],
                                            ),
                                            ...subtask.subtasks.map((e) =>
                                                CloudButton(e.title, onTap: () {}))
                                          ],
                                        )) ??
                                    dismissibleTask(task),
                              ],
                            );
                          }
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
          color: getColorScheme().outline,
          height: 1,
        )
      ],
    );
  }

  Dismissible dismissibleTask(Task task) {
    return Dismissible(
      key: Key(task.toDB().toString()),
      onDismissed: (v) async {
        await DB.tasks.delete(task.id!);
        widget.refreshDay();
      },
      confirmDismiss: (v) async {
        clearDrag();
        if (!delete) {
          task.complete = !task.complete;
          await DB.tasks.update(task);
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
        if (details.direction == DismissDirection.startToEnd) {
          setState(() {
            completeDrag = 0;
            deleteDrag = details.progress;
          });
        }else if(details.direction == DismissDirection.endToStart){
          setState(() {
            deleteDrag = 0;
            completeDrag = details.progress;
          });
        }else{
          clearDrag();
        }

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
        feedback: Container(),
        data: task,
        onDragStarted: () {
          clearDrag();
          widget.listController.taskTime = task.copyWith();
          widget.updateScreen();
        },
        onDragUpdate: (details) {
          ['delete', details.localPosition.dx].print();
          delete = details.localPosition.dx > 0;
          deleteDrag = details.localPosition.dx;
        },
        onDragCompleted: () async {
          await DB.tasks.update(widget.listController.taskTime!);
          widget.listController.taskTime = null;
          widget.refreshDay();
        },
        onDraggableCanceled: (_, __) {
          widget.listController.taskTime = null;
          widget.updateScreen();
        },
        child: GestureDetector(
          onTap: (){
            ['tap'].print();
            setState(() {
              task.showInfo = !task.showInfo;
            });
            DB.tasks.update(task);
          },
          child: TaskWidget(
            task: task,
            applySize: true,
          ),
        ),
      ),
    );
  }

  void clearDrag() {

    setState(() {
      completeDrag = 0;
      deleteDrag = 0;
    });
  }
}
