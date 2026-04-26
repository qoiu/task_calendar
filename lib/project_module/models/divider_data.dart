import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_color_picker_plus/flutter_color_picker_plus.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:qoiu_utils/typedef.dart';

class DividerData {
  final int id;
  final int projectId;
  String title;
  Color color;
  int yPos;
  GlobalKey key = GlobalKey();
  bool isEditTitle=false;
  bool isEdit=false;

  DividerData({
    required this.id,
    required this.projectId,
    required this.title,
    required this.color,
    required this.yPos,
  });

  DividerData.fromDB(JsonMap json)
      : id = json['id'],
        projectId = json['projectId'],
        title = json['title'].toString(),
        color = colorFromHex(json['color'])??getColorScheme().primary,
        yPos = json['yPos'];

  JsonMap toDb() => {
    'projectId': projectId,
    'title': title,
    'color': colorToHex(color),
    'yPos': yPos
  };
}
