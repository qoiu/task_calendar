import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_picker_plus/flutter_color_picker_plus.dart';
import 'package:qoiu_utils/qoiu_utils.dart';

import '../divider_data.dart';
import '../material_icons.dart';

class DividerItem extends StatefulWidget {
  final double scale;
  final DividerData item;
  final double height;
  final Function(DragUpdateDetails)? onPanUpdate;

  const DividerItem({
    required this.item,
    required this.scale,
    required this.height,
    this.onPanUpdate,
    super.key,
  });

  @override
  State<DividerItem> createState() => _DividerItemState();
}

class _DividerItemState extends State<DividerItem> {
  bool isHovered = false;
  bool isEdit = false;
  bool isDragging = false;

  final duration = Duration(milliseconds: 400);
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  TextEditingController titleController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.item.title;
    focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!focusNode.hasFocus) {
      widget.item.title = titleController.text;
      setState(() {
        isEdit = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.removeListener(_handleFocusChange);
    focusNode.dispose();
    titleController.dispose();
  }

  void _showFollower(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        // Stack нужен, чтобы клик мимо закрывал окно
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                _overlayEntry?.remove();
                _overlayEntry = null;
              },
              child: Container(color: Colors.transparent),
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, 30),
            child: Material(
              color: Colors.transparent,
              child: FittedBox(
                child: Container(
                  width: 270,
                  height: 490,
                  decoration: BoxDecoration(
                    color: getColorScheme().outline.withAlpha(30),
                    border: Border.all(color: getColorScheme().outline),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                  child: StatefulBuilder(
                    builder: (context, setOverlayState) {
                      return ColorPicker(
                        pickerColor: widget.item.color,
                        portraitOnly: true,
                        colorPickerWidth: 270,
                        onColorChanged: (color) {
                          setOverlayState(() {
                            widget.item.color = color;
                          });
                          setState(() {}); // Обновляем основной виджет
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    bool show = isHovered || isEdit || isDragging;
    return Stack(
      children: [
        IgnorePointer(
          child: Container(
            width: MediaQuery.widthOf(context),
            height: widget.height,
            decoration: BoxDecoration(color: widget.item.color),
            child: DottedLine(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              lineLength: MediaQuery.widthOf(context),
              lineThickness: 2 * widget.scale,
              dashLength: 4.0,
              dashColor: widget.item.color.a > 0.5
                  ? getColorScheme().outline
                  : widget.item.color.withAlpha(255),
              dashRadius: 0.0,
              dashGapLength: 8.0,
              dashGapColor: Colors.transparent,
              dashGapRadius: 0.0,
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          onHover: (b) => setState(() {
            isHovered = b;
          }),
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Container(
            alignment: Alignment.topLeft,
            color: Colors.transparent,
            padding: EdgeInsets.all(5),
            child: Row(
              spacing: 10,
              children: [
                AnimatedDefaultTextStyle(
                  duration: duration,
                  style: getTextStyle().bodyMedium!.copyWith(
                    fontSize: show ? 12 : 10,
                    color: show
                        ? getColorScheme().primary
                        : getColorScheme().outline,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isEdit = true;
                      });
                    },
                    child: isEdit
                        ? IntrinsicWidth(
                            child: TextField(
                              controller: titleController,
                              autofocus: true,
                              focusNode: focusNode,
                              onSubmitted: (s) {
                                widget.item.title = s;
                                setState(() {
                                  isEdit = false;
                                });
                              },
                            ),
                          )
                        : Text(widget.item.title.ifEmpty('???')),
                  ),
                ),
                AnimatedOpacity(
                  opacity: (show | (_overlayEntry != null)) ? 1 : 0,
                  duration: duration,
                  child: CompositedTransformTarget(
                    link: _layerLink,
                    child: GestureDetector(
                      onTap: () => _showFollower(context),

                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: getColorScheme().outline.withAlpha(120),
                          ),
                        ),
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          Icons.color_lens_outlined,
                          size: 16,
                          color: getColorScheme().primary,
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: (show | isDragging) ? 1 : 0,
                  duration: duration,
                  child: GestureDetector(
                    onTap: () {},
                    onPanUpdate: widget.onPanUpdate,
                    onPanStart: (p) => setState(() {
                      isDragging = true;
                    }),
                    onPanEnd: (p) => setState(() {
                      isDragging = false;
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: getColorScheme().outline.withAlpha(120),
                        ),
                      ),
                      padding: EdgeInsets.all(2),
                      child: MaterialIcons.fromInt(63072, size: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
