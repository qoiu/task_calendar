import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:task_calendar/project_module/task_board.dart';

import 'components/task_container.dart';

class AddDividerButton extends StatefulWidget {
  final double scale;
  final Function(Offset) onDone;
  final int Function(DragUpdateDetails)? onPanUpdate;

  const AddDividerButton({
    super.key,
    required this.scale,
    this.onPanUpdate,
    required this.onDone,
  });

  @override
  State<AddDividerButton> createState() => _AddDividerButtonState();
}

class _AddDividerButtonState extends State<AddDividerButton> {
  OverlayEntry? _overlayEntry;
  late Offset _currentPosition;

  void _showFollower(BuildContext context, Offset globalPos) {
    _currentPosition = globalPos;
    ['start_pos', _currentPosition].print();

    _overlayEntry = OverlayEntry(
      builder: (context) => StatefulBuilder(
        builder: (context, setOverlayState) {
          return Positioned(
            top: _currentPosition.dy,
            child: FractionalTranslation(
              translation: const Offset(0, 0),
              child: IgnorePointer(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: MediaQuery.widthOf(context),
                    height: 2,
                    child: DottedLine(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      lineLength: MediaQuery.widthOf(context),
                      lineThickness: 2 * widget.scale,
                      dashLength: 4.0,
                      dashColor: getColorScheme().outline,
                      dashRadius: 0.0,
                      dashGapLength: 8.0,
                      dashGapColor: Colors.transparent,
                      dashGapRadius: 0.0,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideFollower() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (details) {
        _showFollower(context, details.globalPosition);
      },
      onPanUpdate: (details) {
        // _updateFollower(details.globalPosition);
        widget.onPanUpdate?.let((e){


          _currentPosition = Offset(0, e(details).toDouble());

          _overlayEntry?.markNeedsBuild();
        });
      },
      onPanEnd: (details) {
        _hideFollower();

        double newX =
            _currentPosition.dx;
        double newY =
            _currentPosition.dy;
        widget.onDone(Offset(newX, newY));
      },
      child: TaskContainer(
        size: TaskBoard.addIconSize,
        color: getColorScheme().outline,
        padding: EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            FittedBox(
              child: SizedBox(
                width: 120,
                height: 2,
                child: DottedLine(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  lineLength: MediaQuery.widthOf(context),
                  lineThickness: 1,
                  dashLength: 4.0,
                  dashColor: getColorScheme().outline,
                  dashRadius: 0.0,
                  dashGapLength: 8.0,
                  dashGapColor: Colors.transparent,
                  dashGapRadius: 0.0,
                ),
              ),
            ),
            const SizedBox(height: 5),
            FittedBox(
              child: SizedBox(
                width: 40,
                child: Text('div', textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hideFollower();
    super.dispose();
  }
}
