import 'dart:ui';

import 'package:flutter/cupertino.dart';

class DividerData {
  final int id;
  String title;
  Color color;
  int yPos;
  GlobalKey key = GlobalKey();

  DividerData({
    required this.id,
    required this.title,
    required this.color,
    required this.yPos,
  });
}
