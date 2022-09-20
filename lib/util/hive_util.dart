import 'dart:io';

import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

import '../api_resp/team_resp.dart';
import '../api_resp/target_resp.dart';
import '../api_resp/user_resp.dart';

enum Keys { accessToken, isInitChat, user, userInfo, groupPriority }

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
    Hive.registerAdapter(TargetRespAdapter());
    Hive.registerAdapter(TeamRespAdapter());
  }

  // 这个存储一些键值
  late Box uniqueBox;
  late Box keyValueBox;
  late String currentTargetId;

  Future<void> initUniqueBox() async {
    uniqueBox = await Hive.openBox("uniqueBox");
  }

  // 初始化系统参数
  Future<void> initEnvParams(String targetId) async {
    // 初始化键值对，不同参数保存在不同的文件中
    keyValueBox = await Hive.openBox("keyValueBox_$targetId");

    // 初始化当前用户
    currentTargetId = targetId;
  }

  set accessToken(accessToken) => uniqueBox.put("accessToken", accessToken);

  get accessToken => uniqueBox.get("accessToken");

  dynamic getValue(Keys key) {
    return keyValueBox.get("$currentTargetId${key.name}");
  }

  dynamic putValue(Keys key, dynamic value) {
    return keyValueBox.put("$currentTargetId${key.name}", value);
  }
}
