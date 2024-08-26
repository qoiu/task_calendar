import 'package:flutter/material.dart';
import 'package:task_calendar/components/svg_button.dart';
import 'package:task_calendar/database/tasks_database.dart';
import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/screens/lists/components/list_date_time_item.dart';
import 'package:task_calendar/utils/utils.dart';

class MainCustomListScreen extends StatefulWidget {
  const MainCustomListScreen({super.key});

  @override
  State<MainCustomListScreen> createState() => _MainCustomListScreenState();
}

class _MainCustomListScreenState extends State<MainCustomListScreen> {
  CustomListController offsetController = CustomListController();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    offsetController.updateDate = updateDates;
  }

  updateDates() async {
    'updateDates'.dpRed().printLong();
    try {
      // var id = await tasksDatabase.database.insert(
      //     'tasks',
      //     Task(title: 'test', start: DateTime.now(), end: DateTime.now())
      //         .toDb(),
      //     conflictAlgorithm: ConflictAlgorithm.replace);
      // 'create $id'.dpGreen().print();
      tasks = (await tasksDatabase.database.query('tasks'))
          .map((e) => Task.fromJson(e))
          .toList();
      tasks.toString().dpRed().printLong();
      'updateDates'.dpRed().print();
    } on Exception catch (e) {
      e.toString().dpRed().printLong();
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
            onVerticalDragUpdate: (drag) {
              offsetController.yOffset += drag.delta.dy;
              setState(() {});
            },
            child: Container(
                color: Colors.transparent,
                width: double.maxFinite,
                height: double.maxFinite,
                child: CustomPaint(
                  painter: ListPainter(
                      times: List.generate(50, (i) {
                        return ListDateTimeItem(formatDate.format(
                            offsetController.currentDate
                                .add(Duration(days: i - 1))));
                      }),
                      tasks: tasks,
                      controller: offsetController),
                ))),
        Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.all(15),
          child: SvgButton('assets/svg/ic_plus.svg', () {
            setState(() {
              offsetController.yOffset -= 100;
            });
          }),
        )
      ],
    );
  }
}

class ListPainter extends CustomPainter {
  final List<ListDateTimeItem> times;
  final List<Task> tasks;
  final CustomListController controller;

  ListPainter(
      {required this.times, required this.controller, required this.tasks});

  @override
  void paint(Canvas canvas, Size size) {
    drawDates(canvas, size);
  }

  drawDates(Canvas canvas, Size size) {
    'y: ${controller.yOffset}'.dpBlue().print();
    Paint paint = Paint()
      ..color = getColorScheme().primary.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    Paint linePaint = Paint()..color = getColorScheme().onPrimary;
    double nextItemH = 0.0;
    double firstDateOffset = 0.0;
    double secondDateOffset = 0.0;
    times.first.date.dpGreen().print();
    for (var date in times) {
      var index = times.indexOf(date);
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: date.date,
          style: getTextStyle().bodyMedium,
        ),
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      double textWidth = textPainter.width;
      double textHeight = textPainter.height;

      RRect rRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
            (size.width - textWidth) / 2 - 10,
            controller.yOffset + nextItemH - 10,
            textWidth + 20,
            textHeight + 20),
        const Radius.circular(20),
      );
      canvas.drawRRect(rRect, paint);

      textPainter.paint(
          canvas,
          Offset(
            (size.width - textWidth) / 2,
            controller.yOffset + nextItemH,
          ));

      date.date;
      nextItemH += textHeight + 10;
      for (var time
          in List.generate(24, (i) => '${i.toString().padLeft(2, '0')}:00')) {
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: time,
            style: getTextStyle().bodyMedium,
          ),
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        double textWidth = textPainter.width;
        double textHeight = textPainter.height;

        textPainter.paint(canvas, Offset(10, controller.yOffset + nextItemH));
        nextItemH.toString().dpYellow();
        if (time == '12:00') {
          drawTask(
              canvas,
              Size(size.width - textWidth - 30, textHeight + 5),
              Offset(textWidth + 20, nextItemH + controller.yOffset - 5),
              Task(
                  title:
                      'titadfs adfsjkafdsn;lfdns f sfs;kln;fsa klfs; afsk; fasl; ls; ; fsfasl;kj fslfsafksfjk as;a fs fk; fjk;le',
                  start: DateTime.now(),
                  end: DateTime.now()));
        }
        nextItemH += textHeight;
        canvas.drawLine(Offset(0, controller.yOffset + nextItemH),
            Offset(size.height, controller.yOffset + nextItemH + 1), linePaint);
        nextItemH += 5;
        if (controller.yOffset + nextItemH > size.height + 100) {
          break;
        }
      }
      if (controller.yOffset + nextItemH > size.height + 100) {
        break;
      }
      nextItemH += 20;
      if (index == 0) {
        firstDateOffset = nextItemH;
      }
      if (index == 1) {
        secondDateOffset = nextItemH;
      }
    }
    if (controller.yOffset > 0 && firstDateOffset > 0) {
      controller.updateDate();
      controller.currentDate =
          controller.currentDate.add(const Duration(days: -1));
      controller.yOffset -= firstDateOffset;
      "newOffset: ${controller.yOffset}".dpRed().print();
      controller.updateDate();
      // drawDates(canvas, size);
      return;
    }
    "${controller.yOffset}<secondDateOffset: ${secondDateOffset * -1}"
        .dpRed()
        .print();
    if (controller.yOffset < secondDateOffset * -1 && secondDateOffset > 0) {
      controller.currentDate =
          controller.currentDate.add(const Duration(days: 1));
      controller.yOffset += secondDateOffset - firstDateOffset;
      "newOffset: ${controller.yOffset}".dpRed().print();
      controller.updateDate();
      // drawDates(canvas, size);
      return;
    }
    canvas.save();
    canvas.restore();
  }

  drawTask(Canvas canvas, Size size, Offset offset, Task task) {
    Paint paint = Paint()
      ..color = getColorScheme().primary.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    RRect rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height),
      const Radius.circular(20),
    );
    canvas.drawRRect(rRect, paint);
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: task.title,
        style:
            getTextStyle().bodyLarge?.copyWith(overflow: TextOverflow.ellipsis),
      ),
      textAlign: TextAlign.left,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: size.width - 5);
    textPainter.paint(canvas, Offset(offset.dx + 5, offset.dy));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CustomListController {
  double yOffset = 0.0;
  DateTime currentDate = DateTime.now();
  Function() updateDate = () {};
}
