import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:qoiu_utils/extensions/text_style_extensions.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'components/task_container.dart';
import 'material_icons.dart';
import 'models/task_data.dart';

class TaskItem extends StatefulWidget {
  final ProjectTaskData item;
  final double? size;
  final Offset Function(DragUpdateDetails)? onPanUpdate;

  const TaskItem(this.item, {this.size, this.onPanUpdate, super.key});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool canEdit = false;
  FocusNode focusNode = FocusNode();
  final TextEditingController titleController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    titleController.text = widget.item.title;
    focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.removeListener(_handleFocusChange);
    titleController.dispose();
    focusNode.dispose();
  }

  void _handleFocusChange() {
    if (!focusNode.hasFocus) {
      widget.item.title = titleController.text;
      setState(() {
        canEdit = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size?.let((e) => e * 1.3),
      alignment: Alignment.center,
      child: Column(
        children: [
          GestureDetector(
            onTap: (){

            },
            onPanUpdate: (details){
              widget.onPanUpdate?.let((e){
                e(details);
              });
            },
            child: TaskContainer(
              width: widget.size?.let((e) => e * 0.8),
              height: widget.size?.let((e) => e * 0.8),
              thin: widget.size?.let((e) => e / 30) ?? 5,
              color: widget.item.statusColor,
              padding: EdgeInsets.zero,
              child: MaterialIcons.fromInt(
                widget.item.icon,
                size: widget.size?.let((e) => e * 0.6),
                color: widget.item.statusColor,
              ),
            ),
          ),
          canEdit
              ? Expanded(
                  child: FittedBox(
                    child: Container(
                      height: 60,
                      width: 250,
                      child: TextField(
                        controller: titleController,
                        style: getTextStyle().titleLarge,
                        autofocus: true,
                        focusNode: focusNode,
                        onSubmitted: (s) {
                          widget.item.title = s;
                          setState(() {
                            canEdit = false;
                          });
                        },
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        canEdit = true;
                      });
                    },
                    child: AutoSizeText(
                      widget.item.title,
                      textAlign: TextAlign.center,
                      style: getTextStyle().bodyMedium?.copyWith(color: widget.item.statusColor),
                      minFontSize: 5,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
