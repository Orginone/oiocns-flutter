import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/base_get_list_state.dart';
import 'package:orginone/dart/core/thing/standard/index.dart';
import 'package:orginone/pages/chat/message_routers.dart';

class WorkBenchState extends BaseGetListState {
  ChatBreadcrumbNav? nav;

  ScrollController scrollController = ScrollController();
  //好友人数
  RxString friendNum = "0".obs;
  //同事个数
  RxString colleagueNum = "0".obs;
  //群聊个数
  RxString groupChatNum = "0".obs;
  //单位家数
  RxString companyNum = "0".obs;
  //待办
  RxString todoCount = "0".obs;
  //已办
  RxString completedCount = "0".obs;
  //抄送
  RxString copysCount = "0".obs;
  //发起的
  RxString applyCount = "0".obs;
  //关系(个)
  RxString relationNum = "0".obs;
  //没有存储
  RxBool noStore = false.obs;
  //磁盘信息
  late Rx<DiskInfoType> diskInfo = DiskInfoType(
    ok: 0,
    files: 0,
    objects: 0,
    collections: 0,
    fileSize: 0,
    dataSize: 0,
    totalSize: 0,
    fsUsedSize: 0,
    fsTotalSize: 0,
    getTime: "",
  ).obs;
  //常用应用菜单
  bool enabledSlidable = true;
  //应用
  RxList<IApplication> applications = <IApplication>[].obs;
}
