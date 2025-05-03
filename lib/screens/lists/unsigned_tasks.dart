import 'package:flutter/material.dart';
import 'package:task_calendar/components/task_widget.dart';
import 'package:task_calendar/database/task_queries.dart';
import 'package:task_calendar/modals/create_task_modal.dart';
import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/models/task_property.dart';
import 'package:task_calendar/screens/lists/components/main_list_controller.dart';
import 'package:task_calendar/utils/utils.dart';

class UnsignedTasks extends StatefulWidget {
  final bool showPlan;
  final VoidCallback update;
  final VoidCallback hideScreen;
  final MainListController listController;

  const UnsignedTasks(
      {super.key,
      required this.showPlan,
      required this.update,
      required this.hideScreen,
      required this.listController});

  @override
  State<UnsignedTasks> createState() => _UnsignedTasksState();
}

class _UnsignedTasksState extends State<UnsignedTasks> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    getTasks();
  }

  getTasks() async {
    tasks = await taskQueries.getTasksUnsigned();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      alignment: Alignment.bottomRight,
      scale: widget.showPlan ? 1 : 0,
      duration: const Duration(milliseconds: 800),
      child: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: Colors.white.withValues(alpha: 0.7),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                GestureDetector(
                  onTap: ()async{
                    var result = await const CreateTaskModal().show();
                    if(result==true){
                      getTasks();
                    }
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: getColorScheme().primary,
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
                ...tasks.map((task) => Draggable(
                      data: task,
                      feedback: TaskWidget(task: task),
                      onDragStarted: () {
                        widget.hideScreen();
                        widget.listController.taskTime = task;
                        widget.update();
                      },
                      onDragCompleted: () {
                        taskQueries.update(widget.listController.taskTime!);
                        widget.listController.taskTime = null;
                        widget.listController.refreshData.update();
                        widget.update();
                        getTasks();
                      },
                      onDraggableCanceled: (_, __) {
                        widget.listController.taskTime = null;
                        widget.update();
                      },
                      child: IntrinsicWidth(child: TaskWidget(task: task)),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
