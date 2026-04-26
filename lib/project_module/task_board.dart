import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:qoiu_utils/extensions/list_extensions.dart';

import 'add_divider_button.dart';
import 'add_item_button.dart';
import 'components/divider_item.dart';
import 'components/task_container.dart';
import 'components/task_item.dart';
import 'divider_data.dart';
import 'material_icons.dart';
import 'models/task_data.dart';

class TaskBoard extends StatefulWidget {
  const TaskBoard({super.key});

  static double iconSize = 60;
  static double addIconSize = 40;

  @override
  State<TaskBoard> createState() => _TaskBoardState();
}

class _TaskBoardState extends State<TaskBoard> {
  bool showCreateMenu = false;
  OverlayPortalController createMenu = OverlayPortalController();
  List<String> logs = List.generate(10, (i) => '');
  final DividerData createDivider = DividerData(
    id: 0,
    title: '',
    color: getColorScheme().outline,
    yPos: 0,
  );
  List<ProjectTaskData> tasks = [];
  List<DividerData> dividers = [
    DividerData(
      id: 1,
      title: "title",
      color: getColorScheme().outline.withAlpha(0),
      yPos: 40,
    ),
  ];
  double scale = 1;
  Offset _offset = Offset.zero;

  Offset get offset => _offset;

  set offset(Offset value) {
    _offset = Offset(min(0, value.dx), min(20, value.dy));
  }

  final iconSize = TaskBoard.iconSize;

  double _previousScale = 1.0;

  Widget logicWrapper({required Widget child}) {
    return Listener(
      onPointerDown: (e) {
        FocusScope.of(context).unfocus();
      },
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          setState(() {
            double delta = pointerSignal.scrollDelta.dy > 0 ? -0.1 : 0.1;

            scale = (scale + delta).clamp(0.2, 4.0);
          });
        }
      },
      child: GestureDetector(
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
            });
          } else {
            // logs[3] = 'pan';
            setState(() {
              offset += details.focalPointDelta / scale;
            });
          }
        },
        child: Container(color: Colors.transparent, child: child),
      ),
    );
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

        item.yPos = bestY ?? cPosition;
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
    return Offset(snappedX ?? cPosition.dx, snappedY ?? cPosition.dy);
  }

  bool isTaskVisible({
    required Offset taskPosition, // Исходная позиция задачи (x, y)
    required Size screenSize,      // Размер экрана (MediaQuery.of(context).size)
  }) {
    final double margin = iconSize;
    double screenX = (taskPosition.dx) + offset.dx;
    double screenY = (taskPosition.dy) + offset.dy;

    var rightBorder = screenSize.width/scale;
    bool isWithinHorizontal = screenX  > -margin &&
        screenX < rightBorder;

    bool isWithinVertical = screenY > -margin &&
        screenY < screenSize.height/scale -30;//30 - bottomBar

    return isWithinHorizontal && isWithinVertical;
  }

  @override
  Widget build(BuildContext context) {
    logs[0] = '$offset';
    logs[1] = 'scale: $scale';
    var screen = MediaQuery.sizeOf(context);
    var visibleTasks = tasks.where((e)=>isTaskVisible(taskPosition: e.offset, screenSize: screen)).toList();
    return logicWrapper(
      child: Stack(
        children: [
          Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewPadding.top,
              ),
              child: Text(logs.where((e) => e.isNotEmpty).join('\n'))),
          ...dividers.indexedMap(
            (index, item) => Positioned(
              top: (item.yPos + offset.dy) * scale,
              child: DividerItem(
                key: item.key,
                scale: scale,
                item: item,
                onPanUpdate: (e) => dividerOnPan(item, e),
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
          Positioned(
            top: 270,
            left: (screen.width*scale)-5,
            // left: 50,
            child: Container(
              width: 5,
              height: 5,
              color: getColorScheme().primary,
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(10),
            child: TaskContainer(
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
                    onDone: (e) {
                      setState(() {
                        dividers.add(
                          DividerData(
                            id: dividers.map((e) => e.id).reduce(max) + 1,
                            title: '',
                            color: getColorScheme().outline.withAlpha(0),
                            yPos: (e.dy /scale).toInt(),
                          ),
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
                    onPanUpdate: (e) => taskOnPan((e)) * scale + offset * scale,
                    onDone: (e) {
                      setState(() {
                        tasks.add(
                          ProjectTaskData(
                            id: 1,
                            title: 'Новая задача',
                            offset: ((e) / scale) - offset,
                            icon: 57628,
                            status: TaskStatus.unknown,
                          ),
                        );
                      });
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
                    onPanUpdate: (e) => taskOnPan((e)) * scale + offset * scale,
                    onDone: (e) {
                      setState(() {
                        tasks.add(
                          ProjectTaskData(
                            id: 1,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
