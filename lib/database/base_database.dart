import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:qoiu_utils/typedef.dart';
import 'package:sqflite/sqflite.dart';

class BaseDatabase<T> {
  final Database database;
  final String name;
  final T Function(JsonMap) fromDB;

  BaseDatabase(
      {required this.database, required this.name, required this.fromDB});

  ///@param where - "WHERE date='$day'"
  Future<List<T>> getWhere(String where) async {
    var response = await database.rawQuery("SELECT*FROM $name $where");
    'result: $response'.print();
    var result = response.map((e) {
      return fromDB(e);
    }).toList();
    return result;
  }

  Future<List<T>> getAll() async {
    var response = await database.rawQuery("SELECT*FROM $name");
    'result: $response'.print();
    var result = response.map((e) {
      return fromDB(e);
    }).toList();
    return result;
  }

  ///@param where - "WHERE date='$day'"
  Future<List<T>> getById(int id) async {
    var response = await database.rawQuery("SELECT*FROM $name");
    'result: $response'.print();
    var result = response.map((e) {
      return fromDB(e);
    }).toList();
    return result;
  }

  Future add(JsonMap item) async {
    database.insert(name, item);
  }

  Future update(JsonMap task) async {
    database.update(
      name,
      task,
      where: 'id = ?',
      whereArgs: [task['id']],
    );
  }

  Future<void> delete(int id) async {
    await database.delete(
      name,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
