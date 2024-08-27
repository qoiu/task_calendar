import 'package:flutter/material.dart';
import 'package:task_calendar/components/svg_button.dart';
import 'package:task_calendar/database/tasks_database.dart';
import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/screens/lists/components/list_date_time_item.dart';
import 'package:task_calendar/screens/lists/models/custom_data.dart';
import 'package:task_calendar/utils/utils.dart';

import 'custom_painter.dart';

class MainCustomListScreen extends StatefulWidget {
  const MainCustomListScreen({super.key});

  @override
  State<MainCustomListScreen> createState() => _MainCustomListScreenState();
}

class _MainCustomListScreenState extends State<MainCustomListScreen> {
  CustomListController offsetController = CustomListController();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    offsetController.updateDate = updateDates;
  }

  updateDates() async {
    'updateDates'.dpRed().printLong();
    try {
      // var id = await tasksDatabase.database.insert(
      //     'tasks',
      //     Task(title: 'test', start: DateTime.now(), end: DateTime.now())
      //         .toDb(),
      //     conflictAlgorithm: ConflictAlgorithm.replace);
      // 'create $id'.dpGreen().print();
      tasks = (await tasksDatabase.database.query('tasks'))
          .map((e) => Task.fromJson(e))
          .toList();
      tasks.toString().dpRed().printLong();
      'updateDates'.dpRed().print();
    } on Exception catch (e) {
      e.toString().dpRed().printLong();
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
            onVerticalDragUpdate: (drag) {
              offsetController.yOffset += drag.delta.dy;
              setState(() {});
            },
            child: Container(
                color: Colors.transparent,
                width: double.maxFinite,
                height: double.maxFinite,
                child: CustomPaint(
                  painter: ListPainter(
                      datesHelper: DrawTaskHelper(dates)List.generate(50, (i) {
                        return ListDateTimeItem(formatDate.format(
                            offsetController.currentDate
                                .add(Duration(days: i - 1))));
                      }),
                      tasks: tasks,
                      controller: offsetController),
                ))),
        Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.all(15),
          child: SvgButton('assets/svg/ic_plus.svg', () {
            setState(() {
              offsetController.yOffset -= 100;
            });
          }),
        )
      ],
    );
  }
}
