import 'package:flutter/material.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:task_calendar/project_module/task_board.dart';

class AddItemButton extends StatefulWidget {
  final double scale;
  final Widget child;
  final Widget follower;
  final Function(Offset) onDone;
  final Offset Function(DragUpdateDetails)? onPanUpdate;

  const AddItemButton({
    super.key,
    required this.child,
    required this.follower,
    required this.scale,
    this.onPanUpdate,
    required this.onDone,
  });

  @override
  State<AddItemButton> createState() => _AddItemButtonState();
}

class _AddItemButtonState extends State<AddItemButton> {
  OverlayEntry? _overlayEntry;
  late Offset _currentPosition;

  void _showFollower(BuildContext context, Offset globalPos) {
    _currentPosition = globalPos;
    ['start_pos',_currentPosition].print();

    _overlayEntry = OverlayEntry(
      builder: (context) => StatefulBuilder(
        builder: (context, setOverlayState) {
          return Positioned(
            left: _currentPosition.dx,
            top: _currentPosition.dy,
            child: FractionalTranslation(
              translation: const Offset(-0.5, -0.5),
              child: IgnorePointer(
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      widget.follower,
                    ],
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
        widget.onPanUpdate?.let((e){
          _currentPosition = e(details)+ Offset((TaskBoard.iconSize*widget.scale)/2,(TaskBoard.iconSize*widget.scale)/2);
          _overlayEntry?.markNeedsBuild();
        });
      },
      onPanEnd: (details) {
        _hideFollower();

        double newX = _currentPosition.dx - (TaskBoard.iconSize*widget.scale)/2;
        double newY = _currentPosition.dy - (TaskBoard.iconSize*widget.scale)/2;
        widget.onDone(Offset(newX, newY));
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _hideFollower();
    super.dispose();
  }
}