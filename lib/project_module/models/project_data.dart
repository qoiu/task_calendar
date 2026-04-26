import 'dart:convert';
import 'dart:ui';

import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:qoiu_utils/typedef.dart';
import 'package:task_calendar/utils/json_map_extension.dart';

const Offset _baseOffset = Offset(0,50);
class ProjectData {
  final int id;
  String title;
  Offset offset;
  double scale;

  ProjectData(
      {required this.id,
      required this.title,
      this.offset = _baseOffset,
      this.scale = 1});

  ProjectData.fromDB(JsonMap json)
      : id = json['id'],
        title = json['title'].toString(),
        offset =json.extra?.let((e)=>Offset(e['offsetX'] ?? 0, e['offsetY'] ?? 50))??_baseOffset,
        scale = json.extra?['scale'] ?? 1;

  JsonMap toDb() => {
        'title': title,
        'extra': jsonEncode({
          'offsetX': offset.dx,
          'offsetY': offset.dy,
          'scale': scale,
        })
      };
}
