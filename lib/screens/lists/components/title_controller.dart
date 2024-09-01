import 'package:flutter/material.dart';
import 'package:task_calendar/screens/lists/components/main_button.dart';
import 'package:task_calendar/screens/lists/components/text_field.dart';
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
            MainButton('Создать', ()=>widget.controller.onFinish(textEditingController.text))
          ],
        ),
      ),
    );
  }
}

class TitleController{
  Function(String title) onFinish;

  TitleController(this.onFinish);
}