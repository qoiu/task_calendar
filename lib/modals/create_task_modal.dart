import 'package:flutter/cupertino.dart';
import 'package:task_calendar/database/task_queries.dart';
import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/screens/lists/components/main_button.dart';
import 'package:task_calendar/screens/lists/components/text_field.dart';
import 'package:task_calendar/utils/statefull_modal.dart';

import 'bottom_sheet_template.dart';

class CreateTaskModal extends StatefulModal {
  const CreateTaskModal({super.key});

  @override
  State<CreateTaskModal> createState() => _CreateTaskModalState();

  @override
  String get tag => 'createTaskModal';
}

class _CreateTaskModalState extends State<CreateTaskModal> {

  TextEditingController titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BottomSheetTemplate(
        tag: widget.tag,
        title: 'Поставить задачу',
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextField(controller: titleController),
            MainButton('Создать', ()async{
              await taskQueries.add(Task(title: titleController.text));
              Navigator.of(context).pop(true);
            })
          ],
        ));
  }
}
