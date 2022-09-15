import 'package:sqflite/sqflite.dart';

class SqliteUtil {
  SqliteUtil._();

  static final SqliteUtil _instance = SqliteUtil._();

  factory SqliteUtil() {
    return _instance;
  }

  late Database dataBase;

  Future<void> init() async {
    dataBase = await openDatabase("orginone.db");
  }

  Future<void> close() async {
    await dataBase.close();
  }
}
