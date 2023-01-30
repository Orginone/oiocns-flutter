import 'dart:io';

import 'package:hive_flutter/adapters.dart';
import 'package:orginone/dart/base/model/team_resp.dart';
import 'package:orginone/dart/base/model/user_resp.dart';
import 'package:path_provider/path_provider.dart';

class HiveUtil {
  HiveUtil._();

  static final HiveUtil _instance = HiveUtil._();

  factory HiveUtil() {
    return _instance;
  }

  Future<void> init() async {
    Directory document = await getApplicationDocumentsDirectory();
    Hive.init(document.path);
    Hive.initFlutter();

    // 初始化适配器
    initAdapters();

    // 初始化全局唯一盒子
    await initUniqueBox();
  }

  Future<void> initAdapters() async {
    Hive.registerAdapter(UserRespAdapter());
    Hive.registerAdapter(TeamRespAdapter());
  }

  // 这个存储一些键值
  late Box uniqueBox;

  Future<void> initUniqueBox() async {
    uniqueBox = await Hive.openBox("uniqueBox");
  }
}
