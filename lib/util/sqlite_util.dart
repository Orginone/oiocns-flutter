import 'package:orginone/model/model.dart';
import 'package:sqflite/sqflite.dart';

class SqliteUtil {
  SqliteUtil._();

  static final SqliteUtil _instance = SqliteUtil._();

  factory SqliteUtil() {
    return _instance;
  }

  late var dataBase;
  late Orginone orginone;

  Future<void> init() async {
    dataBase = await openDatabase("orginone.db");
    orginone = Orginone();
  }

  Future<void> close() async {
    if (dataBase != null) {
      await dataBase.close();
    }
  }
}
