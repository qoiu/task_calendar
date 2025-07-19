import 'package:flutter/material.dart';
import 'package:qoiu_utils/components/common_text_builder.dart';
import 'package:qoiu_utils/qoiu_utills.dart';
import 'package:task_calendar/database/task_queries.dart';
import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/screens/lists/components/list_date_item.dart';
import 'package:task_calendar/screens/lists/components/list_time_Item.dart';
import 'package:task_calendar/screens/lists/components/update_inherited.dart';

import 'main_list_controller.dart';

class ListDateTimeItem extends StatefulWidget {
  final String date;
  final MainListController listController;
  final VoidCallback update;

  const ListDateTimeItem(this.date,
      {required this.listController, required this.update, super.key});

  @override
  State<ListDateTimeItem> createState() => _ListDateTimeItemState();
}

class _ListDateTimeItemState extends State<ListDateTimeItem> with UpdaterMixin {
  List<DayItems> generateItems = List.generate(
      16, (i) => DayItems("${(i + 8).toString().padLeft(2, '0')}:00"));

  List<Task> tasks = [];

  @override
  void initState() {
    updateController = widget.listController.refreshData;
    super.initState();
    'init: ${widget.date}'.dpBlue().print();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTasks();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  onUpdate() {
    'onUpdate'.dpRed().print();
    getTasks();
  }

  @override
  dispose(){
    super.dispose();
    'dispose: ${widget.date}'.dpRed().print();
  }

  getTasks() async {
    tasks = await taskQueries.getTasksAtDay(widget.date);
    'tasks(${widget.date}): ${tasks.map((e) => e.toDb())}'.print();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key(widget.date),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListDateItem(widget.date),
        ),
        ...generateItems.map((i) => ListTimeItem(widget.date,
              i.time,
              listController: widget.listController,
              update: ()=>setState(() {}),
              updateScreen: () {
                widget.update();
                setState(
                  () {},
                );
              },
              task: tasks.where((e) => e.time == i.time).firstOrNull, refreshDay: getTasks,
            )),
      ],
    );
  }
}

class DayItems {
  final String time;

  DayItems(this.time);
}
