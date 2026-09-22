import 'dart:convert';
import 'dart:ui';

import 'package:qoiu_db/database/db_entity.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:qoiu_utils/typedef.dart';
import 'package:task_calendar/utils/json_map_extension.dart';

const Offset _baseOffset = Offset(0,50);
class ProjectData extends DbEntity{
  @override
  final int id;
  String title;
  Offset offset;
  double scale;

  ProjectData(
      {this.id=-1,
      required this.title,
      this.offset = _baseOffset,
      this.scale = 1});

  ProjectData.fromDB(JsonMap json)
      : id = json['id'],
        title = json['title'].toString(),
        offset =json.extra?.let((e)=>Offset(e['offsetX'] ?? 0, e['offsetY'] ?? 50))??_baseOffset,
        scale = json.extra?['scale'] ?? 1;

  @override
  JsonMap toDB() => {
        'title': title,
        'extra': jsonEncode({
          'offsetX': offset.dx,
          'offsetY': offset.dy,
          'scale': scale,
        })
      };
}
