import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:task_calendar/project_module/components/task_container.dart';
import 'package:task_calendar/project_module/database/project_database.dart';

import '../material_icons/material_icons.dart';
import '../models/task_data.dart';

class TaskItem extends StatefulWidget {
  final ProjectTaskData item;
  final double? size;
  final Offset Function(DragUpdateDetails)? onPanUpdate;
  final VoidCallback? onSelect;

  const TaskItem(this.item,
      {this.size, this.onPanUpdate, this.onSelect, super.key});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
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
        widget.item.editTitle = false;
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
            onTap: () {},
            onPanUpdate: (details) {
              widget.onPanUpdate?.let((e) {
                e(details);
              });
            },
            onPanEnd: (details) {
              ['save pan'].print();
              ProjectDatabase.tasks.update(widget.item.toDb(), widget.item.id);
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
          Text(
            widget.item.offset.toString(),
            style: getTextStyle().bodyMedium?.copyWith(fontSize: 5),
          ),
          widget.item.editTitle && !kIsMobile
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
                            widget.item.editTitle = false;
                          });
                          ProjectDatabase.tasks
                              .update(widget.item.toDb(), widget.item.id);
                        },
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 400),
                  style: getTextStyle().bodyMedium!.copyWith(
                        fontSize: widget.item.editTitle ? 12 : 10,
                        color: widget.item.editTitle
                            ? getColorScheme().primary
                            : getColorScheme().outline,
                      ),
                  child: GestureDetector(
                    onTap: () {
                      widget.onSelect?.let((e) => e());
                      setState(() {
                        widget.item.editTitle = true;
                      });
                    },
                    child: AutoSizeText(
                      widget.item.title,
                      textAlign: TextAlign.center,
                      // style: getTextStyle().bodyMedium?.copyWith(
                      //     color: widget.item.editTitle
                      //         ? getColorScheme().primary
                      //         : widget.item.statusColor),
                      minFontSize: 5,
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
