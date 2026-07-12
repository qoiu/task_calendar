import 'package:qoiu_db/database/db_entity.dart';
import 'package:qoiu_utils/typedef.dart';

class TaskCategory extends DbEntity {
  final int id;
  final String title;

  TaskCategory({required this.id, required this.title});

  TaskCategory.fromDB(JsonMap map)
      : id = map['id'],
        title = map['title'];

  JsonMap toDB() => {'id': id, 'title': title};
}
