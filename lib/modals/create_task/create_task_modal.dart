import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:qoiu_utils/qoiu_utills.dart';
import 'package:qoiu_utils/statefull_modal.dart';
import 'package:qoiu_utils/typedef.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:task_calendar/components/cloud_button.dart';
import 'package:task_calendar/database/task_queries.dart';
import 'package:task_calendar/modals/create_task/components/subtask_editor.dart';
import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/models/task_property.dart';
import 'package:task_calendar/screens/lists/components/main_button.dart';
import 'package:task_calendar/screens/lists/components/text_field.dart';

import '../bottom_sheet_template.dart';

class CreateTaskModal extends StatefulModal {
  final Task? task;

  const CreateTaskModal({this.task, super.key});

  @override
  State<CreateTaskModal> createState() => _CreateTaskModalState();

  @override
  String get tag => 'createTaskModal';
}

class _CreateTaskModalState extends State<CreateTaskModal> {
  final PageController pageController = PageController();

  TextEditingController titleController = TextEditingController();
  late Task task;

  @override
  void initState() {
    task = widget.task ?? Task(title: '');
    super.initState();
  }

  List<_CreationItem> widgets = [
    _CreationItem(
        'subtask', 'Список', (e) => SubtaskEditor(e as SubtaskListTaskProperty))
  ];

  @override
  Widget build(BuildContext context) {
    return BottomSheetTemplate(
        tag: widget.tag,
        padding: const EdgeInsets.only(bottom: 20),
        Column(
          children: [
            SmoothPageIndicator(
              controller: pageController,
              count: 2 + task.properties.length,
              effect: const ExpandingDotsEffect(),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: PageView(
                controller: pageController,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextField(controller: titleController, onSubmitted: (e){
                          task.title = e;
                        },),
                        const SizedBox(height: 10),
                        MainButton('Создать', () async {
                          await taskQueries
                              .add(task);
                          Navigator.of(context).pop(true);
                        })
                      ],
                    ),
                  ),
                  ...task.properties.map((e) {
                    return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: widgets
                                .where((w) => e.type == w.type)
                                .firstOrNull
                                ?.let((w) => w.builder(e)));
                  }),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                              children: widgets
                                  .map((e) => CloudButton(e.title, onTap: () {
                                        task.addProperty(e.type);
                                        [
                                          'properties',
                                          task.properties
                                              .map((e) => e.type)
                                              .toString()
                                        ].print();
                                        setState(() {});
                                      }))
                                  .toList())
                        ],
                      ))
                ],
              ),
            ),
          ],
        ));
  }
}

class _CreationItem {
  final String title;
  final String type;
  final Widget Function(TaskProperty) builder;

  _CreationItem(this.type, this.title, this.builder);
}
