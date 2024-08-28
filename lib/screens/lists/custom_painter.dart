import 'dart:math';

import 'package:flutter/material.dart';
import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/screens/lists/models/custom_data.dart';
import 'package:task_calendar/utils/utils.dart';

class ListPainter extends CustomPainter {
  final CustomListController controller;

  ListPainter(this.controller);

  @override
  void paint(Canvas canvas, Size size) {
    controller.regions.clear();
    drawDates(canvas, size);
  }

  drawDates(Canvas canvas, Size size) {
    // 'y: ${controller.yOffset}'.dpBlue().print();
    Paint paint = Paint()
      ..color = getColorScheme().primary.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    Paint linePaint = Paint()..color = getColorScheme().onPrimary;
    double nextItemH = 0.0;
    double firstDateOffset = 0.0;
    double secondDateOffset = 0.0;
    for (var date in controller.drawTaskHelper.dates) {
      var index = controller.drawTaskHelper.dates.indexOf(date);
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
        var timeStart = nextItemH;
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
        var taskOffset = nextItemH;
        for (UiTask task in time.tasks) {
          task.task.title.dpBlue().print();
          var rect = Rect.fromLTWH(textWidth + 20, taskOffset - 5,
              size.width - textWidth - 30, textHeight + 5);
          rect.toString().dpGreen().print();
          drawTask(canvas, rect.size,
              Offset(rect.left, rect.top + controller.yOffset), task.task);
          controller.regions.addEntries([MapEntry(rect, task)]);
          taskOffset += textHeight + 5;
        }
        nextItemH = max(nextItemH + textHeight, taskOffset);
        canvas.drawLine(Offset(0, controller.yOffset + nextItemH),
            Offset(size.height, controller.yOffset + nextItemH + 1), linePaint);
        nextItemH += 5;
        var rect =
            Rect.fromLTWH(0, timeStart, size.width, nextItemH - timeStart);
        controller.regions.addEntries([MapEntry(rect, time)]);
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
      controller.currentDate =
          controller.currentDate.add(const Duration(days: -1));
      controller.updateDates();
      controller.yOffset -= firstDateOffset;
      "newOffset: ${controller.yOffset}".dpRed().print();
      controller.updateDates();
      // drawDates(canvas, size);
      return;
    }
    if (controller.yOffset < secondDateOffset * -1 && secondDateOffset > 0) {
      controller.currentDate =
          controller.currentDate.add(const Duration(days: 1));
      controller.yOffset += secondDateOffset - firstDateOffset;
      "newOffset: ${controller.yOffset}".dpRed().print();
      controller.updateDates();
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
      textDirection: TextDirection.ltr,
    );
    timeTextPainter.layout(maxWidth: size.width);
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
