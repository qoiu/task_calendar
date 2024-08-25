import 'package:flutter/material.dart';
import 'package:task_calendar/components/svg_button.dart';
import 'package:task_calendar/screens/lists/components/list_date_time_item.dart';
import 'package:task_calendar/utils/utils.dart';

class MainCustomListScreen extends StatefulWidget {
  const MainCustomListScreen({super.key});

  @override
  State<MainCustomListScreen> createState() => _MainCustomListScreenState();
}

class _MainCustomListScreenState extends State<MainCustomListScreen> {
  double yOffset=0.0;
  double extraOffset=0.0;
  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onVerticalDragUpdate: (drag){
            yOffset += drag.delta.dy;
            yOffset.toString().dpRed();
            setState(() {});
          },
          child: Container(
            color: Colors.transparent,
            width: double.maxFinite,
            height: double.maxFinite,
            child: Transform.translate(
              offset: Offset(0, extraOffset),
              child: CustomPaint(
                painter: ListPainter(
                  times: List.generate(6, (i){
                    return ListDateTimeItem(formatDate.format(currentDate.add(Duration(days: i-1))));
                  }),
                  yOffset: yOffset,
                  extraOffset: extraOffset
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.all(15),
          child: SvgButton(
            'assets/svg/ic_plus.svg', (){
              setState(() {
                setState(() {
                  extraOffset-=100;
                  extraOffset.toString().dpYellow().print();
                });
              });
          }
          ),
        )
      ],
    );
  }
}

class ListPainter extends CustomPainter{
  final List<ListDateTimeItem> times;
  final double yOffset;
  final double extraOffset;

  ListPainter({required this.times, required this.yOffset, required this.extraOffset});

  @override
  void paint(Canvas canvas, Size size) {
    drawDates(canvas, size);
  }
  
  drawDates(Canvas canvas, Size size){
    Paint paint = Paint()
      ..color = getColorScheme().primary.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    Paint linePaint = Paint()
      ..color = getColorScheme().onPrimary;
    double nextItemH=0.0;
    double firstDateOffset=0.0;
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
        Rect.fromLTWH((size.width-textWidth)/2-10, yOffset+nextItemH-10, textWidth+20, textHeight+20),
        const Radius.circular(20),
      );
      canvas.drawRRect(rRect, paint);

      textPainter.paint(canvas, Offset(
        (size.width - textWidth) / 2,
        yOffset+nextItemH,
      ));

      date.date;
      nextItemH+=textHeight+10;
      for (var time in List.generate(24, (i)=>'${i.toString().padLeft(2,'0')}:00')) {
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

        textPainter.paint(canvas, Offset(10, yOffset+nextItemH));
        nextItemH+=textHeight;
        canvas.drawLine(Offset(0, yOffset+nextItemH), Offset(size.height,yOffset+nextItemH+1), linePaint);
        nextItemH+=5;
        if(yOffset+nextItemH>size.height+100){
          '${yOffset+nextItemH}>${size.height+100}'.dpRed().print();
          break;
        }
      }
      if(yOffset+nextItemH>size.height+100) {
        "${date.date} - break".dpRed().print();
        break;
      }
      nextItemH+=20;
      if(index==0){
        firstDateOffset=nextItemH;
      }
    }
    canvas.save();
    'firstDateOffset: $firstDateOffset'.dpBlue().print();

    canvas.translate(0, yOffset+extraOffset);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}