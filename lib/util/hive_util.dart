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
  }

  Future<void> initAdapters() async {
    Hive.registerAdapter(UserRespAdapter());
    Hive.registerAdapter(TargetRespAdapter());
    Hive.registerAdapter(TeamRespAdapter());
  }

  // 这个存储一些键值
  late Box keyValueBox;
  late String currentAccount;
  late final String _groupPriorityKey = "$currentAccount${Keys.groupPriority.name}";

  // 初始化系统参数
  Future<void> initEnvParams(String account) async {
    // 初始化键值对，不同参数保存在不同的文件中
    keyValueBox = await Hive.openBox("keyValueBox_$account");

    // 初始化当前用户
    currentAccount = account;

    // 初始化聊天的优先级
    if (!keyValueBox.containsKey(_groupPriorityKey)) {
      keyValueBox.put(_groupPriorityKey, 0);
    }
  }

  dynamic getValue(Keys key) {
    return keyValueBox.get(currentAccount + key.name);
  }

  dynamic putValue(Keys key, dynamic value) {
    return keyValueBox.put(currentAccount + key.name, value);
  }

  int groupPriorityAddAndGet() {
    int groupPriorityValue = keyValueBox.get(_groupPriorityKey);
    groupPriorityValue++;
    keyValueBox.put(_groupPriorityKey, groupPriorityValue);

    return groupPriorityValue;
  }
}
