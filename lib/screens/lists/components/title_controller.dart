import 'package:flutter/material.dart';
import 'package:task_calendar/components/task_widget.dart';
import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/screens/lists/components/main_button.dart';
import 'package:task_calendar/screens/lists/components/text_field.dart';
import 'package:task_calendar/screens/lists/models/custom_data.dart';
import 'package:task_calendar/utils/utils.dart';

class TitleItem extends StatefulWidget {
  final TitleController controller;
  const TitleItem(this.controller, {super.key});

  @override
  State<TitleItem> createState() => _TitleItemState();
}

class _TitleItemState extends State<TitleItem> {

  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  focus()async{
    try{
      FocusScope.of(context).requestFocus(focusNode);
    }catch(e){
      e.toString().dpRed().printLong();
      await Future.delayed(const Duration(milliseconds: 500));
      focus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        alignment: Alignment.topCenter,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: getColorScheme().onSecondary,
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CommonTextField(controller: textEditingController, focusNode: focusNode, title: 'Название',),
            const SizedBox(height: 10),
            Draggable(
              onDragUpdate: widget.controller.draggableActions.onDragUpdate,
              onDragStarted: () {
                widget.controller.draggableTask = Task(title: 'temp', start: DateTime.now());
                widget.controller.draggableActions.onDragStarted();
              },
              onDragEnd: widget.controller.draggableActions.onDragEnd,
              feedback: widget.controller.draggableTask!=null?Opacity(opacity:0.5, child: TaskWidget(task: widget.controller.draggableTask!)):Container(width: 200,height: 20,color: Colors.yellow),
              child: Container(
                width: 50, height: 50,color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            MainButton('Создать', ()=>widget.controller.onFinish(textEditingController.text))
          ],
        ),
      ),
    );
  }
}

class TitleController{
  Function(String title) onFinish;
  DraggableActions draggableActions;
  Task? draggableTask;

  TitleController(this.onFinish, this.draggableActions);
}