import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_calendar/components/svg_button.dart';
import 'package:task_calendar/database/tasks_database.dart';
import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/screens/lists/components/title_controller.dart';
import 'package:task_calendar/screens/lists/models/custom_data.dart';
import 'package:task_calendar/utils/utils.dart';

import 'custom_painter.dart';

class MainCustomListScreen extends StatefulWidget {
  const MainCustomListScreen({super.key});

  @override
  State<MainCustomListScreen> createState() => _MainCustomListScreenState();
}

class _MainCustomListScreenState extends State<MainCustomListScreen>  with CustomListController implements DraggableActions
 {
  List<Task> tasks = [];
  TitleController? titleController;
  Task? draggableTask;

  @override
  onTaskClick(UiTask task) {}

  @override
  onTimeClick(UiTime time) async {
    setState(() {
      titleController = TitleController((title)async{
        try {
          await tasksDatabase.database.insert(
            'tasks',
            Task(title: title, start: time.time).toDb(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }catch(e){
          e.toString().dpRed().printLong();
        }
        titleController=null;
        updateDates();
      }, this);
    });
  }

  @override
  updateDates() async {
    'updateDates'.dpRed().printLong();
    // drawTaskHelper = DrawTaskHelper.fromToday(currentDate, tasks);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {});
    try {
      tasks = (await tasksDatabase.database.query('tasks'))
          .map((e) => Task.fromJson(e))
          .toList();
      tasks.toString().dpRed().printLong();
      drawTaskHelper = DrawTaskHelper.fromToday(currentDate, tasks);
      'updateDates'.dpRed().print();
    } on Exception catch (e) {
      e.toString().dpRed().printLong();
    } finally {
      setState(() {});
    }
  }

  @override
  onDragUpdate(DragUpdateDetails details){
    if(titleController?.draggableTask==null)return;
    var position = Offset(details.localPosition.dx, details.localPosition.dy-yOffset-50);
    var region = regions.entries.where((e)=>e.key.contains(position));
    region.firstOrNull?.value.toString().print();
    var time = tryToGetTime(region.firstOrNull?.value);
    time.toString().print();
    if(time != null){
      if(draggableTask!.start.hour==time.hour)return;
      draggableTask!.start=time;
      if(!tasks.contains(draggableTask)){
        tasks.add(draggableTask!);
      }
      drawTaskHelper = DrawTaskHelper.fromToday(currentDate, tasks);
      setState(() {});
    }
  }

  @override
  onDragEnd(DraggableDetails details) {
    draggableTask=null;
    setState(() {});
  }

  @override
  onDragStarted() {
    draggableTask??=titleController?.draggableTask;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
            onVerticalDragUpdate: (drag) {
              yOffset += drag.delta.dy;
              setState(() {});
            },
            onTapDown: (details) {
              onTap(Offset(details.localPosition.dx,
                  details.localPosition.dy - yOffset));
            },
            child: Container(
                color: Colors.transparent,
                width: double.maxFinite,
                height: double.maxFinite,
                child: CustomPaint(
                  painter: ListPainter(this),
                ))),
        Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.all(15),
          child: SvgButton('assets/svg/ic_plus.svg', () {
            setState(() {
              yOffset -= 100;
            });
          }),
        ),
        if(titleController!=null)...{
          TitleItem(titleController!)
        }
      ],
    );
  }

}
