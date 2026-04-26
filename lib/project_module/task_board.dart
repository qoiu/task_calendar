import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:qoiu_utils/extensions/list_extensions.dart';
import 'package:task_calendar/project_module/database/project_database.dart';
import 'package:task_calendar/project_module/models/editable_field.dart';
import 'package:task_calendar/project_module/models/project_data.dart';
import 'components/add_divider_button.dart';
import 'components/add_item_button.dart';
import 'components/divider_item.dart';
import 'components/task_container.dart';
import 'components/task_item.dart';
import 'material_icons/material_icons.dart';
import 'models/divider_data.dart';
import 'models/task_data.dart';

class TaskBoard extends StatefulWidget {
  final ProjectData project;

  const TaskBoard(this.project, {super.key});

  static double iconSize = 60;
  static double addIconSize = 40;

  @override
  State<TaskBoard> createState() => _TaskBoardState();
}

class _TaskBoardState extends State<TaskBoard> {
  bool showCreateMenu = false;
  OverlayPortalController createMenu = OverlayPortalController();
  List<String> logs = List.generate(10, (i) => '');
  late ProjectData project;
  EditableField editableField = EditableField();
  static double headerOffset = 50;

  final DividerData createDivider = DividerData(
    id: 0,
    projectId: 0,
    title: '',
    color: getColorScheme().outline,
    yPos: 0,
  );
  List<ProjectTaskData> tasks = [];
  List<DividerData> dividers = [];
  double scale = 1;
  Offset _offset = Offset.zero;
  double topOffset = 30;

  Offset get offset => _offset;

  set offset(Offset value) {
    _offset = Offset(min(0, value.dx), min(headerOffset + topOffset, value.dy));
  }

  final iconSize = TaskBoard.iconSize;

  double _previousScale = 1.0;

  @override
  void initState() {
    project = widget.project;
    offset = project.offset;
    ['offset', project.offset].print();
    ['offset', offset].print();
    scale = project.scale;
    super.initState();
    initProject();
  }

  initProject() async {
    tasks =
        await ProjectDatabase.tasks.getWhere("WHERE projectId='${project.id}'");
    dividers = await ProjectDatabase.dividers
        .getWhere("WHERE projectId='${project.id}'");
    ['dividers', dividers.map((e) => e.id).join(',')].print();
    setState(() {});
  }

  Widget logicWrapper({required Widget child}) {
    return Listener(
      onPointerDown: (e) {
        // FocusScope.of(context).unfocus();
      },
      onPointerSignal: kIsMobile
          ? null
          : (pointerSignal) {
              if (pointerSignal is PointerScrollEvent) {
                setState(() {
                  double delta = pointerSignal.scrollDelta.dy > 0 ? -0.1 : 0.1;
                  scale = (scale + delta).clamp(0.2, 4.0);
                });
              }
            },
      child: GestureDetector(
        onTap: () {
          clearFocus();
        },
        onScaleStart: (d) {
          _previousScale = 1;
        },
        onScaleUpdate: (details) {
          // logs[4] = '${details.pointerCount}';
          if (details.pointerCount > 1) {
            setState(() {
              double deltaScale = 1 - details.scale / _previousScale;
              // logs[3] = 'zoom + $deltaScale';
              scale = (scale + deltaScale * -1).clamp(0.2, 4.0);
              _previousScale = details.scale;
              offset += Offset(0, deltaScale > 1 ? -0.5 : 0.5);
            });
          } else {
            // logs[3] = 'pan';
            setState(() {
              offset += details.focalPointDelta / scale;
            });
          }
        },
        onScaleEnd: (e) {
          project.scale = scale;
          project.offset = offset;
          ProjectDatabase.projects.update(project.toDb(), project.id);
        },
        child: Container(color: Colors.transparent, child: child),
      ),
    );
  }

  onSelectItem() {
    bool update = false;
    if (dividers.any((e) => e.isEditTitle)) {
      dividers.forEach((e) => e.isEditTitle = false);
      update = true;
    }
    if (dividers.any((e) => e.isEdit)) {
      dividers.forEach((e) => e.isEdit = false);
      update = true;
    }
    if (tasks.any((e) => e.editTitle)) {
      tasks.forEach((e) => e.editTitle = false);
      update = true;
    }
    if (update) {
      setState(() {});
    }
  }

  void clearFocus() {
    FocusScope.of(context).unfocus();
    onSelectItem();
    editableField.clear();
  }

  int dividerOnPan(DividerData item, e) {
    setState(() {
      double area = TaskBoard.iconSize * 2;
      int cPosition = (e.globalPosition.dy / scale - offset.dy).toInt();

      var others = dividers.where((d) => d.id != item.id).toList()
        ..sort((a, b) => a.yPos.compareTo(b.yPos));

      bool hasCollision = others.any((d) => (cPosition - d.yPos).abs() < area);

      if (!hasCollision) {
        item.yPos = cPosition;
      } else {
        int? bestY;
        double minDelta = double.infinity;

        int topY = (others.first.yPos - area).toInt();
        if ((cPosition - topY).abs() < minDelta) {
          bestY = topY;
          minDelta = (cPosition - topY).abs().toDouble();
        }

        for (int i = 0; i < others.length - 1; i++) {
          var current = others[i];
          var next = others[i + i];

          if ((next.yPos - current.yPos) >= (area * 2)) {
            int gapY = (current.yPos + area).toInt();
            if ((cPosition - gapY).abs() < minDelta) {
              bestY = gapY;
              minDelta = (cPosition - gapY).abs().toDouble();
            }
          }
        }
        int bottomY = (others.last.yPos + area).toInt();
        if ((cPosition - bottomY).abs() < minDelta) {
          bestY = bottomY;
        }

        item.yPos = max(0, bestY ?? cPosition);
      }

      dividers.sort((a, b) => a.yPos.compareTo(b.yPos));
    });
    return item.yPos;
  }

  Offset taskOnPan(DragUpdateDetails details, [ProjectTaskData? item]) {
    var globalPos = details.globalPosition;
    Offset cPosition = Offset(
        globalPos.dx / scale - offset.dx, globalPos.dy / scale - offset.dy);
    cPosition -= Offset(TaskBoard.iconSize / 2, TaskBoard.iconSize / 2);
    double? snappedX;
    double? snappedY;
    final double threshold = TaskBoard.iconSize / 2;
    for (var otherTask in tasks.where((e) => e != item)) {
      var diffX = (cPosition.dx - otherTask.offset.dx).abs();
      if (snappedX == null && diffX < threshold) {
        snappedX = otherTask.offset.dx;
      }
      var diffY = (cPosition.dy - otherTask.offset.dy).abs();
      if (snappedY == null && diffY < threshold) {
        snappedY = otherTask.offset.dy;
      }
      if (snappedX != null && snappedY != null) break;
    }
    return Offset(
        max(0, snappedX ?? cPosition.dx), max(0, snappedY ?? cPosition.dy));
  }

  bool isTaskVisible({
    required Offset taskPosition, // Исходная позиция задачи (x, y)
    required Size screenSize, // Размер экрана (MediaQuery.of(context).size)
  }) {
    final double margin = iconSize;
    double screenX = (taskPosition.dx) + offset.dx;
    double screenY = (taskPosition.dy) + offset.dy;

    var rightBorder = screenSize.width / scale;
    bool isWithinHorizontal = screenX > -margin && screenX < rightBorder;

    bool isWithinVertical = screenY > -margin &&
        screenY < screenSize.height / scale - 30; //30 - bottomBar

    return isWithinHorizontal && isWithinVertical;
  }

  @override
  Widget build(BuildContext context) {
    logs[0] =
        '(${offset.dx.toStringAsFixed(0)},${offset.dy.toStringAsFixed(0)})';
    logs[1] = 'scale: $scale';
    var headerScaledOffset = headerOffset * scale;
    logs[2] = 'offset: $headerScaledOffset';
    var screen = MediaQuery.sizeOf(context);
    topOffset = MediaQuery.of(context).viewPadding.top / scale;
    var visibleTasks = tasks
        .where((e) => isTaskVisible(taskPosition: e.offset, screenSize: screen))
        .toList();
    return logicWrapper(
      child: Stack(
        children: [
          // Container(
          //     padding: EdgeInsets.only(
          //       top: MediaQuery.of(context).viewPadding.top,
          //     ),
          //     child: Text(
          //       logs.where((e) => e.isNotEmpty).join('\n'),
          //       style: getTextStyle()
          //           .bodyMedium
          //           ?.copyWith(fontSize: kReleaseMode ? 6 : null),
          //     )),
          Positioned(
              top: (offset.dy - headerOffset) * scale,
              left: (offset.dx)*scale,
              child: Container(
                width: 300*scale,
                height: headerOffset * scale,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                // color: getColorScheme().primary,
                child: FittedBox(
                    child: Container(
                        width: 400,
                        height: 30,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: getColorScheme().outline)),
                        child: Text(
                          project.title,
                          style: getTextStyle()
                              .bodyMedium
                              ?.copyWith(color: getColorScheme().outline),
                        ))),
              )),
          ...dividers.indexedMap(
            (index, item) => Positioned(
              top: (item.yPos + offset.dy) * scale,
              child: DividerItem(
                key: item.key,
                scale: scale,
                item: item,
                onPanUpdate: (e) => dividerOnPan(item, e),
                onTap: () {
                  if (item.isEdit) {
                    item.isEdit = false;
                  } else {
                    onSelectItem();
                    item.isEdit = true;
                  }
                  setState(() {});
                },
                onSelect: () async {
                  onSelectItem();
                  setState(() {
                    item.isEditTitle = true;
                    editableField.setup(
                        text: item.title,
                        onChange: (e) {
                          setState(() {
                            item.title = e;
                          });
                        },
                        onDone: (e) {
                          ProjectDatabase.tasks.update(item.toDb(), item.id);
                          setState(() {
                            item.isEditTitle = false;
                          });
                        });
                  });
                  await Future.delayed(const Duration(milliseconds: 100));
                  FocusScope.of(context).requestFocus(editableField.focusNode);
                },
                height: dividers.last.id == item.id || dividers.length == 1
                    ? MediaQuery.heightOf(context) -
                        (item.yPos + offset.dy) * scale
                    : ((dividers[index + 1].yPos - item.yPos) * scale).abs(),
              ),
            ),
          ),
          ...visibleTasks.map(
            (item) => Positioned(
              left: (item.offset.dx + offset.dx) * scale,
              top: (item.offset.dy + offset.dy) * scale,
              child: TaskItem(
                item,
                size: iconSize * scale,
                onSelect: () async {
                  onSelectItem();
                  setState(() {
                    editableField.setup(
                        text: item.title,
                        onChange: (e) {
                          setState(() {
                            item.title = e;
                          });
                        },
                        onDone: (e) {
                          ProjectDatabase.tasks.update(item.toDb(), item.id);
                          setState(() {
                            item.editTitle = false;
                          });
                        });
                  });
                  await Future.delayed(const Duration(milliseconds: 100));
                  FocusScope.of(context).requestFocus(editableField.focusNode);
                },
                onPanUpdate: (e) {
                  var offset = taskOnPan(e, item);
                  setState(() {
                    item.offset = offset;
                  });
                  return offset;
                },
              ),
            ),
          ),
          Positioned(
            top: (offset.dy) * scale,
            left: (offset.dx + 200) * scale,
            child: Container(
              width: 5,
              height: 5,
              color: getColorScheme().primary,
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 10,
              children: [
                Expanded(
                    child: editableField.isEdit
                        ? GestureDetector(
                            onTap: () {
                              'tap'.print();
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                                color: Colors.transparent,
                                child: TextField(
                                  controller: editableField.controller,
                                  focusNode: editableField.focusNode,
                                  autofocus: true,
                                  onChanged: editableField.onChange,
                                  onSubmitted: (text) {
                                    editableField.clear();
                                  },
                                )))
                        : Container()),
                TaskContainer(
                  thin: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AddDividerButton(
                        scale: scale,
                        onPanUpdate: (e) =>
                            (dividerOnPan(createDivider, e) * scale +
                                    offset.dy * scale)
                                .toInt(),
                        onDone: (e) async {
                          var newDivider = await ProjectDatabase.dividers
                              .addAndUse(DividerData(
                            id: 0,
                            projectId: project.id,
                            title: '',
                            color: getColorScheme().outline.withAlpha(0),
                            yPos: (e.dy / scale).toInt(),
                          ).toDb());
                          setState(() {
                            dividers.add(
                              newDivider,
                            );
                            dividers.sort((a, b) => a.yPos - b.yPos);
                            ['dividers', dividers.map((e) => e.yPos)].print();
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      AddItemButton(
                        scale: scale,
                        follower: TaskContainer(
                          padding: EdgeInsets.zero,
                          size: iconSize * scale * 0.8,
                          child: MaterialIcons.fromInt(57628),
                        ),
                        onPanUpdate: (e) =>
                            taskOnPan((e)) * scale + offset * scale,
                        onDone: (e) {
                          var newTask = ProjectTaskData(
                            id: 1,
                            projectId: project.id,
                            title: 'Новая задача',
                            offset: ((e) / scale) - offset,
                            icon: 57628,
                            status: TaskStatus.unknown,
                          );
                          setState(() {
                            tasks.add(
                              newTask,
                            );
                          });
                          ProjectDatabase.tasks.add(newTask.toDb());
                        },
                        child: TaskContainer(
                          size: TaskBoard.addIconSize,
                          padding: EdgeInsets.zero,
                          child: MaterialIcons.fromInt(57628),
                        ),
                      ),
                      const SizedBox(height: 10),
                      AddItemButton(
                        scale: scale,
                        follower: TaskContainer(
                          padding: EdgeInsets.zero,
                          size: iconSize * scale * 0.8,
                          color: getColorScheme().error,
                          child: MaterialIcons.fromInt(
                            57621,
                            color: getColorScheme().error,
                          ),
                        ),
                        onPanUpdate: (e) =>
                            taskOnPan((e)) * scale + offset * scale,
                        onDone: (e) {
                          setState(() {
                            tasks.add(
                              ProjectTaskData(
                                id: 1,
                                projectId: project.id,
                                title: 'Новый баг',
                                offset: (e / scale) - offset,
                                icon: 57621,
                                status: TaskStatus.failed,
                              ),
                            );
                          });
                        },
                        child: TaskContainer(
                          size: TaskBoard.addIconSize,
                          padding: EdgeInsets.zero,
                          color: getColorScheme().error,
                          child: MaterialIcons.fromInt(
                            57621,
                            color: getColorScheme().error,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => MaterialIcons.navigate(context),
                        child: TaskContainer(
                          padding: EdgeInsets.zero,
                          size: iconSize * scale * 0.8,
                          color: getColorScheme().error,
                          child:
                              Icon(Icons.add, color: getColorScheme().primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
