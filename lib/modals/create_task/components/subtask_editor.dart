import 'package:flutter/material.dart';
import 'package:qoiu_utils/components/common_text_builder.dart';
import 'package:task_calendar/components/cloud_button.dart';
import 'package:task_calendar/models/task_property.dart';
import 'package:task_calendar/screens/lists/components/text_field.dart';
import 'package:task_calendar/utils/utils.dart';

import '../../../models/task.dart';

class SubtaskEditor extends StatefulWidget {
  final SubtaskListTaskProperty sublist;

  const SubtaskEditor(this.sublist, {super.key});

  @override
  State<SubtaskEditor> createState() => _SubtaskEditorState();
}

class _SubtaskEditorState extends State<SubtaskEditor> {
  List<TextEditingController> controllers = [];

  SubtaskListTaskProperty get sublist => widget.sublist;
  TextEditingController newItemController = TextEditingController();
  FocusNode lastItemFocus = FocusNode();

  @override
  void initState() {
    controllers = sublist.subtasks.map((e)=>TextEditingController(text: e.title)).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 10,
        children: [
          TextBuilder('Подзадачи').build(),
          ...controllers.indexed.map((e) =>
              Row(
                spacing: 10,
                children: [
                  Expanded(
                      child: CommonTextField(
                        controller: e.$2,
                        focusNode: e.$2.lastOf(controllers)?lastItemFocus:null,
                        onSubmitted: (text) {
                          sublist.subtasks[e.$1].title = text;
                        },
                      )),
                    CloudButton(
                      'delete',
                      onTap: () {
                        controllers.remove(e.$2);
                        sublist.subtasks.removeAt(e.$1);
                        setState(() {});
                      },
                    )
                ],
              )),
          CommonTextField(
            hint: 'Новый элемент',
            controller: newItemController,
            onSubmitted: (text) {
              sublist.subtasks.add(Subtask(title: text));
              controllers.add(newItemController);
              newItemController = TextEditingController();
              setState(() {});

              WidgetsBinding.instance.addPostFrameCallback((_) {
                FocusScope.of(context).requestFocus(lastItemFocus);
              });
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
