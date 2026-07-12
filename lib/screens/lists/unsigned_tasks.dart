import 'package:flutter/material.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:task_calendar/components/task_widget.dart';
import 'package:task_calendar/database/main_database.dart';
import 'package:task_calendar/modals/create_task/create_task_modal.dart';
import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/screens/lists/components/main_list_controller.dart';
import 'package:task_calendar/screens/lists/components/update_inherited.dart';

class UnsignedTasksController {
  bool showPlan = false;

  double offset = 2500;
  late AnimationController _animationController;
  late Animation<double> _animation;
  VoidCallback update;
  UpdateController updateDataController = UpdateController();
  List<Task> tasks = [];

  UnsignedTasksController({required this.update});

  hide(double height) {
    showPlan = false;
    double modifier = 1 - (offset / height);
    offset = height;
    _animationController.animateTo(height,
        duration: Duration(milliseconds: (500 * modifier).toInt()));
  }

  show() {
    showPlan = true;

    offset = 0;
    _animationController.animateTo(0,
        duration: const Duration(milliseconds: 500));
    update();
  }

  createTask() async {
    var result = await const CreateTaskModal().show();
    if (result == true) {
      getTasks();
    }
  }

  getTasks() async {
    await DB.tasks.checkOldTasks();
    tasks = await DB.tasks.getTasksUnsigned();
    tasks.insert(0, Task(title: 'test'));
    updateDataController.update();
  }
}

class UnsignedTasks extends StatefulWidget {
  final VoidCallback update;
  final UnsignedTasksController controller;
  final MainListController listController;

  const UnsignedTasks(
      {super.key,
      required this.update,
      required this.controller,
      required this.listController});

  @override
  State<UnsignedTasks> createState() => _UnsignedTasksState();
}

const _hideCoef = 0.3;

class _UnsignedTasksState extends State<UnsignedTasks>
    with SingleTickerProviderStateMixin, UpdaterMixin {
  List<Task> get tasks => widget.controller.tasks;

  double get offset => widget.controller.offset;

  AnimationController get _animationController =>
      widget.controller._animationController;

  Animation<double> get _animation => widget.controller._animation;

  @override
  UpdateController get updateController =>
      widget.controller.updateDataController;

  @override
  void initState() {
    super.initState();
    widget.controller._animationController =
        AnimationController.unbounded(vsync: this);
    widget.controller._animation = widget.controller._animationController;
    widget.controller.getTasks();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.controller._animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, widget.controller._animation.value),
            child: child,
          );
        },
        child: GestureDetector(
          onVerticalDragUpdate: (drag) {
            if (!widget.controller.showPlan) return;
            if (widget.controller.offset >
                MediaQuery.of(context).size.height * _hideCoef) {
              'more than half'.dpRed().print();
              widget.controller.hide(MediaQuery.of(context).size.height);
              return;
            }
            widget.controller.offset += drag.delta.dy;
            ['offset', offset].print();
            if ((_animation.value - offset).abs() > 3) {
              _animationController.value = offset;
            }
            if (offset < 0) {
              widget.controller.offset = 0;
            }
          },
          onVerticalDragEnd: (a) {
            if (widget.controller.offset <
                MediaQuery.of(context).size.height * _hideCoef) {
              widget.controller.show();
            }
          },
          child: Transform.translate(
            offset: Offset(0, offset),
            child: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              color: Colors.white.withValues(alpha: 0.7),
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      GestureDetector(
                        onTap: widget.controller.getTasks,
                        child: Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: getColorScheme().primary,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Icon(Icons.add),
                        ),
                      ),
                      ...tasks.map((task) => Draggable(
                            data: task,
                            feedback: TaskWidget(task: task),
                            onDragStarted: () {
                              widget.controller
                                  .hide(MediaQuery.of(context).size.height);
                              widget.listController.taskTime = task;
                              // widget.update();
                            },
                            onDragCompleted: () {
                              widget.listController.taskTime?.let((task) {
                                var task = widget.listController.taskTime!;
                                if (task.id != -1) {
                                  DB.tasks.update(task);
                                } else {
                                  DB.tasks.add(task);
                                }
                              });
                              // widget.listController.taskTime = null;
                              widget.listController.refreshData.update();
                              widget.update();
                              // widget.controller.getTasks();
                            },
                            onDraggableCanceled: (_, __) {
                              widget.listController.taskTime = null;
                              widget.controller.show();
                              widget.update();
                            },
                            child: IntrinsicWidth(
                                child: TaskWidget(
                              task: task,
                              expand: false,
                            )),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
