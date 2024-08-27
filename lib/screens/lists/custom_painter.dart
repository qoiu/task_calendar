import 'dart:math';

import 'package:flutter/material.dart';
import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/screens/lists/models/custom_data.dart';
import 'package:task_calendar/utils/utils.dart';

class ListPainter extends CustomPainter {
  final List<Task> tasks;
  DrawTaskHelper datesHelper;
  final CustomListController controller;

  ListPainter(
      {required this.controller,
      required this.tasks,
      required this.datesHelper});

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
    for (var date in datesHelper.dates) {
      var index = datesHelper.dates.indexOf(date);
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: date.title,
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
      nextItemH += textHeight + 10;
      for (var time in date.times) {
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: time.title,
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
        var taskHeight = nextItemH;
        for (Task task in time.tasks) {
          drawTask(
              canvas,
              Size(size.width - textWidth - 30, taskHeight + 5),
              Offset(textWidth + 20, taskHeight + controller.yOffset - 5),
              task);
          taskHeight += textHeight + 5;
        }
        nextItemH += max(textHeight, taskHeight);
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
      ..color = task.color
      ..style = PaintingStyle.fill;
    RRect rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height),
      const Radius.circular(20),
    );
    canvas.drawRRect(rRect, paint);
    TextPainter timeTextPainter = TextPainter(
      text: TextSpan(
        text: task.time,
        style: getTextStyle()
            .bodySmall
            ?.copyWith(overflow: TextOverflow.ellipsis, color: task.textColor),
      ),
      textAlign: TextAlign.right,
      maxLines: 1,
      textDirection: TextDirection.rtl,
    );
    timeTextPainter.layout(maxWidth: size.width / 2);
    double textWidth = timeTextPainter.width;
    timeTextPainter.paint(
        canvas, Offset(size.width - textWidth / 2, offset.dy));
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: task.title,
        style: getTextStyle()
            .bodyLarge
            ?.copyWith(overflow: TextOverflow.ellipsis, color: task.textColor),
      ),
      textAlign: TextAlign.left,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: size.width - 5 - textWidth);
    textPainter.paint(canvas, Offset(offset.dx + 5, offset.dy));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
